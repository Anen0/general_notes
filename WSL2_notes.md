### `Move WSL2 location`

1. Open Powershell (run as admin) and list the distros installed:

        wsl -l -v

2. shutdown all instances of WSL with:

        wsl --shutdown

3. Export the distro into a `.tar` file to the new location:

        wsl --export <Distro-name> <backup location>\<Distro-name>.tar
    
    > _Ex_: wsl --export Ubuntu-24.04 D:\wsl-backup.tar

4. unregister the distro:

        wsl --unregister <Distro-name>

5. quickly check if there is still instances of any distro with:

        wsl

6. import the distro from the new location:

        wsl --import <Distro-name> <install location> <backup location>\<Distro-name>.tar

    > _Ex:_ wsl --import Ubuntu-24.04 D:\wsl\ubuntu D:\wsl-backup.tar

7. once done check the installed distro:

        wsl -d <Distro-name> 
---
