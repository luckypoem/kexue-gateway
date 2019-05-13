# 科学网关

[![Build Status](https://travis-ci.com/wi1dcard/kexue-gateway.svg?token=FFy2KXZmvw6M3U6ihiAo&branch=master)](https://travis-ci.com/wi1dcard/kexue-gateway)
[![WTFPL](http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-2.png)](http://www.wtfpl.net/)

基于 V2ray 强大的配置，NanoPi 小巧的体积，以及 Ansible 灵活的任务编排，本项目通过相对简单的步骤，尽可能地带来接近原生的互联网体验。根据测试，在默认配置下，至少能够达到 200Mbps 左右的稳定速率。

- [科学网关](#%E7%A7%91%E5%AD%A6%E7%BD%91%E5%85%B3)
  - [目录结构](#%E7%9B%AE%E5%BD%95%E7%BB%93%E6%9E%84)
  - [准备工作](#%E5%87%86%E5%A4%87%E5%B7%A5%E4%BD%9C)
    - [硬件](#%E7%A1%AC%E4%BB%B6)
    - [NanoPi](#nanopi)
    - [电脑](#%E7%94%B5%E8%84%91)
  - [开始使用](#%E5%BC%80%E5%A7%8B%E4%BD%BF%E7%94%A8)
  - [进阶配置](#%E8%BF%9B%E9%98%B6%E9%85%8D%E7%BD%AE)
  - [更多应用](#%E6%9B%B4%E5%A4%9A%E5%BA%94%E7%94%A8)
  - [已知事项](#%E5%B7%B2%E7%9F%A5%E4%BA%8B%E9%A1%B9)
  - [感谢](#%E6%84%9F%E8%B0%A2)
  - [声明](#%E5%A3%B0%E6%98%8E)

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

1. 下载 [Armbian Bionic](https://www.armbian.com/nanopi-neo-2/) 系统镜像；理论上本项目兼容 Armbian Stretch，但暂时未测试。
2. 将镜像刷入 TF 卡；推荐使用 [balenaEtcher](https://www.balena.io/etcher/) 工具，简单易用。
3. 将 TF 卡插入 NanoPi 并连接到路由器的 LAN 口，随后上电开机。
4. 通过路由器管理页面查看 NanoPi 的 IP 地址（亦可尝试 `nanopineo2`）；使用 SSH 登录到 NanoPi，用户名为 `root`，密码为 `1234`。
5. 初次登录需强制修改密码并进行一些基本配置，根据提示完成即可。

### 电脑

1. 安装 Git LFS（用于拉取 `dist/` 目录）。
2. [安装 Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)，例如通过 Python 的 pip 包管理器安装：
    ```bash
    pip install ansible
    ```

## 开始使用

以下路径均相对于本项目根目录，请在本地执行命令。

1. 完整克隆或下载本项目。
2. 将 `defaults/basic.yml` 复制到 `vars/main.yml`，根据服务器信息替换其中的配置。
3. 运行以下命令，并根据提示输入指定信息：
   ```bash
   ./apply.sh vars/main.yml
   ```
4. （可选）使用以下命令确认代理已经正常运行：
    ```bash
    curl -x socks5://<NANO_PI_IP>:1082 ipinfo.io
    ```
5. 登录路由器管理页面，修改 LAN 口的 DHCP 服务配置 —— 将客户端网关和 DNS 服务器均设置为 NanoPi 的 IP 地址即可。

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

- 不支持 IPv6。
- 不支持 UDP Relay。
- V2ray 内置 DNS 将会强制将 TTL 设置为 600s。

## 感谢

- V2ray

## 声明

本项目仅用于海外华人学习研究使用，严禁用于非法用途；一切后果由用户自行承担。
