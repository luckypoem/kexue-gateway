# 科学网关

[![Build Status](https://travis-ci.com/wi1dcard/kexue-gateway.svg?token=FFy2KXZmvw6M3U6ihiAo&branch=master)](https://travis-ci.com/wi1dcard/kexue-gateway)
[![WTFPL](http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-2.png)](http://www.wtfpl.net/)

基于 V2ray 强大的配置以及 Ansible 灵活的任务编排，本项目通过相对简单的步骤，尽可能地带来接近原生的互联网体验。

- [科学网关](#%e7%a7%91%e5%ad%a6%e7%bd%91%e5%85%b3)
  - [变更记录](#%e5%8f%98%e6%9b%b4%e8%ae%b0%e5%bd%95)
  - [目录结构](#%e7%9b%ae%e5%bd%95%e7%bb%93%e6%9e%84)
  - [如何安装](#%e5%a6%82%e4%bd%95%e5%ae%89%e8%a3%85)
    - [电脑](#%e7%94%b5%e8%84%91)
    - [Ubuntu Server](#ubuntu-server)
    - [开始使用](#%e5%bc%80%e5%a7%8b%e4%bd%bf%e7%94%a8)
  - [进阶配置](#%e8%bf%9b%e9%98%b6%e9%85%8d%e7%bd%ae)
  - [已知事项](#%e5%b7%b2%e7%9f%a5%e4%ba%8b%e9%a1%b9)
  - [感谢](#%e6%84%9f%e8%b0%a2)
  - [声明](#%e5%a3%b0%e6%98%8e)

## 变更记录

TODO

## 目录结构

```
.
├── defaults         --- 默认配置目录
│   └── ...
├── files            --- 普通文件目录
│   └── ...
├── tasks            --- Ansible Tasks
│   └── ...
├── templates        --- 模板文件目录
│   └── ...
├── vars             --- 自定义配置目录
│   └── ...
├── README.md        --- 本文件
├── apply.sh         --- 辅助部署脚本
└── playbook.yml     --- Ansible Playbook
```

## 如何安装

### 电脑

1. 安装 Git LFS（用于拉取 `dist/` 目录）。
2. [安装 Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)（版本 >= 2.8）和 `python-netaddr`，例如通过 Python 的 pip 包管理器安装：
    ```bash
    pip install ansible netaddr
    ```

### Ubuntu Server

0. 安装 `unzip`。

```bash
$ sudo apt install unzip
```

1. 使用 [Netplan](https://netplan.io/) 配置静态 IP 地址，以及上游网关；例如：

```yaml
# /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  ethernets:
    ens160:
      dhcp4: no
      addresses: [192.168.88.3/24]
      gateway4: 192.168.88.1
      nameservers:
        addresses: [114.114.114.114]
```

```bash
$ netplan try
```

2. 修改本项目配置（`vars/main.yml`），调整以下内容：

```yaml
ensure_static_ip: false
systemd_resolved: direct
v2ray_archive: dist/v2ray-linux-64.zip
frpc_os_arch: linux_amd64
```

3. 修改 `inventory` 文件内容：

```
<IP_OR_HOST> ansible_user=<USER_NAME> ansible_become=true ansible_become_pass=<SUDO_PASSWORD>
```

注意：`<USER_NAME>` 通常不为 `root`，请按需调整。

### 开始使用

以下路径均相对于本项目根目录，请在本地执行命令。

1. 完整克隆或下载本项目。
2. 将 `defaults/basic.yml` 复制到 `vars/main.yml`，根据服务器信息替换其中的配置。
3. 执行以下命令，并根据提示输入指定信息：
   ```bash
   ./apply.sh vars/main.yml
   ```
   运行完成后，可根据提示的命令测试代理是否正常运行。
4. 登录路由器管理页面，修改 LAN 口的 DHCP 服务配置 —— 将客户端网关和 DNS 服务器均设置为 NanoPi 的 IP 地址即可。

## 进阶配置

- 建议先阅读 GitHub [Wiki](https://github.com/wi1dcard/kexue-gateway/wiki)。
- 可参考 `defaults/` 目录内其它配置文件的注释，调整更多配置项。
- 也可以通过修改 `templates/config.json.j2` 来自定义由 Jinja2 渲染的 V2ray 配置文件。

## 已知事项

- 不支持 IPv6；原因：普及率低。
- 不支持 UDP Relay；原因：配置不当易引发副作用，例如延迟升高等。

## 感谢

- V2ray
- CoreDNS
- ... TODO

## 声明

本项目仅用于海外华人学习研究使用，严禁用于非法用途；一切后果由用户自行承担。
