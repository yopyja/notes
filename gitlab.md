# GitLab Docker Server Windows Setup

Before you start you must have Admin / Win Enterprise or Pro / Possible BIOS Access

---

#### Enable Hyper-V 

 - [ ] Win Search `Turn Windows features on or off`
 - [ ] Enable Hyper-V
 - [ ] Restart

---

### Download & Install Required Apps

Required
 - [WinStore : Ubuntu](https://www.microsoft.com/store/productId/9PDXGNCFSCZV) 
 - [WinStore : Win Terminal](https://www.microsoft.com/store/productId/9N0DX20HK701)
 - [Docker Desktop Installer](https://docs.docker.com/desktop/install/windows-install/)
 - [WSL2 Linux Kernel Update Package for x64 Machines](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)

*Optional*
 - [VSCode](https://code.visualstudio.com/Download)

---

## WSL Setup

Run Powershell as administrator:

```sh
dism.exe /online /enable-feature /featurename:VirtaulMachinePlatform /all / norestart
# reboot after wsl installs
wsl --install
```


> Before continuing make sure you have installed `WSL Linux Kernel Update`

```sh
wsl --install -d Ubuntu
# close the window that opens
wsl --set-version Ubuntu 2
```

> Before continuing make sure you have installed `Docker Desktop`

```sh
net localgroup docker-users $env:username /add
```

Helpful commands:

```sh
# view installed distros
wsl -l -o
# view wsl versions
wsl -l -v
```

---

## Ubuntu Setup

Open Ubuntu terminal & setup user profile (username/password)

```sh
sudo apt update && sudo apt upgrade
```

---

## Install the GitLab EE Image

```sh
sudo docker pull gitlab/gitlab-ee:<latest || version-tag>
```

> The GitLab Enterprise Edition software does not actually require you to have a license to use it. If you do not supply a license after installation, it will automatically show you the GitLab Community Edition feature set instead.

> The primary reason someone might download the Community Edition is if they prefer to only download open source software. For more information on GitLab’s licensing, review the GitLab article on this subject. To download the GitLab CE Docker image, run this command:

```sh
sudo docker pull gitlab/gitlab-ce:<latest || version-tag>
```


It may take a few minutes to download the image. When the download is complete, you can view a list of all installed Docker images with the images command:

```sh
sudo docker images
```

---

# Offline Docker Service Testing GitLFS

## Pull Image / Backup Restore / Start Server ##


```sh
# Inject Backup into Container
sudo docker cp 8-8-22_gitlab_backup.tar gitlab:/var/opt/gitlab/backups/
```

```sh
# Issue GitLab Restore
sudo docker exec -it gitlab gitlab-backup restore BACKUP=8-8-22
```

```sh
# Pull GitLab Image 16.1.2
sudo docker pull gitlab/gitlab-ee:16.1.2-ee.0
```

```sh
# Docker Run Command
sudo docker run --detach \
  --hostname 192.168.x.x \
  --publish 80:80 --publish 443:443 --publish 22:22 \
  --name gitlab \
  --restart always \
  --volume $GITLAB_HOME/config:/etc/gitlab \
  --volume $GITLAB_HOME/logs:/var/log/gitlab \
  --volume $GITLAB_HOME/data:/var/opt/gitlab \
  --shm-size 256m \
  gitlab/gitlab-ee:16.1.2-ee.0
```


## GitLab Backup Creation & Export ##

```bash
# Backup Create
sudo docker exec -it gitlab gitlab-backup create
```
```sh
# Backup Export
sudo docker cp gitlab:/var/opt/gitlab/backups/1689003362_2023_07_10_15.1.3-ee_gitlab_backup.tar 07102023_gitlab_backup.tar
```

## Minor/Major Upgrade Container & Version Check

```sh
# Minor Upgrade Container 
sudo docker exec -it gitlab apt
sudo docker exec -it gitlab apt install gitlab-ee=15.11.11-ee.0
sudo docker exec -it gitlab gitlab-ctl reconfigure
sudo docker exec -it gitlab gitlab-ctl restart
```

```sh 
# Major Upgrade Container (must be latest minor version)
sudo docker exec -it gitlab apt update && apt install gitlab-ee
```

```sh
# Copy backup from WSL to Host
sudo cp date_vers_gitlab_backup.tar /mnt/c/users/pj/Desktop/date_vers_gitlab_backup.tar
```

```sh
# Check Version
sudo docker exec -it gitlab gitlab-rake gitlab:env:info
```
