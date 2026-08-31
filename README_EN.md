# 📡 ImmortalWrt-ImageBuilder (ipsec-kmods Branch)

**Custom ImmortalWrt 25.12.x x86-64 Firmware Builder — Docker VPN · Ad Blocking · Meta Proxy Cores**

**English | [简体中文](./README.md)**

---

> 📡 A customized fork of **[@wukongdaily](https://github.com/wukongdaily)**'s excellent [ImmortalWrt-ImageBuilder](https://github.com/wukongdaily/ImmortalWrt-ImageBuilder) workflow, compiling **ImmortalWrt 25.12.x (x86-64)** firmware with native Docker VPN (IKEv2/L2TP) support, ad blocking and pre-baked Meta proxy cores.

---

## ✨ Key Customized Features

* **🛡️ Native IPsec/XFRM Kmods Integration** — Resolves the infamous "kernel unsupported" error for Docker-based Libreswan/strongSwan by injecting matching xfrm/tunneling kmod APKs, dynamically pulled from the [`lzylipu/immortalwrt-ipsec-kmods`](https://github.com/lzylipu/immortalwrt-ipsec-kmods) release script.
* **🔌 Direct Rootfs Injection for Custom Plugins** — Automatically clones and bakes custom LuCI UIs (e.g. [`luci-app-ipsec-hwdsl2`](https://github.com/lzylipu/luci-app-ipsec-hwdsl2)) straight into the rootfs `files/` folder — no manual APK packaging needed.
* **🎛️ Unified Control Panel** — Enable/disable all third-party plugins from a single place: `shell/package-selection.conf`.
* **📦 Pre-downloaded Meta Cores** — The workflow automatically downloads and packs the latest Meta cores (mihomo / clash_meta) and rulesets, avoiding first-boot network errors.

## 🚀 Daily Firmware Build Guide

1. Open this repo's **Actions** tab and pick **Build 25.12.x x86-64**.
2. Open the **Run workflow** dropdown.
3. Configure the inputs:
   - `custom_router_ip` — your desired management address (e.g. `192.168.100.1`)
   - `profile` — partition size; for Docker images strongly recommend **5120** (5 GB) or above
   - `include_docker` — `yes` to enable Docker support
   - `enable_ipsec_kmods` — `yes` to auto-load the IPsec kernel modules
4. Hit **Run workflow**; the firmware appears in **Releases** when the build finishes.

## 📝 Credits / Upstream Attribution

This project is an open-source extension of the upstream [wukongdaily/ImmortalWrt-ImageBuilder](https://github.com/wukongdaily/ImmortalWrt-ImageBuilder). Special thanks to the original author for the automated build framework.

## 📄 License

[MIT](./LICENSE) License
