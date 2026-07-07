# LZY ImmortalWrt 25.12 x86-64 自定义构建说明

目标：悟空 `ImmortalWrt-ImageBuilder` fork 保持可同步，上游代码尽量不动；LZY 自定义插件和 IPsec/XFRM 内核依赖都放在独立分支/独立仓库里。

## 仓库/分支

- 悟空 fork：`lzylipu/ImmortalWrt-ImageBuilder`
  - `master`：保持同步 `wukongdaily/master`。
  - `lzy/ipsec-kmods`：LZY 自定义构建分支。
- kmod 仓库：`lzylipu/immortalwrt-ipsec-kmods`
  - 自动/手动编译 ImmortalWrt 25.12 x86-64 IPsec/XFRM kmod `.apk`。
  - Release tag 格式：`immortalwrt-<version>-x86-64-<revision>`，例如 `immortalwrt-25.12.0-x86-64-r37854`。

## 日常怎么构建固件

打开：`https://github.com/lzylipu/ImmortalWrt-ImageBuilder/actions`

选择分支：`lzy/ipsec-kmods`

运行 workflow：`Build 25.12.x x86-64`

常用输入：

- `luci_version`：例如 `25.12.0`；以后有 `25.12.1` 可直接填。
- `include_docker`：需要 Docker 就选 `yes`。
- `enable_ipsec_kmods`：需要 Docker IKEv2/IPsec 就选 `yes`。
- `ipsec_kmod_release`：默认 `auto`，会按 `luci_version` 自动匹配 kmod release。
- `profile`：rootfs 分区大小，默认 1024 MB。

## 插件怎么选

只改一个文件：

```text
.lzy/packages-x86-64-25.12.conf
```

格式：

```text
包名 包名2 包名3    # 用途说明
#包名               # 整行注释=不编译进去
```

文件顶部是 LZY 常用插件，中间是热门常用，下面是冷门备用。需要什么就取消行首 `#`，不需要就加回 `#`。

不再需要分散改悟空原来的多个文件。构建脚本会优先读取 `.lzy/packages-x86-64-25.12.conf`；如果这个文件不存在，才回退到悟空原始的 `shell/apk-custom-packages.sh`。

## IPsec/XFRM kmod 自动链路

1. `immortalwrt-ipsec-kmods` 每周自动检查 ImmortalWrt downloads 是否有新的 `25.12.x`。
2. 发现新版本时，读取 `version.buildinfo` 生成固定 tag。
3. 编译并发布 ABI 匹配的：
   - `kmod-ipsec-*.apk`
   - `kmod-ipsec4-*.apk`
   - `kmod-ipsec6-*.apk`
   - `kmod-ipt-ipsec-*.apk`
   - `kmod-nft-xfrm-*.apk`
   - `kmod-xfrm-interface-*.apk`
4. ImageBuilder 构建时按 `luci_version` 自动找到对应 release，校验 `buildinfo.txt` 后下载 `.apk` 并加入固件。

不要用 `latest`。kmod 必须匹配 ImmortalWrt 版本、target、arch packages 和内核 ABI。

## 固件刷入后验证

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

Docker IKEv2 容器仍建议：

```sh
-v /lib/modules:/lib/modules:ro -p 500:500/udp -p 4500:4500/udp --privileged
```
