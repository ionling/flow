+++
title = "GFW"
date = 2023-04-09T13:00:00+08:00
lastmod = 2023-04-09T13:00:00+08:00
draft = false
+++

Climbing over the Great Firewall is my life.


## Airport {#airport}

-   机场
-   [优质 V2Ray/SS/SSR 机场推荐 | 随遇而安](https://www.iszy.cc/2019/01/03/sci-conn/)


### No account {#no-account}

1.  [Fir3Beast](https://fir3beast.dnsisp.net/index.html)
2.  [N.C.Back](http://niuxsd.cn/user)
3.  [AAEX](https://aaex.org/)
4.  [SS-Link](https://www.ss-link.com/)
5.  [THE.SSR](https://thessr.tk/user)
6.  [FCloud](https://fcloud.life/cart.php)
7.  [GeekCloud](https://geekv2ray.ml/)
8.  [V2Club](https://my.v2fly.club/#/dashboard)


### With account {#with-account}

1.  [SSLM](https://sslm.ml/home/index)
2.  <https://tianlinzhao.com/clientarea.php>
3.  [Catchflying](https://www.catchflying.network/)
4.  [Blinkload 用户中心](https://dash.blinkload.zone/auth/register?code=Lp85)
5.  [SudaCloud](https://v2.suda.moe/user), 按量付费
6.  [STC-SPADES](https://mqk4azjxg8skg6gfelpb.stcserver-cloud.com/), 按量付费
7.  [ByWave - 全球网络加速](https://bywave.io/)
8.  [TAGInternet - @mes_kwahwai](https://tagss.pro), 按量付费


### Free {#free}

-   [ssr 分享站](http://ssr.wangzhan.gq)
-   [Nodes-anys.ga](https://anys.ga/nodess.html)
-   [免费上网账号](https://free-ss.site)
-   [Free SS](http://www.freess.cf)
-   <http://ss.pythonic.life>
-   <http://104.192.83.53/intro.html>
-   <https://www.youneed.win/free-ss>


## Clients {#clients}


### Clash {#clash}

-   [GitHub - Dreamacro/clash: A rule-based tunnel in Go.](https://github.com/Dreamacro/clash)
-   [Windows 上有什么好点的开源的代理软件吗？ - V2EX](https://v2ex.com/t/805833)
-   [Linux安装Clash - 知乎](https://zhuanlan.zhihu.com/p/396272999)


#### GUI {#gui}


-  Dashboard

    -   [Linux安装Clash - 福星的文章 - 知乎](https://zhuanlan.zhihu.com/p/396272999)


-  For Windows


    -  Change listening ports

        -   [Fndroid/clash_for_windows_pkg#629 修改端口不生效，端口未被占用](https://github.com/Fndroid/clash_for_windows_pkg/issues/629)

        **注意**: 在版本 `v0.11.6` 上修改不能删除 `mixed-port`, 否则程序会自动删除已有的 `port`,
        `socks-port` 配置项, 再添加上 `mixed-port` 节, 这样修改就会失效. 我们直接增加 `port` 或
        `socks-port` 配置即可, 不要删除 `mixed-port`.


    -  TUN mode

        -   [TUN 模式 | Clash for Windows](https://docs.cfw.lbyczf.com/contents/tun.html)
        -   可以用来实现透明代理


-  ClashX

    -   [GitHub - yichengchen/clashX](https://github.com/yichengchen/clashX)


### Netch {#netch}

-   [GitHub - netchx/netch: A simple proxy client](https://github.com/netchx/netch)


## Links {#links}

-   [用 ACL 代替 Pac 进行更底层的智能分流](https://darknode.in/network/acl-geoip-proxy/)
-   [透明代理 | 新 V2Ray 白话文指南](https://guide.v2fly.org/app/transparent_proxy.html)
-   [个人翻墙事宜的一些总结与经验分享](https://medium.com/@vonsis/%E8%BF%91%E6%9C%9F%E4%BB%A5%E6%9D%A5%E7%A7%91%E5%AD%A6%E4%B8%8A%E7%BD%91-%E7%BF%BB%E5%A2%99-%E4%BA%8B%E5%AE%9C%E7%9A%84%E4%B8%80%E4%BA%9B%E6%80%BB%E7%BB%93-8928d55bce73)
-   [surge-networks/snell: An encrypted proxy service program](https://github.com/surge-networks/snell)
-   [国内主流网络运营商国际连接线路简谈 - 知乎](https://zhuanlan.zhihu.com/p/64467370)
-   [GitHub - StreisandEffect/streisand: Streisand sets up a new server running yo...](https://github.com/StreisandEffect/streisand)
-   [几种VPN常见组网方法介绍 - 每日头条](https://kknews.cc/zh-sg/news/je5mxvl.html)
-   GRE tunnel


## Principle {#principle}

From [科学上网的原理 - 不挑食的程序员 - SegmentFault 思否](https://segmentfault.com/a/1190000011485579):

> GFW 最近弄的是先检测首部特征判断 SSL 和 SSH，然后统计包长度和方向，用实现训练
> 好的模型去判断承载的流量是否为 HTTP。


## Protocol {#protocol}


### Shadowsocks {#shadowsocks}

-   [GitHub - shadowsocks/shadowsocks-rust: A Rust port of shadowsocks](https://github.com/shadowsocks/shadowsocks-rust)
-   [GitHub - shadowsocks/shadowsocks-libev: libev port of shadowsocks](https://github.com/shadowsocks/shadowsocks-libev)
-   [加速 Shadowsocks | 下一站 - Ihcblog!](https://www.ihcblog.com/How-to-Speed-Up-Shadowsocks/)
    -   这篇文章将简要总结一下目前科学上网的加速方式，
        并详细介绍我基于 Shadowsocks 做的一个加速工作。


#### ss-libev {#ss-libev}

```sh
ss-local -s c27s2.jamjams.net -p 63968 -m aes-256-gcm -k GARtpLWnrL -l 2345
```


#### Issues {#issues}


-  移动 4G 无法联网

    -   [移动 4G 无法连接 SSR 解决方案汇总--以 SAMSUNG S7edge 为例 - 知乎](https://zhuanlan.zhihu.com/p/94088821)
    -   [shadowsocks/shadowsocks-android#2143 移动 4G cmnet 连不上](https://github.com/shadowsocks/shadowsocks-android/issues/2143)
    -   [用户“用户 4720816”对问题“为什么在 vultr 上搭建 SS，手机使用 4G 信号时无法连接？”的回答 - 问答 - 云+社区 - 腾讯云](https://cloud.tencent.com/developer/ask/197944/answer/320350)

    手动设置 APN, APN 协议及 APN 漫游协议都从"ipv4/ipv6"改成"ipv4"


### Tor {#tor}

-   [Tor - ArchWiki](https://wiki.archlinux.org/index.php/Tor)
-   [配置 tor browser 实现访问暗网 | Leticia‘s Blog](https://uuzdaisuki.com/2018/03/01/%E9%85%8D%E7%BD%AEtor-browser%E5%AE%9E%E7%8E%B0%E8%AE%BF%E9%97%AE%E6%9A%97%E7%BD%91/)


#### Logs {#logs}

`[2019-10-31 Thu]`: 试了一下, 直接 `yay -S tor`, 然后 `systemctl start tor` 即
可. 不过浏览器设置 `socks5://127.0.0.1:9050` 无法访问. 看了网上的文章后发现国
内需要配置代理才能访问. 本来是想测试 Tor 翻墙的可能性, 不能翻的话就算了, 有空
再配置来看看暗网是什么样的.


### V2ray {#v2ray}


#### Install {#install}

当 yum 或 apt-get 可用的情况下:

```bash
bash <(curl -L -s https://install.direct/go.sh)
```

Arch: `pacman -S v2ray`

使用上面的脚本方法安装后(Debian 9 机器), 会自动产生 `/etc/v2ray/config.json` 文件,
我们可以直接 `systemctl start v2ray` 来运行 V2Ray server(似乎也不需要配置下
iptables).

然后上 Play Store 随意下载一个客户端(v2rayNG, BitrostV), 测试一下.


#### Speedup {#speedup}

-   BBR


#### Clients {#clients}

-   [神一样的工具们 · Project V 官方网站](https://www.v2ray.com/awesome/tools.html)


-  v2rayA

    -   [GitHub - v2rayA/v2rayA: A Linux web GUI client of Project V which supports V2...](https://github.com/v2rayA/v2rayA)


-  V2RayU

    -   [GitHub - yanue/V2rayU: V2rayU,基于v2ray核心的mac版客户端...](https://github.com/yanue/V2rayU)
    -   `[2022-06-05 Sun]`: 仓库已清空


    ```sh
    brew cask install v2rayu
    ```


-  Kitsunebi


-  Qv2ray


-  Leaf

    -   [GitHub - eycorsican/leaf: A versatile and efficient proxy framework with nice...](https://github.com/eycorsican/leaf)
    -   `[2022-06-05 Sun]`: 配置 tun 模式并转发到本地的 Clash 端口上, 但是有问题, 终端会显示
        `tcp full`, 同样的 URL 会发多次请求 (应该是请求失败了), 所以放弃了.


### Wireguard {#wireguard}

-   [Wireguard：简约之美 - 陈天的文章 - 知乎](https://zhuanlan.zhihu.com/p/91383212)
-   [Wireguard over Vmess/Vless - 安全隐蔽且容易配置的VPN三层隧道 | 木不子的窒息小茶室](https://cupkappu.github.io/2020/09/27/Wireguard-over-V2ray/)
-   [WireGuard/2.用 wg-quick 调用 wg0.conf 管理 WireGuard.md at master · wgredlong/Wire...](https://github.com/wgredlong/WireGuard/blob/master/2.%E7%94%A8%20wg-quick%20%E8%B0%83%E7%94%A8%20wg0.conf%20%E7%AE%A1%E7%90%86%20WireGuard.md)
-   [wireguard 组建非对称路由](https://aoyouer.com/posts/wireguard-asymmetric-routing/)
-   [GitHub - netbirdio/netbird: Connect your devices into a single secure private...](https://github.com/netbirdio/netbird)


#### Demo {#demo}

```sh
sudo ip link add dev wg0 type wireguard

# Check
ip a

wg genkey | tee client.key
wg pubkey < client.key > client.pub


docker run -d \
       --name=wireguard \
       --cap-add=NET_ADMIN \
       --cap-add=SYS_MODULE \
       -e PUID=1000 \
       -e PGID=1000 \
       -e TZ=Europe/London \
       -p 51820:51820/udp \
       -v config:/config \
       -v /lib/modules:/lib/modules \
       --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
       --restart unless-stopped \
       linuxserver/wireguard
```


## Speed test {#speed-test}

-   [技术|tespeed-测试网速的 Python 工具](https://linux.cn/article-5210-1.html)
-   [GitHub - mobier/shadowsocksr-speed: SSR 批量测试节点有效带宽](https://github.com/mobier/shadowsocksr-speed)
-   [speedtest-cli 网络测速 - 运维之路](http://www.361way.com/speedtest-cli-test-network-speed/3094.html)

看了这么多, 程序不好实现, 暂且不谈 SS 的测速, 光是正常的带宽的测试, 现有的方
案就是利用 speedtest.net 的服务器进行测试, 先做其他简单的, 有思路的小项目吧.


## Tools {#tools}


### COW {#cow}

-   (Climb Over the Wall)
-   [cyfdecyf/cow: HTTP proxy written in Go.](https://github.com/cyfdecyf/cow)
-   已经停更了, 最近一次提交是在 2016 年了


### proxychains {#proxychains}

```sh
brew install proxychains-ng
```
