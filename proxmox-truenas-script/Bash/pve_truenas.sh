#!/bin/bash

choose_distro() {
    echo -e "Welcome to the Proxmox Cloud-Init template installer!\n"
    PS3="Please choose a distro image to download (1-6): "
    local TRUENAS_SCALE_VERSION="24.04.0"
    local TRUENAS_CORE_VERSION="13.0"
    local TRUENAS_CORE_UPDATE="U6.1"

    local distro_list=("TrueNAS SCALE ${TRUENAS_SCALE_VERSION}" "TrueNAS CORE ${TRUENAS_CORE_VERSION}-${TRUENAS_CORE_UPDATE}" "Quit")
    select distro in "${distro_list[@]}"; do
        case $distro in
        "${distro_list[0]}")
            echo -e "${distro_list[0]}"
            TEMPLATE_NAME="TrueNAS-SCALE"
            OSTYPE="l26"
            IMAGE_URL="https://download.truenas.com/TrueNAS-SCALE-Cobia/${TRUENAS_SCALE_VERSION}/TrueNAS-SCALE-${TRUENAS_SCALE_VERSION}.iso"
            CLOUDIMG_NAME="TrueNAS-SCALE-${TRUENAS_SCALE_VERSION}.iso"
            CHECKSUM_URL="https://download.truenas.com/TrueNAS-SCALE-Cobia/${TRUENAS_SCALE_VERSION}/TrueNAS-SCALE-${TRUENAS_SCALE_VERSION}.iso.sha256"
            SHA=256
            break
            ;;
        "${distro_list[1]}")
            echo -e "${distro_list[1]}"
            TEMPLATE_NAME="TrueNAS-CORE"
            OSTYPE="other"
            IMAGE_URL="https://download.freenas.org/${TRUENAS_CORE_VERSION}/STABLE/${TRUENAS_CORE_UPDATE}/x64/TrueNAS-${TRUENAS_CORE_VERSION}-${TRUENAS_CORE_UPDATE}.iso"
            CLOUDIMG_NAME="TrueNAS-${TRUENAS_CORE_VERSION}-${TRUENAS_CORE_UPDATE}.iso"
            CHECKSUM_URL="https://download.freenas.org/${TRUENAS_CORE_VERSION}/STABLE/${TRUENAS_CORE_UPDATE}/x64/TrueNAS-${TRUENAS_CORE_VERSION}-${TRUENAS_CORE_UPDATE}.iso.sha256"
            CHECKSUM="$(curl -s "$CHECKSUM_URL" | grep -oP "(?<= = ).*$")  ${CLOUDIMG_NAME}"
            SHA=256
            break
            ;;
        "Quit")
            exit 0
            ;;
        *) echo -e "Invalid choice option $REPLY" ;;
        esac
    done
}

choose_id() {
    local existing_id=true
    while [ "$existing_id" = true ]; do
        while :; do
            echo -e "\n"
            read -r -ep 'Enter VM ID for the template (from 100): ' ID
            [[ $ID =~ ^[[:digit:]]+$ ]] || continue
            ((((ID = (10#$ID)) <= 999999999) && ID >= 100)) || continue
            break
        done
        if ( (qm status "${ID}" 2>/dev/null)); then
            echo -e "ID is in use"
            existing_id=true
        else
            existing_id=false
        fi
    done
}

choose_storage() {
    echo -e "\n" && pvesm status
    local existing_storage=false
    while [ "$existing_storage" = false ]; do
        read -r -ep 'Choose Promxox VE storage (by Name): ' STORAGE
        if ( (pvesm list "${STORAGE}" 2>/dev/null)); then
            existing_storage=true
        else
            echo -e "Invalid storage"
            existing_storage=false
        fi
    done
}

download_image() {
    pushd /var/lib/vz/template/iso || exit 1

    if [ -f "$CLOUDIMG_NAME" ]; then
        echo -e "\nDistro image already downloaded."

        local valid_choice=false
        local download=false
        while [ "$valid_choice" = false ]; do
            read -r -ep "Download image again? (y/n) " selection
            case "$selection" in
            y | Y | yes | Yes)
                download=true
                valid_choice=true
                ;;
            n | N | no | No)
                download=false
                valid_choice=true
                ;;
            *)
                echo -e "Invalid choice"
                valid_choice=false
                ;;
            esac
        done
    else
        download=true
    fi

    if [ "$download" = true ]; then
        wget "${IMAGE_URL}" -O "${CLOUDIMG_NAME}"
        if [ "$OSTYPE" = "l26" ]; then
            if (wget -q -O - "${CHECKSUM_URL}" | grep "${CLOUDIMG_NAME}" |
                sha"${SHA}"sum --strict --check --ignore-missing); then
                true
            else
                exit 1
            fi
        elif [ "$OSTYPE" = "other" ]; then
            if (echo "${CHECKSUM}" | grep "${CLOUDIMG_NAME}" |
                sha"${SHA}"sum --strict --check --ignore-missing); then
                true
            else
                exit 1
            fi
            true
        fi
    fi

    popd || exit 1
}

qm_create() {
    # create a new VM with VirtIO SCSI single controller
    qm create "${ID}" --name "${TEMPLATE_NAME}" --memory 8096 --core 1 \
        --net0 virtio,bridge=vmbr0,firewall=1 --scsihw virtio-scsi-single \
        --ostype "${OSTYPE}" \
        --agent "${agent_params}" \
        --cpu host --machine q35 --bios ovmf

    qm set "${ID}" --efidisk0 "${STORAGE}":0,format=qcow2,efitype=4m,pre-enrolled-keys=0,size=528K

    qm set "${ID}" --scsihw virtio-scsi-single \
        --scsi0 file="${STORAGE}":32,format=qcow2,iothread=1

    # qm set "${VMID}" --hostpci0 --hostpci0 host"${device-id}",pcie=1,rombar=1

    # configure a CD-ROM drive, with the installation ISO
    qm set "${ID}" --ide2 media=cdrom,file=none
    qm set "${ID}" --ide2 media=cdrom,file=local:iso/"${CLOUDIMG_NAME}"

    # set the boot parameter to order="ide2;scsi0"
    qm set "${ID}" --boot order="ide2;scsi0"
}

convert_to_template() {
    echo -e "\n"

    local valid_choice=false
    while [ "$valid_choice" = false ]; do
        read -r -ep "Convert VM to template? (y/n) " selection
        case "$selection" in
        y | Y | yes | Yes)
            # convert the VM into a template
            qm template "${ID}"
            valid_choice=true
            ;;
        n | N | no | No)
            true
            valid_choice=true
            ;;
        *)
            echo -e "Invalid choice"
            valid_choice=false
            ;;
        esac
    done
}

cleanup() {
    echo -e "\n"

    local valid_choice=false
    while [ "$valid_choice" = false ]; do
        read -r -ep "Perform post-install cleanup? (y/n) " selection
        case "$selection" in
        y | Y | yes | Yes)
            cleanup=true
            valid_choice=true
            ;;
        n | N | no | No)
            cleanup=false
            valid_choice=true
            ;;
        *)
            echo -e "Invalid choice"
            valid_choice=false
            ;;
        esac
    done

    if "${cleanup}"; then
        echo -e "\nPost-install cleanup:"

        local valid_choice=false
        while [ "$valid_choice" = false ]; do
            read -r -ep "Delete downloaded cloud image file? (y/n) " selection
            case "$selection" in
            y | Y | yes | Yes)
                rm "/var/lib/vz/template/iso/${CLOUDIMG_NAME}"
                valid_choice=true
                ;;
            n | N | no | No)
                true
                valid_choice=true
                ;;
            *)
                echo -e "Invalid choice"
                valid_choice=false
                ;;
            esac
        done

        echo -e "\n"
        local valid_choice=false
        while [ "$valid_choice" = false ]; do
            read -r -ep "Delete VM template that was JUST created by this script? (y/n) " selection
            case "$selection" in
            y | Y | yes | Yes)
                qm destroy "${ID}"
                valid_choice=true
                ;;
            n | N | no | No)
                true
                valid_choice=true
                ;;
            *)
                echo -e "Invalid choice"
                valid_choice=false
                ;;
            esac
        done
    fi
}

main() {
    choose_distro "$@"
    choose_id "$@"
    choose_storage "$@"
    # TEMPLATE_NAME="Template-TrueNAS"

    # download the ISO
    download_image "$@"

    # configure qemu-guest-agent parameters
    if [ "$OSTYPE" = "l26" ]; then
        agent_params="enabled=1,fstrim_cloned_disks=1"
    elif [ "$OSTYPE" = "other" ]; then
        agent_params="enabled=0"
    fi

    qm_create "$@"
    convert_to_template "$@"

    echo -e "\n"
    if ( (qm status "${ID}" 2>/dev/null)); then
        echo -e "Install complete!
${TEMPLATE_NAME} installed as #${ID}"
    else
        echo -e "Install failed. Please try again."
    fi

    cleanup "$@"
}

main "$@"

exit 0
