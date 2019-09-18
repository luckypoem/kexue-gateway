# 科学网关

[![Build Status](https://travis-ci.com/wi1dcard/kexue-gateway.svg?token=FFy2KXZmvw6M3U6ihiAo&branch=master)](https://travis-ci.com/wi1dcard/kexue-gateway)
[![WTFPL](http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-2.png)](http://www.wtfpl.net/)

基于 V2ray 强大的配置以及 Ansible 灵活的任务编排，本项目通过相对简单的步骤，尽可能地带来接近原生的互联网体验。

- [科学网关](#%e7%a7%91%e5%ad%a6%e7%bd%91%e5%85%b3)
  - [变更记录](#%e5%8f%98%e6%9b%b4%e8%ae%b0%e5%bd%95)
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

## 如何安装

### 电脑

1. [安装 Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)（版本 >= 2.8）和 `python-netaddr`，例如通过 Python 的 pip 包管理器安装：
    ```bash
    pip install ansible netaddr
    ```
2. 执行 `initialize.sh`，用于下载发行包等：
    ```
    ./initialize.sh
    ```

### Ubuntu Server

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

TODO

### 开始使用

TODO

## 进阶配置

- 建议先阅读 GitHub [Wiki](https://github.com/wi1dcard/kexue-gateway/wiki)。
- 可参考 [roles/v2ray/defaults/main/](roles/v2ray/defaults/main/) 目录内其它配置文件的注释，调整更多配置项。
- 甚至可以通过修改 [roles/v2ray/templates/config.json.j2](roles/v2ray/templates/config.json.j2) 来自定义由 Jinja2 渲染的 V2ray 配置文件。

## 已知事项

- 不支持 IPv6；原因：普及率低。

## 感谢

- V2ray

## 声明

本项目仅用于海外华人学习研究使用，严禁用于非法用途；一切后果由用户自行承担。
