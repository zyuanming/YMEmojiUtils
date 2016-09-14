# YMEmojiUtils
Export iOS Emojis and Create the emoji images.

这个iOS 小项目主要是用来导出系统的Emoji资源，并生成图片，打包到统一的一个data文件中，并生成对应的Plist文件，用来连接Emoji和图片。

模仿搜狗输入法的Emoji资源管理方式，这样做主要是为了减少内存占用，具体可查看[这篇博文](http://mp.weixin.qq.com/s?__biz=MzA4MzEwOTkyMQ==&mid=2667375867&idx=1&sn=4dc0e037124341145aea5fbf9716a3ab&scene=1&srcid=0905MS9frvfEiQ3LxxqJwZyO&from=groupmessage&isappinstalled=0#wechat_redirect)。

## 用到的第三方资源
1. [gemoji](https://github.com/github/gemoji) : 用Ruby写的一个脚本，用来导出当前Mac系统的Emoji列表，clone到本地后，在命令行执行

    rake db/Category-Emoji.json
    
2. [pngquant](https://pngquant.org/) : 也是一个命令行工具，用来进行图片有损压缩，效率很高。

3. [ImageOptim](https://imageoptim.com/mac) : 无损压缩工具，提供GUI界面，简单，但是处理大量图片时会很慢。