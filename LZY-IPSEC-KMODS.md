# LZY ImmortalWrt fork 构建说明

## 核心逻辑

- `master`：每天自动同步 `wukongdaily/ImmortalWrt-ImageBuilder` 上游，作为干净镜像分支。
- `lzy/ipsec-kmods`：LZY 自定义分支，每天把上游 `master` 合入本分支；冲突时优先保留本分支自定义，避免同步覆盖自定义文件。
- 普通插件不新造包名、不脱离上游：`shell/lzy-package-selection.conf` 只是汇总选择文件，实际包组从原作者：
  - `shell/apk-custom-packages.sh`（25.12.x / apk）
  - `shell/custom-packages.sh`（24.10.x / ipk）
  中查找并启用。
- 只有 IPsec/XFRM kmod 是 LZY 独立需求，由 `lzylipu/immortalwrt-ipsec-kmods` 编译 release APK 后注入 25.12 固件。

## 日常构建

打开 Actions：`LZY Build x86-64`

常用输入：

- `firmware_version`：`25.12.0` / `24.10.6` 等。
- `rootfs_size_mb`：rootfs 分区大小，默认 `1024`。
- `custom_router_ip`：路由器后台 IP。
- `include_docker`：是否集成 Docker 管理插件。
- `enable_ipsec_kmods`：25.12.x 下是否集成 LZY 独立 IPsec/XFRM kmod。
- `ipsec_kmod_release`：默认 `auto`，按版本自动匹配。

## 插件选择文件

只改：

```text
shell/lzy-package-selection.conf
```

格式：

```text
apk    luci-i18n-nlbwmon-zh-cn    # 只在 25.12.x 的 shell/apk-custom-packages.sh 中查找并启用
custom luci-i18n-nlbwmon-zh-cn    # 只在 24.10.x 的 shell/custom-packages.sh 中查找并启用
#apk   luci-app-openclash         # 行首加 # 表示不启用
```

脚本会找到原作者文件里包含该关键包名的那一整行 `CUSTOM_PACKAGES=...`，去掉注释后执行。因此：

- 上游文件有的包组才能启用；没有就跳过并警告。
- 不会凭空添加未知包，避免没包导致构建失败。
- 排序按：LZY 当前使用 / 热门常用 / 冷门备用。

## IPsec/XFRM kmod

`immortalwrt-ipsec-kmods` 每周自动检查 ImmortalWrt 25.12.x downloads。发现新完整 release 时编译并发布：

- `kmod-ipsec-*.apk`
- `kmod-ipsec4-*.apk`
- `kmod-ipsec6-*.apk`
- `kmod-ipt-ipsec-*.apk`
- `kmod-nft-xfrm-*.apk`
- `kmod-xfrm-interface-*.apk`

ImageBuilder 构建 25.12.x 时会按 `firmware_version` 自动匹配对应 release，校验版本/target/arch 和 SHA256 后注入固件。

## 刷入后验证

```sh
uname -r
find /lib/modules/$(uname -r) -type f | grep -E 'xfrm|esp|ah|ipcomp|af_key'
modprobe xfrm_user
modprobe esp4
modprobe af_key
lsmod | grep -E 'xfrm|esp|ah|ipcomp|af_key|authenc'
ip xfrm state
ip xfrm policy
```
