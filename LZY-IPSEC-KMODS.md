# LZY 25.12 x86-64 IPsec/XFRM kmod 集成

本分支只做一件事：在悟空 `ImmortalWrt-ImageBuilder` 的 25.12 x86-64 工作流里，按 Release tag 下载 ABI 匹配的 IPsec/XFRM kmod `.apk`，再交给 ImageBuilder 打进固件。

## 分支策略

- `master`：保持与 `wukongdaily/ImmortalWrt-ImageBuilder` 上游同步，不放自定义逻辑。
- `lzy/ipsec-kmods`：自定义构建分支，新增最小补丁。
- `.github/workflows/sync-upstream-master.yml`：定时把 fork 的 `master` 同步回上游 `master`，避免复刻目录越改越脏。

## 使用方式

在 Actions 里运行 `Build 25.12.x x86-64`：

- `luci_version`：先用 `25.12.0`
- `include_docker`：`yes`
- `enable_ipsec_kmods`：`yes`
- `ipsec_kmod_repo`：`lzylipu/immortalwrt-ipsec-kmods`
- `ipsec_kmod_release`：必须选择同版本同 target 的 tag，例如 `immortalwrt-25.12.0-x86-64-r37854`

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

Docker IKEv2 容器仍建议挂载宿主模块目录并开放 UDP 500/4500：

```sh
-v /lib/modules:/lib/modules:ro -p 500:500/udp -p 4500:4500/udp --privileged
```
