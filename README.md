# IDC-Viewer-Support
Resources to support OHIF Viewer Deployment

- Start up a VM. Make sure it has "FULL" Storage Scope (it needs to set storage scope)
- Log in, copy & paste setup_vm.sh script from GitHub and execute it on the VM
- Edit the setEnvVars.sh script in your home directory to point to cloud bucket & path to config files.
- Customize setViewerVarsLatest.sh and setViewerVarsRelase.sh (the config files) to your installation
  and copy up into the cloud storage bucket and path specified in setEnvVars.sh
- Execute ~/IDC-Viewer-Support/scripts/fresh_viewer_from_git.sh with either "latest" or "release" argument
- When done, check that viewer is installed, log out, and shut down the VM.