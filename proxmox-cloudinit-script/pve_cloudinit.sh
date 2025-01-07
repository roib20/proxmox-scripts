#!/bin/bash

choose_distro() {
    echo -e "Welcome to the Proxmox Cloud-Init template installer!\n"
    PS3="Please choose a distro image to download (1-12): "
    local distro_list=("Ubuntu Cloud 22.04 LTS" "Ubuntu Cloud 22.04 LTS (Minimal)" "Ubuntu Cloud 24.04 LTS" "Ubuntu Cloud 24.04 LTS (Minimal)" "Debian 11 (GenericCloud)" "Debian 12 (GenericCloud)"
        "Fedora Cloud 40 (base)" "Fedora Cloud 41 (base)" "AlmaLinux 9 (GenericCloud)" "RockyLinux 9 (GenericCloud)"  "FreeBSD 14.1 (Basic)" "CentOS 9 Stream (GenericCloud)" "Quit")
    select distro in "${distro_list[@]}"; do
        case $distro in
        "${distro_list[0]}")
            echo -e "${distro_list[0]}"
            IMAGE_URL="https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img"
            CHECKSUM_URL="https://cloud-images.ubuntu.com/releases/jammy/release/SHA256SUMS"
            SHA=256
            CLOUDIMG_NAME="ubuntu-22.04-server-cloudimg-amd64.img"
            break
            ;;
        "${distro_list[1]}")
            echo -e "${distro_list[1]}"
            IMAGE_URL="https://cloud-images.ubuntu.com/minimal/releases/jammy/release/ubuntu-22.04-minimal-cloudimg-amd64.img"
            CHECKSUM_URL="https://cloud-images.ubuntu.com/minimal/releases/jammy/release/SHA256SUMS"
            SHA=256
            CLOUDIMG_NAME="ubuntu-22.04-minimal-cloudimg-amd64.img"
            break
            ;;
        "${distro_list[2]}")
            echo -e "${distro_list[2]}"
            IMAGE_URL="https://cloud-images.ubuntu.com/releases/noble/release/ubuntu-24.04-server-cloudimg-amd64.img"
            CHECKSUM_URL="https://cloud-images.ubuntu.com/releases/noble/release/SHA256SUMS"
            SHA=256
            CLOUDIMG_NAME="ubuntu-24.04-server-cloudimg-amd64.img"
            break
            ;;
        "${distro_list[3]}")
            echo -e "${distro_list[3]}"
            IMAGE_URL="https://cloud-images.ubuntu.com/minimal/releases/noble/release/ubuntu-24.04-minimal-cloudimg-amd64.img"
            CHECKSUM_URL="https://cloud-images.ubuntu.com/minimal/releases/noble/release/SHA256SUMS"
            SHA=256
            CLOUDIMG_NAME="ubuntu-24.04-minimal-cloudimg-amd64.img"
            break
            ;;
        "${distro_list[4]}")
            echo -e "${distro_list[4]}"
            IMAGE_URL="https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2"
            CHECKSUM_URL="https://cloud.debian.org/images/cloud/bullseye/latest/SHA512SUMS"
            SHA=512
            CLOUDIMG_NAME="debian-11-genericcloud-amd64.qcow2"
            break
            ;;
        "${distro_list[5]}")
            echo -e "${distro_list[5]}"
            IMAGE_URL="https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
            CHECKSUM_URL="https://cloud.debian.org/images/cloud/bookworm/latest/SHA512SUMS"
            SHA=512
            CLOUDIMG_NAME="debian-12-genericcloud-amd64.qcow2"
            break
            ;;
        "${distro_list[6]}")
            echo -e "${distro_list[6]}"
            IMAGE_URL="https://download.fedoraproject.org/pub/fedora/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-Generic.x86_64-40-1.14.qcow2"
            CHECKSUM_URL="https://download.fedoraproject.org/pub/fedora/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-40-1.14-x86_64-CHECKSUM"
            SHA=256
            CLOUDIMG_NAME="Fedora-Cloud-40-1.14-x86_64.qcow2"
            break
            ;;
        "${distro_list[7]}")
            echo -e "${distro_list[7]}"
            IMAGE_URL="https://mirror.nl.mirhosting.net/fedora/linux/releases/41/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-41-1.4.x86_64.qcow2"
            CHECKSUM_URL="https://mirror.i3d.net/pub/fedora/linux/releases/41/Cloud/x86_64/images/Fedora-Cloud-41-1.4-x86_64-CHECKSUM"
            SHA=256
            CLOUDIMG_NAME="Fedora-Cloud-Base-Generic-41-1.4.x86_64.qcow2"
            break
            ;;
        "${distro_list[8]}")
            echo -e "${distro_list[8]}"
            IMAGE_URL="https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
            CHECKSUM_URL="https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/CHECKSUM"
            SHA=256
            CLOUDIMG_NAME="AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
            break
            ;;
        "${distro_list[9]}")
            echo -e "${distro_list[9]}"
            IMAGE_URL="https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2"
            CHECKSUM_URL="https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2.CHECKSUM"
            SHA=256
            CLOUDIMG_NAME="Rocky-9-GenericCloud.latest.x86_64.qcow2"
            break
            ;;
        "${distro_list[10]}")
            echo -e "${distro_list[10]}"
            IMAGE_URL="https://download.freebsd.org/releases/VM-IMAGES/14.1-RELEASE/amd64/Latest/FreeBSD-14.1-RELEASE-amd64-BASIC-CLOUDINIT-zfs.qcow2.xz"
            CHECKSUM_URL="https://download.freebsd.org/releases/VM-IMAGES/14.1-RELEASE/amd64/Latest/CHECKSUM.SHA256"
            SHA=256
            CLOUDIMG_NAME="FreeBSD-14.1-RELEASE-amd64-BASIC-CLOUDINIT-zfs.qcow2.xz"
            break
            ;;
        "${distro_list[11]}")
            echo -e "${distro_list[11]}"
            IMAGE_URL="https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2"
            CHECKSUM_URL="https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2.SHA256SUM"
            SHA=256
            CLOUDIMG_NAME="CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2"
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
    while [ ${existing_id} = true ]; do
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
    while [ ${existing_storage} = false ]; do
        read -r -ep 'Choose Promxox VE storage (by Name): ' STORAGE
        if ( (pvesm list "${STORAGE}" 2>/dev/null)); then
            existing_storage=true
        else
            echo -e "Invalid storage"
            existing_storage=false
        fi
    done

    echo -e "\n"
    local valid_choice=false
    while [ ${valid_choice} = false ]; do
        read -r -ep "Is the chosen storage using an SSD? (y/n) " selection
        case "$selection" in
        y | Y | yes | Yes)
            SSD=true
            valid_choice=true
            ;;
        n | N | no | No)
            SSD=false
            valid_choice=true
            ;;
        *)
            echo -e "Invalid choice"
            valid_choice=false
            ;;
        esac
    done
}

choose_agent() {
    echo -e "\n"
    local valid_choice=false
    while [ ${valid_choice} = false ]; do
        read -r -ep "Should the qemu-guest-agent package be pre-installed in the image? (y/n) " selection
        case "$selection" in
        y | Y | yes | Yes)
            agent=true
            valid_choice=true
            ;;
        n | N | no | No)
            agent=false
            valid_choice=true
            ;;
        *)
            echo -e "Invalid choice"
            valid_choice=false
            ;;
        esac
    done
}

choose_libguestfs() {
    if "${agent}"; then
        if command -v virt-customize --version &>/dev/null; then
            libguestfs=true
        else
            echo -e "\n"
            echo -e "In order to pre-install qemu-guest-agent in the image, libguestfs-tools is required."
            local valid_choice=false
            while [ ${valid_choice} = false ]; do
                read -r -ep "Install libguestfs-tools? (y/n) " selection
                case "$selection" in
                y | Y | yes | Yes)
                    libguestfs=true
                    valid_choice=true
                    ;;
                n | N | no | No)
                    libguestfs=false
                    valid_choice=true
                    ;;
                *)
                    echo -e "Invalid choice"
                    valid_choice=false
                    ;;
                esac
            done
        fi
    fi
}

download_image() {
    if [ -f "$CLOUDIMG_NAME" ]; then
        echo -e "\nDistro image already downloaded."

        local valid_choice=false
        while [ ${valid_choice} = false ]; do
            read -r -ep "Download image again? (y/n) " selection
            case "$selection" in
            y | Y | yes | Yes)
                wget "${IMAGE_URL}" -O "${CLOUDIMG_NAME}"
                wget -q -O - "${CHECKSUM_URL}" | grep "${CLOUDIMG_NAME}" | sha"${SHA}"sum -c --ignore-missing
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
    else
        wget "${IMAGE_URL}" -O "${CLOUDIMG_NAME}"
        if (wget -q -O - "${CHECKSUM_URL}" | grep "${CLOUDIMG_NAME}" | sha"${SHA}"sum -c --ignore-missing); then
            true
        else
            exit 1
        fi
    fi
}

qm_create() {
    # create a new VM with VirtIO SCSI single controller
    qm create "${ID}" --name "${TEMPLATE_NAME}" --memory 2048 --core 1 \
        --net0 virtio,bridge=vmbr0,firewall=1 --scsihw virtio-scsi-single \
        --agent "${agent_params}"

    # import the downloaded disk to the storage, attaching it as a SCSI drive
    qm importdisk "${ID}" "${CLOUDIMG_NAME}" "${STORAGE}"
    qm set "${ID}" --scsihw virtio-scsi-single \
        --scsi0 file="${STORAGE}":"${ID}"/vm-"${ID}"-disk-0.raw,iothread=1,"${ssd_params}"

    # configure a CD-ROM drive, which will be used to pass the Cloud-Init data to the VM
    qm set "${ID}" --ide2 "${STORAGE}":cloudinit

    # set the boot parameter to order=scsi0 to restrict BIOS to boot from this disk only
    qm set "${ID}" --boot order=scsi0

    # configure a serial console and use it as a display
    qm set "${ID}" --serial0 socket --vga serial0

    # Set the default IP to DHCP in Cloud-Init (can be changed later through Cloud-Init)
    qm set "${ID}" --ipconfig0 ip=dhcp

    # convert the VM into a template
    qm template "${ID}"
}

cleanup() {
    echo -e "\n"

    local valid_choice=false
    while [ ${valid_choice} = false ]; do
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
        while [ ${valid_choice} = false ]; do
            read -r -ep "Remove libguestfs-tools? (y/n) " selection
            case "$selection" in
            y | Y | yes | Yes)
                apt-get autopurge -y libguestfs-tools
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

    echo -e "\n"
    local valid_choice=false
    while [ ${valid_choice} = false ]; do
        read -r -ep "Delete downloaded cloud image file? (y/n) " selection
        case "$selection" in
        y | Y | yes | Yes)
            rm "${CLOUDIMG_NAME}"
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
    while [ ${valid_choice} = false ]; do
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
}

main() {
    choose_distro "$@"
    choose_id "$@"
    choose_storage "$@"
    choose_agent "$@"
    choose_libguestfs "$@"
    TEMPLATE_NAME="Template-Cloud-init"

    # # add date to filename
    # date=$(date --iso-8601=date)
    # CLOUDIMG_NAME="${CLOUDIMG_NAME}_${date}"

    # download the image
    download_image "$@"

    # configure SSD parameters
    if "${SSD}"; then
        ssd_params="discard=on,ssd=1"
    else
        ssd_params="ssd=0"
    fi

    # install qemu-guest-agent (requires libguestfs-tools)
    # and configure agent parameters
    if "${agent}"; then
        if "${libguestfs}"; then
            apt-get install -y libguestfs-tools
            virt-customize -a "${CLOUDIMG_NAME}" --install qemu-guest-agent

            agent_params="enabled=1,fstrim_cloned_disks=1"
        else
            agent_params="enabled=0"
        fi
    else
        agent_params="enabled=0"
    fi

    qm_create "$@"

    echo -e "\n"
    if ( (qm status "${ID}" 2>/dev/null)); then
        echo -e "Install complete!
    $(basename "${CLOUDIMG_NAME}" ".qcow2") installed as PVE Template #${ID}"
    else
        echo -e "Install failed. Please try again."
    fi

    cleanup "$@"
}

main "$@"

exit 0
