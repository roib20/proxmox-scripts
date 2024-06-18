# Proxmox VE script for generating Cloud-init templates

A user-friendly guided script for Proxmox VE 8.x. Guides you through downloading a Linux cloud image and automatically configuring it as a Cloud-init template - that can then be used to easily generate VMs!

Various distros are avaible to download and configure. Current choices include:
- [Ubuntu Cloud 22.04 LS (Jammy Jellyfish)](https://cloud-images.ubuntu.com/releases/22.04/)
- [Ubuntu Minimal Cloud 22.04 LTS (Jammy Jellyfish)](https://cloud-images.ubuntu.com/minimal/releases/jammy/)
- [Ubuntu Cloud 24.04 LTS (Noble Numbat)](https://cloud-images.ubuntu.com/noble/)
- [Ubuntu Minimal Cloud 24.04 LTS (Noble Numbat)](https://cloud-images.ubuntu.com/releases/24.04/)
- [Debian 11 "bullseye" (GenericCloud)](https://cloud.debian.org/images/cloud/bullseye/)
- [Debian 12 "bookworm" (GenericCloud)](https://cloud.debian.org/images/cloud/bookworm/)
- [Fedora Cloud 40 (base)](https://download.fedoraproject.org/pub/fedora/linux/releases/40/Cloud/)
- [AlmaLinux 9 (GenericCloud)](https://repo.almalinux.org/almalinux/9/cloud/)

## FAQ
### What is Cloud-init?
[Cloud-init](https://cloudinit.readthedocs.io/) makes it easy to deploy virtual machines; Instead of going through a lengthy installation ISO, you simply set up the wanted values before installation, then the VM boots up and automatically configures itself.

### How can Cloud-init be used together with Proxmox VE?

[Proxmox VE includes Cloud-init support](https://pve.proxmox.com/wiki/Cloud-Init_Support). You can download any supported cloud image and configure it to use Cloud-init. This script simply automates this process. For more information, refer to the resources below.

### How to run this script?
SSH into your PVE server.
Run the following command: `sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/roib20/proxmox-scripts/main/proxmox-cloudinit-script/pve_cloudinit.sh)"`

### What to do after running the script?
When the script finishes, you should get a message stating the name and ID of your newly created PVE template. Go to the Proxmox VE Web UI (default port 8006) to view your template. You can then clone the template to create a new VM.

### How to configure a Cloud-init VM?
After cloning a template into a new VM, view your new VM in the Proxmox VE web UI, choose the "Cloud-init" tab and configure any options you want (e.g. username, password, SSH public key and network settings). Make sure to also modify any VM options that you want to change under the "Hardware" tab (e.g. Memory and Hard Disk size). Then boot up your system and it will automatically configure itself with Cloud-init and your chosen options! If you configured an SSH public key, you will be able to SSH into your new VM.

### How to further automate this?
After creating templates using this script (or other methods), you can then use Infrastructure as Code (IaC) tools to create VMs based on the created templates. For example, you can use Terraform together with the [Telmate/proxmox provider](https://registry.terraform.io/providers/Telmate/proxmox/latest), or Ansible together with the [community.general.proxmox module](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_module.html) or [community.general.proxmox_kvm module](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_kvm_module.html).


## Resources
It is important to understand what any shell script does before blindly running it. The following resources help explain the usage of Cloud-init together with Proxmox:
- Proxmox VE:
	+ Cloud-Init Support: [Wiki](https://pve.proxmox.com/wiki/Cloud-Init_Support)
	+ Cloud-Init FAQ: [Wiki](https://pve.proxmox.com/wiki/Cloud-Init_FAQ)
- Techno Tim:
	+ Perfect Proxmox Template with Cloud Image and Cloud Init: [Video](https://youtu.be/shiIi38cJe4) | [Docs](https://docs.technotim.live/posts/cloud-init-cloud-image/)
- Learn Linux TV:
	 + Proxmox VE - How to build an Ubuntu 22.04 Template (Updated Method): [Video](https://youtu.be/MJgIm03Jxdo) | [Blog post](https://www.learnlinux.tv/proxmox-ve-how-to-build-an-ubuntu-22-04-template-updated-method/)
- Austin's Nerdy Things:
	+ How to create a Proxmox Ubuntu cloud-init image: [Blog post](https://austinsnerdythings.com/2021/08/30/how-to-create-a-proxmox-ubuntu-cloud-init-image/)
- Joshua Powers:
	+ Launching Ubuntu Cloud Images with QEMU: [Blog post](https://powersj.io/posts/ubuntu-qemu-cli/)
	
## Alternative approaches:

If you want an approach that's more "Infrastructure as Code (IaC)", you could instead use Ansible or Packer to generate these PVE Cloud-init templates:

- Tim's Blog:
	+ Proxmox Cloud-init image using Ansible: [Blog post](https://www.timatlee.com/post/proxmox-cloudinit-image-ansible/)
- Christian Lempa:
	+ Create VMs on Proxmox in Seconds! (Proxmox + Packer): [Video](https://youtu.be/1nf3WOEFq1Y) | [Packer Templates on GitHub](https://github.com/christianlempa/boilerplates/tree/main/packer/proxmox)
