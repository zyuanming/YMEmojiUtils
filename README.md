#YMEmojiUtils
Export iOS Emojis and Create the emoji images.

##Features
run this ios app on your latest simulator. it will export all the emoji image files to a single data file and the related plist file to link the emoji symbol and image.

related article by Sougou Input (http://mp.weixin.qq.com/s?__biz=MzA4MzEwOTkyMQ==&mid=2667375867&idx=1&sn=4dc0e037124341145aea5fbf9716a3ab&scene=1&srcid=0905MS9frvfEiQ3LxxqJwZyO&from=groupmessage&isappinstalled=0#wechat_redirect)。

##Requirements
- iOS 10+
- Xcode 8+
- iPhone/iPad

###ThirdResources
1. [gemoji](https://github.com/github/gemoji) : script writen by Ruby, to export the emoji list from your mac. clone this repository and run script down here.

    rake db/Category-Emoji.json
    
2. [pngquant](https://pngquant.org/) : a command tool to compress image, support batch process.

3. [ImageOptim](https://imageoptim.com/mac) : opensource gui tool.

###License

Released under [MIT License.](https://github.com/zyuanming/YMEmojiUtils/blob/master/LICENSE)
