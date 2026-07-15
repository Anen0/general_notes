## `Installing WSL2 on Windows`

    https://learn.microsoft.com/en-us/windows/wsl/install

for older systems

    https://learn.microsoft.com/en-us/windows/wsl/install-manual

## `Move WSL2 location`

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

        wslhttps://learn.microsoft.com/en-us/windows/wsl/install-manual

6. import the distro from the new location:

        wsl --import <Distro-name> <install location> <backup location>\<Distro-name>.tar

    > _Ex:_ wsl --import Ubuntu-24.04 D:\wsl\ubuntu D:\wsl-backup.tar

7. once done check the installed distro:

        wsl -d <Distro-name> 


## `Linux User accounts`

`Change the Default User (Recommended)`

1. open WSL terminal
2. Open or Create the config file with root privileges:

        sudo nano /etc/wsl.conf
    
    add these:

        [user]
        default=your_username

3. close terminal and open PowerShell/CMD and restart to apply changes:

        wsl --shutdown 

`Change into a specific User`

If you only need to run a session as a different user without modifying your default settings, pass the user flag from PowerShell/CMD

1. launch default distro:

        wsl -u <username>

2. launch a specific distro:

        wsl -d <Distro-name> -u <username>
