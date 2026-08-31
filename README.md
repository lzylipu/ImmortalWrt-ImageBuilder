<div align="center">

# 📡 ImmortalWrt-ImageBuilder (ipsec-kmods Branch)

**定制版 ImmortalWrt 25.12.x x86-64 固件一键编译 · Docker VPN · 去广告 · Meta 内核预置**

[![Build](https://img.shields.io/github/actions/workflow/status/lzylipu/ImmortalWrt-ImageBuilder/build-x86-64.yml?style=flat-square&label=build)](../../actions)
[![Fork of](https://img.shields.io/badge/Fork%20of-wukongdaily%2FImmortalWrt--ImageBuilder-ffde59)](https://github.com/wukongdaily/ImmortalWrt-ImageBuilder)
[![License](https://img.shields.io/github/license/lzylipu/ImmortalWrt-ImageBuilder?style=flat-square)](./LICENSE)

**🌐 English | [简体中文](#-简体中文)**

</div>

> 📡 定制版 ImmortalWrt 25.12.x x86-64 固件一键编译：原生 Docker VPN（IKEv2/L2TP）内核支持、去广告与 Meta 代理内核预置，Actions 手动触发即出固件。

---

## 🌐 English

This repository is a customized fork of **[@wukongdaily](https://github.com/wukongdaily)**'s excellent [ImmortalWrt-ImageBuilder](https://github.com/wukongdaily/ImmortalWrt-ImageBuilder) workflow. It is designed to compile **ImmortalWrt 25.12.x (x86-64)** firmware with customized Docker network integrations, particularly featuring native L2TP/IKEv2 VPN support.

### ✨ Key Customized Features
* **🛡️ Native IPsec/XFRM kmods Integration**: Resolves the infamous "kernel unsupported" error for Docker-based Libreswan/strongSwan by injecting matching xfrm/tunneling kmod APKs dynamically via `lzylipu/immortalwrt-ipsec-kmods` release script.
* **🔌 Direct rootfs Injection for Custom Plugins**: Automatically clones and bakes custom LuCI UIs (like `luci-app-ipsec-hwdsl2`) straight into the rootfs `files/` folder without needing manual APK packaging.
* **🎛️ Unified Control Panel**: Enables/disables all third-party plugins in a single place: `shell/package-selection.conf`.
* **📦 Pre-downloaded Meta Cores**: The workflow automatically downloads and packs the latest Meta cores (mihomo / clash_meta) and rulesets, avoiding network errors on first boot.

### 📝 Credits / Upstream Attribution
This project is an open-source extension of the upstream [wukongdaily/ImmortalWrt-ImageBuilder](https://github.com/wukongdaily/ImmortalWrt-ImageBuilder). Special thanks to the original author for the automated compilation framework.

---

## 🇨🇳 简体中文

本项目是基于 **[@wukongdaily](https://github.com/wukongdaily)** 优秀的 [ImmortalWrt-ImageBuilder](https://github.com/wukongdaily/ImmortalWrt-ImageBuilder) 项目定制的复刻分支。旨在快速编译生成适用于 x86-64 架构的 **ImmortalWrt 25.12.x** 固件，并完美融入 Docker 版 VPN、去广告及核心代理插件。

### ✨ 定制特性
* **🛡️ 原生 IPsec/XFRM 内核支持**: 解决 libreswan 在容器内运行时报 “内核不支持” 的痛点。通过集成同内核版本的 `lzylipu/immortalwrt-ipsec-kmods` 编译包，自动解决底层 VPN 网口需求。
* **🔌 纯前端面板免编译注入**: 支持在构建时直接拉取自定义的 LuCI UI 界面源码（例如 `luci-app-ipsec-hwdsl2`），并将其固化到 rootfs（`files/`）目录，无需再手动生成 APK 包。
* **🎛️ 一站式包管理**: 所有集成的第三方插件，统一通过编辑 `shell/package-selection.conf` 取消或加上注释来决定去留，无需更改底层的 GitHub Action YAML。
* **📦 核心自动预下载**: 预装并预下载 Meta 内核、Mihomo 内核及规则数据（GeoIP/GeoSite），避免固件首次启动时因为网络环境导致配置拉取失败。

### 📝 致谢与开源引用说明
本项目属于上游开源项目 [wukongdaily/ImmortalWrt-ImageBuilder](https://github.com/wukongdaily/ImmortalWrt-ImageBuilder) 的定制分流。对原作者的镜像构建框架表示由衷致谢。

### 🚀 日常固件构建指南
1. 前往 GitHub 本仓库的 **Actions** 菜单，选择 **Build 25.12.x x86-64**。
2. 点击右侧 **Run workflow** 下拉框。
3. 配置各项参数：
   - `custom_router_ip`: 输入你所需的管理地址（例如 `192.168.100.1`）。
   - `profile`: 设置分区空间大小。要装 Docker 镜像，强烈推荐设置在 **5120** (5GB) 以上。
   - `include_docker`: 选择 `yes` 开启 Docker 功能支持。
   - `enable_ipsec_kmods`: 选择 `yes` 自动装载 IPsec 底层内核。
4. 点击 **Run workflow**，编译完成后将在 Releases 自动生成下载链接。

---

## 📄 许可证 / License

[MIT](./LICENSE) License
