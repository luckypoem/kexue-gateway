# 科学网关

[![Build Status](https://travis-ci.com/wi1dcard/kexue-gateway.svg?token=FFy2KXZmvw6M3U6ihiAo&branch=master)](https://travis-ci.com/wi1dcard/kexue-gateway)
[![WTFPL](http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-2.png)](http://www.wtfpl.net/)

基于 V2ray 强大的配置以及 Ansible 灵活的任务编排，本项目通过相对简单的步骤，尽可能地带来接近原生的互联网体验。

- [科学网关](#%e7%a7%91%e5%ad%a6%e7%bd%91%e5%85%b3)
  - [不兼容变更](#%e4%b8%8d%e5%85%bc%e5%ae%b9%e5%8f%98%e6%9b%b4)
    - [[v3]](#v3)
    - [[v2]](#v2)
    - [[v1]](#v1)
  - [使用指南](#%e4%bd%bf%e7%94%a8%e6%8c%87%e5%8d%97)
    - [系统需求](#%e7%b3%bb%e7%bb%9f%e9%9c%80%e6%b1%82)
    - [准备工作](#%e5%87%86%e5%a4%87%e5%b7%a5%e4%bd%9c)
    - [编写配置文件](#%e7%bc%96%e5%86%99%e9%85%8d%e7%bd%ae%e6%96%87%e4%bb%b6)
    - [开始部署](#%e5%bc%80%e5%a7%8b%e9%83%a8%e7%bd%b2)
  - [继续深入](#%e7%bb%a7%e7%bb%ad%e6%b7%b1%e5%85%a5)
  - [已知事项](#%e5%b7%b2%e7%9f%a5%e4%ba%8b%e9%a1%b9)
  - [感谢](#%e6%84%9f%e8%b0%a2)
  - [声明](#%e5%a3%b0%e6%98%8e)

## 不兼容变更

**⚠️由于新版本仅支持 Ubuntu Server Bionic AMD64，请原有 NanoPi 用户使用 [release/v2][v2] 分支。**

### [v3]

- 废弃 frpc。
- 废弃变量 `healthcheck_commands`。
- 废弃 NanoPi 等 ARM 设备支持。
- 废弃 LFS 存储发行包（需用户自行下载）。
- 目录结构重构，废弃辅助脚本 `apply.sh` 和内置 `playbook.yml`。
- 变量 `local_traffic` 的默认值修改为 `false`。

### [v2]

- 变量 `reversed_ips` 被重命名为 `special_addresses`。
- 废弃原有直连和全局 SOCKS 代理。
- 废弃基于规则的路由（`rules.yml`）。

### [v1]

- 初始版本。

[v1]: https://github.com/wi1dcard/kexue-gateway/tree/release/v1
[v2]: https://github.com/wi1dcard/kexue-gateway/tree/release/v2
[v3]: https://github.com/wi1dcard/kexue-gateway/tree/release/v3

## 使用指南

### 系统需求

- 一台装有 Ubuntu Server Bionic 的 AMD64 架构主机，可在淘宝搜索「软路由」相关商品。
- 一台装有 Ansible（版本 >= 2.8）和 `python-netaddr` 的电脑。安装过程请参考 [官方文档](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)，例如通过 Python 的 pip 包管理器安装：
    ```bash
    pip install ansible netaddr
    ```

### 准备工作

1. 克隆本项目后，在本地电脑执行 `initialize.sh` 用于下载发行包等：
    ```
    ./initialize.sh
    ```

2. 在 Ubuntu Server 中使用 [Netplan](https://netplan.io/) 配置静态 IP 地址，以及上游网关等；例如（请根据实际情况填写）：

```yaml
# /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  ethernets:
    # 网卡名为 ens160
    ens160:
      # 禁止通过 DHCP 获取 IP 地址信息
      dhcp4: no
      # IP 为 192.168.88.254；子网掩码为 255.255.255.0
      addresses: [192.168.88.254/24]
      # 网关（路由器）IP 为 192.168.88.1
      gateway4: 192.168.88.1
      # DNS 服务器为 114.114.114.114
      nameservers:
        addresses: [114.114.114.114]
```

随后执行以下命令应用配置：

```bash
$ netplan try
```

### 编写配置文件

1. 请将 [roles/v2ray/defaults/main/basic.yml](roles/v2ray/defaults/main/basic.yml) 的内容复制到 `vars/basic.yml`，并按照实际情况填写服务器信息。

2. 创建 `inventories/main.ini`，用于保存网关 SSH 信息，例如：

```ini
192.168.88.254 ansible_become=true ansible_user=<SSH_USER> ansible_become_pass=<SUDO_PASSWORD>
```

3. 创建 `playbook.yml`，例如：

```yaml
- hosts: all
  vars_files:
    - vars/basic.yml
  roles:
    - v2ray
```

### 开始部署

执行以下命令即可。

```bash
ansible-playbook -i inventories/main.ini playbook.yml
```

## 继续深入

- 学习 [Ansible](https://docs.ansible.com)。
- 阅读 GitHub [Wiki](https://github.com/wi1dcard/kexue-gateway/wiki)。
- 参考 [roles/v2ray/defaults/main/](roles/v2ray/defaults/main/) 目录内其它配置文件的注释，调整更多配置项。
- 通过修改 [roles/v2ray/templates/config.json.j2](roles/v2ray/templates/config.json.j2) 来自定义由 Jinja2 渲染的 V2ray 配置文件。

## 已知事项

- 不支持 IPv6；原因：普及率低。

## 感谢

- V2ray

## 声明

本项目仅用于海外华人学习研究使用，严禁用于非法用途；一切后果由用户自行承担。
