# Proxmox VE script for creating TrueNAS virtual machines

A user-friendly guided script for Proxmox VE 7.x. Guides you through downloading a TrueNAS ISO and configuring it as a VM.

Multiple versions of TrueNAS are available to download:
  - TrueNAS SCALE 22.12.0
  - TrueNAS CORE 13.0-U3.1

## FAQ

### What does the script do?
This script automates the process of creating a TrueNAS virtual machine inside Proxmox VE. It downloads the ISO for the chosen version of TrueNAS, verifies it's SHA256 checksum, then configures a VM with it.

### How to run this script?
SSH into your PVE server.
Run the following command: `sudo bash -c "$(wget -qLO - https://raw.githubusercontent.com/roib20/proxmox-scripts/main/proxmox-truenas-script/Bash/pve_truenas.sh)"`

### What to do after running the script?
When the script finishes, you should get a message stating the name and ID of your newly created PVE VM or template. Go to the Proxmox VE Web UI (default port 8006) to view it, change any options you want then boot it up to go through the TrueNAS installer. If asked for a boot mode during installation, choose "Boot via UEFI". After installation is complete, make sure to detach the ISO image from the VM, or change the boot order to use scsi0 instead of ide2.

### What are the default VM options that this script configures?
Default Settings: `8GB RAM - 32GB Storage - 1vCPU - Q35 Machine - OVMF (UEFI)`

If TrueNAS SCALE is chosen then QEMU Agent is automatically enabled. [For TrueNAS CORE, QEMU Guest Agent needs to be installed manually](https://www.truenas.com/community/resources/qemu-guest-agent.167/).

### What are the recommended system requirements for the host?
Based on the TrueNAS system requirements and my observation, I recommend at minimum:
**Processor:** 2-Core Intel 64-Bit or AMD x86_64 processor  
**Memory:** 16GB Memory (ECC recommended)  
**Boot device:** 64GB SSD boot device  
**Storage:** Two or more identically-sized drives for a single storage pool (the bigger the better) 
**HBA card:** LSI 9207-8i (or similar), flashed in IT mode  

Since this is virtualized, 8GB of memory and 32GB of storage will be dedicated to the configured VM (this is the script defaults). The rest of the memory and storage will be used for the host.

### Is HBA passthrough configured for the VM?
This script does not fully configure the VM with an HBA card, this has to be done manually after the script is run. If you have an HBA card installed, follow the instructions in the Proxmox wiki to configure PCI passthrough (see resources below).

However, this script does configure the VM with optimized settings for pass through:
>When passing through, the best compatibility is reached when using q35 as machine type, OVMF (EFI for VMs) instead of SeaBIOS and PCIe instead of PCI.

## Resources
It is important to understand what any shell script does before blindly running it. The following resources show the manual installation process for TrueNAS inside Proxmox VE. Note that some of the chosen settings are different than what is included in this script. The process of passing through an LSI card (which is not done by this script) is explained by the  Proxmox wiki and demonstrated by IBRACORP.

- IBRACORP:
	+ Proxmox Series | [playlist](https://www.youtube.com/watch?v=wPd6lpM01FY&list=PLOgmFrM3hTGeDNcvYVrnqx7qI_wCxT4w0)
- Christian Lempa:
	+ How to run TrueNAS [CORE] on Proxmox? [Video](https://youtu.be/M3pKprTdNqQ)
- Proxmox:
	+ FreeBSD Guest Notes: [Wiki](https://pve.proxmox.com/wiki/FreeBSD_Guest_Notes)
	+ PCI passthrough: [Wiki](https://pve.proxmox.com/wiki/Pci_passthrough)
	+ PCI(e) Passthrough: [Wiki](https://pve.proxmox.com/wiki/PCI(e)_Passthrough)
- TrueNAS SCALE:
	+ Getting Started with SCALE: [Docs](https://www.truenas.com/docs/scale/gettingstarted/)
	+ Getting Started with SCALE/Installation Instructions: [Docs](https://www.truenas.com/docs/scale/gettingstarted/install/)
- TrueNAS CORE:
 	+ Getting Started: [Docs](https://www.truenas.com/docs/core/gettingstarted/)
	+ Getting Started/CORE Hardware Guide: [Docs](https://www.truenas.com/docs/core/gettingstarted/corehardwareguide/)
	+ Getting Started/Install: [Docs](https://www.truenas.com/docs/core/gettingstarted/install/)
- Serverbuilds.net:
	+ Recommended SAS2 HBA (internal & external): [Forum](https://forums.serverbuilds.net/t/official-recommended-sas2-hba-internal-external/4581)
	+ Updating your LSI SAS Controller with a UEFI Motherboard: [Forum](https://forums.serverbuilds.net/t/guide-updating-your-lsi-sas-controller-with-a-uefi-motherboard/131)
