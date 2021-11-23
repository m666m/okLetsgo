# Open-SSH 发展了好久，开源设置有各种历史遗留问题，比较没规划

## 外网访问内网使用ssh和远程桌面

<https://github.com/microsoft/vscode-docs/blob/master/remote-release-notes/v1_37.md>

## Ssh配置文件格式说明

<http://man7.org/linux/man-pages/man5/ssh_config.5.html>

### 【服务器端】

windows7本机下服务端安装，详见 GIT+SSH\OpenSSH-Win64.txt

参考 <https://winscp.net/eng/docs/guide_windows_openssh_server#windows_older>

下面是windonws7 下本机虚拟机作为ssh服务端的配置：

1. 配置ddns和路由器端口转发用于在互联网访问内网

2. 登陆 tplogin.cn ，应用管理->1.ddns 2.虚拟服务器

            外部端口    内部端口    IP地址      协议类型
   ssh      xxx12    22222    192.168.1.ooo    ALL
   远程桌面   xxx34    3389    192.168.1.ooo    ALL

3. Linux 安装ssh

    sudo apt-get install openssh-server
    sudo apt-get install openssh-client

4. Virtual Box 中选运行Linux ssh服务的那个虚拟机，设置 ：网络->网卡(NAT)->端口转发,

    主机IP        主机端口    子系统端口
    192.168.1.ooo   22222       22
    127.0.0.1       22222       22

5. 用 SecureCRT 或 Putty 可验证是否能用这个端口登陆

6. 配置linux 的 /etc/ssh/sshd_config 文件，注意，系统默认配置就可以了。

### 【客户端】非win10的windows系统安装使用ssh

1.装个windows下的git就完事了

2.不行的话手动装，详见 GIT+SSH\OpenSSH-Win64.txt

微软后来改进了ssh.exe的查找，不止搜索PATH变量而且找git的安装目录，或者直接设置变量 remote.SSH.path

    Improve finding SSH:

    Previously, the SSH extension only looked for ssh on the PATH.
    Now we will also discover the ssh.exe installed with Git on Windows.
    There is also a new setting remote.SSH.path if SSH is in some other location.

    <https://code.visualstudio.com/docs/remote/troubleshooting#_configuring-key-based-authentication>

3.VS Code点左下角图标 选 Remote-SSH:Open Configuration File...

下列两个文件在第7步进行了修改

    [C:\Users\xxx\.ssh\config] 打开的是当前用户的默认ssh配置文件
    Host linuxPC
        HostName 192.168.1.ooo
        Port 22222
        User yourname

    [C:\ProgramData\ssh\ssh_config] 打开的是系统级的默认ssh配置文件
    AddKeysToAgent yes

-------- 4，5步有点问题是微软的验证流程不完整，第6步有更正 --------

    4.VS Code点左下角图标 选 Remote-SSH:Connect to host...
    注意根据提示输入yes啥的，还有用户名对应的密码！

    5.自动又打开了一个VS Code，右下角提示：
        Seting up SSH Host linuxPC:(details)VS Code server，
    务必点击 details，然后又是输入用户名密码！

    选择菜单：查看->输出->列表选 Remote-SSH

    "install" terminal command done
    Received install output: 38cfd39e-0961-xxxx-ba67-6f1320b23dc3==42177==
    Server is listening on port 42177
    Spawning tunnel with: ssh linuxPC -N -L localhost:6066:localhost:42177
    Spawned SSH tunnel between local port 6066 and remote port 42177
    Waiting for ssh tunnel to be ready
    Tunnel(42177) stderr: yourname@192.168.1.ooo: Permission denied (publickey,password).

-------- 4，5步有点问题是微软的验证流程不完整，第6步有更正 --------

6.因为4、5两步过不去，怀疑是开发者没测试过不保留密钥文件的情况，只能生成公私钥放本地了。

参考 <https://code.visualstudio.com/docs/remote/troubleshooting#_installing-a-supported-ssh-client>

在 linuxPc 的服务器端运行命令,生成一对公私密钥在/home/yourname/.ssh/下叫做 id_rsa id_rsa.pub

    ssh-keygen -t rsa -b 4096 -C "192.168.1.ooo"
    cd ~/.ssh
    cat id_rsa.pub >> ~/.ssh/authorized_keys
    下载 id_rsa 放到本机C:\Users\xxx\.ssh\下面  %USERPROFILE%

7.这样第3步的文件改成下面这样，
参考 <https://segmentfault.com/a/1190000013798839>

    [C:\Users\xxx\.ssh\config] 打开的是当前用户的默认ssh配置文件

    Host linuxPC
        HostName 192.168.1.ooo
        Port 22222
        User yourname
        IdentityFile ~/.ssh/id_rsa

    [C:\ProgramData\ssh\ssh_config] 打开的是系统级的默认ssh配置文件

    AddKeysToAgent yes # 是否需要把密钥自动添加进ssh-agent中，就好像使用了ssh-add
    IdentityFile ~/.ssh/company_rsa
    IdentityFile ~/.ssh/github_rsa
    IdentityFile ~/.ssh/id_rsa  # the default path value

8.启动VS Code选择“Remote-SSH:Connect to host"选择 ”linuxPc"，
直接打开新的一个 VS Code，可以用了！

然后你发现，各种插件都要重新安装...linuxPC上的python环境也都需要重新搞一遍...
ubuntu默认没有pip和pip3...先装这俩再说别的吧！

9.最后，通过输入以下命令修改服务器上authorized_keys文件的ACL（这步未验证，因为上面的已经可以用了！）

    ssh -%username@domain.com powershell -c $ ConfirmPreference ='无'; Repair-AuthorizedKeyPermission C:\Users\xxx\.ssh\authorized_keys

### 【配置服务器端】

在上一步安装的 OpenSSH-Win64，设置服务器模式启动，并加入公钥文件
设置相应的端口号

### 【配置客户端】

配置连接文件

### 【最后检查】

看vs code打开远程ssh文件夹后，插件是否不可用？
删除服务器上的 ~/.vscode目录，重新安装插件：RemoteDevelopment
<https://github.com/microsoft/vscode-remote-release/issues/1443>

## ssh进行代理转发

1.用软件Proxifier进行设置就完事了。
2.PuTTY：Connection->SSH->Tunnels目标设置为Dynamic，添加一个端口7070，点击Add，一个动态转发端口就实现了。
然后用相应帐号SHH登录后：除了登录的终端窗口以外，本地的7070连服务器的22端口之间就有了一个SSH加密的转发通道了。
透明用法 plink.exe -v -C -N -D 127.0.0.1:7000 -l root -P xx 98.143.xxx.xxx 如果安全性不重要可以加上一个 -pw 参数以自动输入密码。
         plink –N username@remote.ssh.server -D 127.0.0.1:7070其中 -N 表示不需要shell

## PuTTY使用密钥方式登录Linux服务器

如果用SecureCRT，登陆一次选保存用户名密码就可以了。。。
在服务器上用./ssh-keygen生成密钥对，将公钥 id_rsa.pub >> 部署到要登录到的服务器上：/home/username/.ssh/authorized_keys 中，

密钥在Windows客户端下使用：将密钥 id_rsa下载到本地，然后用puttygen导入id_rsa 另存转换为putty格式的密钥id_rsa.ppk

         plink -i c:\pathto\id_rsa.ppk username@example.com
