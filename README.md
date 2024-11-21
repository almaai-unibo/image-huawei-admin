- Build: `docker build . -t gciattounibo/huawei-admin`
- Create local file named `password` with the password for `USER` on Huawei machines
- Assumption is that the local user has a private key in `$HOME/.ssh/id_rsa`
- Run: `docker run --rm -it -e USER=gciatto -v $(pwd)/.password:/secrets/password:ro -v $HOME/.ssh/id_rsa:/root/.ssh/id_rsa:ro gciattounibo/huawei-admin`

# How to
### Launch an ansible command 
You can launch an arbitrary Ansible command using the shell function `ansible_shell`, which takes two parameters:
1. the Ansible target (by default is 'all'. You can check the available targets in `huawei.ini` file
2. the shell command to be executed

```bash
ansible_shell stairwai 'docker volume ls'
```


### Create a user volume
You can create a user volume using the shell function `create_user_volume`, which takes two parameters:
1. the name of the user that is using the volume
2. the Ansible target, default value is 'stairwai'.

```bash
create_user_volume 'martina.baiardi'
```
or 
```bash
create_user_volume 'martina.baiardi' stairwai
```
