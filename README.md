# 科学网关

所谓 `kexue-gateway`，就是指能够科学上网的网关啦。

## 物资

- 联网的路由器 * 1
- NanoPi NEO2 * 1
- 电脑 * 1

## 准备工作

### Nano Pi

以下步骤均可参考 Armbian 官方 [入门文档](https://docs.armbian.com/User-Guide_Getting-Started/)

1. 给 NanoPi 刷入 Armbian Bionic 系统（理论上本项目兼容 Armbian Stretch，但暂时未测试）。
2. 将 NanoPi 开机，连接到路由器的 LAN 口上。
3. 登录到 NanoPi，根据提示进行一些基本配置，随后执行 `apt update` 更新软件源。
4. 给 NanoPi 配置静态 IP，例如：
    ```bash
    sudo nmcli connection modify 'Wired connection 1' connection.autoconnect yes ipv4.method manual ipv4.address 192.168.1.254/24 ipv4.gateway 192.168.1.1 ipv4.dns 114.114.114.114
    ```
    以上命令将 NanoPi 的 IP 设置为 *192.168.1.254*，子网掩码为 *255.255.255.0*，网关（路由器）IP 为 *192.168.1.1*，DNS 为 *114.114.114.114*。
5. 重启 NanoPi，确保静态 IP 已生效且能够正常联网即可。

### 电脑

在电脑上安装 Ansible，例如通过 Python 的 pip 包管理器安装：

```bash
pip install ansible
```

详情可参见 [本文](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)。

## 使用方法

1. 在电脑上克隆本项目。
2. 根据注释修改 `playbook.yml` 内的转发设置。
3. 创建 `inventory` 文件，内容为 NanoPi 的 IP 地址。
4. 执行命令：
   ```bash
   ansible-playbook --ask-pass -i inventory playbook.yml
   ```
5. 登录路由器管理页面，修改 DHCP 服务配置；将客户端网关和 DNS 服务器均设置为 NanoPi 的 IP 地址即可。

## 已知事项

- 不支持 IPv6。
- 不支持 UDP Relay。
- V2ray 内置 DNS 将会强制将 TTL 设置为 600s。

## 感谢

- V2ray

## 声明

本项目仅用于海外华人学习研究使用，严禁用于非法用途；一切后果由用户自行承担。
