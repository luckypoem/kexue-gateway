# 科学网关

[![Build Status](https://travis-ci.com/wi1dcard/kexue-gateway.svg?token=FFy2KXZmvw6M3U6ihiAo&branch=master)](https://travis-ci.com/wi1dcard/kexue-gateway)
[![WTFPL](http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-2.png)](http://www.wtfpl.net/)

基于 V2ray 强大的配置，NanoPi 小巧的体积，以及 Ansible 灵活的任务编排，本项目通过相对简单的步骤，尽可能地带来接近原生的互联网体验。根据测试，在默认配置下，至少能够达到 200Mbps 左右的稳定速率。

- [科学网关](#%e7%a7%91%e5%ad%a6%e7%bd%91%e5%85%b3)
  - [目录结构](#%e7%9b%ae%e5%bd%95%e7%bb%93%e6%9e%84)
  - [准备工作](#%e5%87%86%e5%a4%87%e5%b7%a5%e4%bd%9c)
    - [硬件](#%e7%a1%ac%e4%bb%b6)
    - [NanoPi](#nanopi)
    - [电脑](#%e7%94%b5%e8%84%91)
  - [开始使用](#%e5%bc%80%e5%a7%8b%e4%bd%bf%e7%94%a8)
  - [进阶配置](#%e8%bf%9b%e9%98%b6%e9%85%8d%e7%bd%ae)
  - [更多应用](#%e6%9b%b4%e5%a4%9a%e5%ba%94%e7%94%a8)
  - [已知事项](#%e5%b7%b2%e7%9f%a5%e4%ba%8b%e9%a1%b9)
  - [感谢](#%e6%84%9f%e8%b0%a2)
  - [声明](#%e5%a3%b0%e6%98%8e)

## 目录结构

```
.
├── defaults         --- 默认配置目录
│   └── ...
├── dist             --- 使用 Git LFS 存储的二进制文件目录
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
├── apply.sh         --- 辅助脚本
└── playbook.yml     --- Ansible Playbook
```

## 准备工作

### 硬件

- 电脑 * 1
- 路由器 * 1
- [NanoPi NEO2](http://wiki.friendlyarm.com/wiki/index.php/NanoPi_NEO2/zh) * 1

### NanoPi

以下步骤可参考 Armbian 官方 [入门文档](https://docs.armbian.com/User-Guide_Getting-Started/)。

1. 下载 [Armbian Bionic](https://www.armbian.com/nanopi-neo-2/) 系统镜像。
2. 将镜像刷入 TF 卡；推荐使用 [balenaEtcher](https://www.balena.io/etcher/) 工具，简单易用。
3. 将 TF 卡插入 NanoPi 并连接到路由器的 LAN 口，连接电源后自动开机。
4. 通过路由器管理页面获取 NanoPi 的 IP 地址；使用 SSH 登录到 NanoPi，用户名为 `root`，密码为 `1234`。
5. 初次登录需强制修改密码并进行一些基本配置，根据提示完成即可。

### 电脑

1. 安装 Git LFS（用于拉取 `dist/` 目录）。
2. [安装 Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)（版本 >= 2.8）和 `python-netaddr`，例如通过 Python 的 pip 包管理器安装：
    ```bash
    pip install ansible netaddr
    ```

## 开始使用

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
- 另外，使用 `sudo armbian-config` -> *Network* -> *IP* 可手动配置静态 IP 地址。

## 更多应用

- [配置 Samba 服务](https://tutorials.ubuntu.com/tutorial/install-and-configure-samba)
- [运行 Docker](https://docs.armbian.com/User-Guide_Advanced-Features/#how-to-run-docker)
- [监控 CPU 温度](https://docs.armbian.com/Hardware_Allwinner-H5-A64/)
- [基于 AdGuard Home 屏蔽广告](https://github.com/AdguardTeam/AdGuardHome/wiki/Raspberry-Pi)
- [一键安装常用软件](https://docs.armbian.com/User-Guide_Armbian-Config/#software)，例如我认为比较实用的有：
  - Transmission（BT 客户端）
  - Syncthing（私有云）
  - PI hole（去广告 DNS）
  - Openmediavault（多协议 NAS 服务）
- ...

## 已知事项

- 不支持 IPv6；原因：普及率低。
- 不支持 UDP Relay；原因：配置不当易引发副作用，例如延迟升高等。
- 本项目目前亦可用于 Armbian Stretch、[FriendlyCore](http://wiki.friendlyarm.com/wiki/index.php/FriendlyCore_(based_on_ubuntu-core_with_Qt)/zh) 以及基于 AMD64 架构的 [Ubuntu Server 18.04](https://ubuntu.com/download/server)；但由于个人精力有限，无法保证长期兼容性。

## 感谢

- V2ray

## 声明

本项目仅用于海外华人学习研究使用，严禁用于非法用途；一切后果由用户自行承担。
