# ImmortalWrt-ImageBuilder (ipsec-kmods branch)

本项目为基于悟空 `wukongdaily/ImmortalWrt-ImageBuilder` 的第三方 fork，专门用于构建支持 Docker IKEv2/IPsec 的 ImmortalWrt 25.12.x x86-64 固件。

## 核心规范
- **master**: 保持与上游 `wukongdaily/ImmortalWrt-ImageBuilder` 同步。
- **ipsec-kmods**: 自定义构建分支，集成 `AdGuardHome`, `OpenClash`, `Passwall2`, `SSR+` 等插件及 Docker 必需内核依赖。
- **集成逻辑**: 插件通过 `shell/package-selection.conf` 控制，取消注释即可自动从 `shell/apk-custom-packages.sh` 引用。

## 日常构建流程
1. 打开 GitHub **Actions**。
2. 选择 **Build x86-64** 工作流。
3. 点击 **Run workflow**：
    - `firmware_version`: `25.12.0` (默认)
    - `include_docker`: `yes`
    - `enable_ipsec_kmods`: `yes` (集成 XFRM/IPsec 内核模块，Docker VPN 必需)
    - 根据需要配置其它参数。

## 插件自定义
仅需编辑 `shell/package-selection.conf`，通过 `#` 注释控制集成状态。
- **AdGuard Home**: 取消注释 `apk luci-app-adguardhome`。
- **代理插件**: 取消注释 `openclash`, `passwall2`, `ssr-plus`, `homeproxy` 等即可。

## IPsec/XFRM 内核模块同步
本项目自动对接 `lzylipu/immortalwrt-ipsec-kmods` 仓库，每周自动编译并发布 ABI 匹配的 kmod，构建时自动下载注入。
