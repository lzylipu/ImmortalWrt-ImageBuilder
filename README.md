# ImmortalWrt-ImageBuilder (ipsec-kmods)

> English | [简体中文](#中文说明)

A customized fork of `wukongdaily/ImmortalWrt-ImageBuilder` for building ImmortalWrt 25.12.x x86-64 firmware with native **AdGuard Home**, **OpenClash**, **Passwall2**, **SSR+**, and **IPsec/XFRM** support.

## Daily Operations
1. Go to **Actions** → **Build x86-64**.
2. Click **Run workflow**.
3. Configure:
   - `firmware_version`: `25.12.0`
   - `include_docker`: `yes`
   - `enable_ipsec_kmods`: `yes`
4. Click **Run workflow**.

## Plugin Customization
Edit `shell/package-selection.conf`:
- **Enable**: Remove `#` from the line (e.g., `apk luci-app-adguardhome`).
- **Mechanism**: The build script automatically resolves dependencies and downloads cores (clash-meta, mihomo).

### Supported Key Plugins
- **AdGuard Home (AG)**: `luci-app-adguardhome`
- **OpenClash**: `luci-app-openclash`
- **Passwall2**: `luci-app-passwall2`
- **SSR Plus**: `luci-app-ssr-plus`

---

## 中文说明

本项目是 `wukongdaily/ImmortalWrt-ImageBuilder` 的定制分支，支持 **AdGuard Home**、**OpenClash**、**Passwall2**、**SSR+** 及 **原生 IPsec/XFRM**。

### 日常操作
1. 打开 **Actions** → **Build x86-64**。
2. 点击 **Run workflow**。
3. 配置参数并运行。

### 插件自定义
编辑 `shell/package-selection.conf`，去掉行首 `#` 即可启用。
