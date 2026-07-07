# ImmortalWrt-ImageBuilder (Custom Fork)

[![Standard](https://img.shields.io/badge/Standard-OpenWrt%2FImmortalWrt-blue)](https://github.com/immortalwrt)
[![Branch](https://img.shields.io/badge/Branch-custom-green)](https://github.com/lzylipu/ImmortalWrt-ImageBuilder/branches)

> **English** | [简体中文](#中文说明)

This is a customized fork of `wukongdaily/ImmortalWrt-ImageBuilder` for building ImmortalWrt 25.12.x firmware with native support for **IPsec/XFRM Kmods** and **AdGuard Home/Proxy Plugins**.

## 🚀 Daily Operations
1.  **Navigate to Actions**: Click the **Actions** tab.
2.  **Select Workflow**: Choose **Custom Build x86-64**.
3.  **Configure Inputs**:
    *   `firmware_version`: `25.12.0` (or latest)
    *   `include_docker`: `yes` (Recommended for IPsec/IKEv2 containers)
    *   `enable_ipsec_kmods`: `yes` (Enables kernel modules for Docker IPsec)
4.  **Run**: Click **Run workflow**. The build process automatically integrates selected plugins.

## 📦 Plugin Customization
Plugins are managed via `shell/package-selection.conf`.
*   **Enable**: Remove the `#` from the line (e.g., `apk luci-app-adguardhome`).
*   **Disable**: Add `#` to the line.
*   **Logic**: The build script (`build25.sh`) downloads package definitions from `wukongdaily/apk` and automatically fetches required cores (Clash-Meta, Mihomo) if OpenClash/SSR+ are selected.

### Supported Key Plugins
*   **AdGuard Home**: `luci-app-adguardhome`
*   **OpenClash**: `luci-app-openclash` (Auto-downloads core)
*   **Passwall2**: `luci-app-passwall2`
*   **SSR Plus**: `luci-app-ssr-plus` (Auto-downloads core)
*   **HomeProxy / Daed / Nikki**: Available via selection.

## 🔧 Technical Architecture
*   **Master Branch**: Pure upstream mirror.
*   **Custom Branch**: Contains all custom logic (scripts, configs). Merges upstream daily.
*   **IPsec Support**: Integrates `lzylipu/immortalwrt-ipsec-kmods` automatically.

---

## 🚀 中文说明

本项目是 `wukongdaily/ImmortalWrt-ImageBuilder` 的定制分支，专门构建支持 **原生 IPsec/XFRM 内核模块**及 **AdGuard Home/代理插件** 的 ImmortalWrt 25.12.x 固件。

## 日常操作
1.  **进入 Actions**：点击顶部的 **Actions** 标签。
2.  **选择工作流**：选择 **Custom Build x86-64**。
3.  **配置参数**：
    *   `firmware_version`: `25.12.0`
    *   `include_docker`: `yes` (推荐，支持运行 IPsec/IKEv2 容器)
    *   `enable_ipsec_kmods`: `yes` (自动集成 Docker IPsec 所需内核模块)
4.  **开始构建**：点击 **Run workflow**。系统会自动下载并集成你选定的插件。

## 插件自定义
通过编辑 `shell/package-selection.conf` 文件来管理插件。
*   **启用**：去掉行首 `#` (例如 `apk luci-app-adguardhome`)。
*   **禁用**：加上行首 `#`。
*   **机制**：构建脚本 (`build25.sh`) 会自动从 `wukongdaily/apk` 拉取插件定义。若选择 OpenClash 或 SSR+，脚本会自动下载 Core 内核 (Clash-Meta/Mihomo)。

### 支持的核心插件
*   **AdGuard Home**: `luci-app-adguardhome`
*   **OpenClash**: `luci-app-openclash` (自动下载内核)
*   **Passwall2**: `luci-app-passwall2`
*   **SSR Plus**: `luci-app-ssr-plus` (自动下载内核)
*   **HomeProxy / Daed / Nikki**: 均支持。
