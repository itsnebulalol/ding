<picture>
	<source media="(prefers-color-scheme: light)" srcset="https://cdn.discordapp.com/attachments/1028398976640229380/1113461306939412490/DingBannerBlack.png">
	<img align="left" height="120" src="https://cdn.discordapp.com/attachments/1028398976640229380/1113461307182690364/DingBanner.png" alt="Ding Banner" style="float: left;"/>
</picture>

<br clear="both"/>

## Compile

1. Install latest [theos](https://theos.dev)
2. Download [iOS 13 toolchain](https://github.com/nahtedetihw/Xcode11Toolchain) and put it in `$THEOS/toolchain` (name it `Xcode.xctoolchain`)
3. Run `make clean package && make clean package THEOS_PACKAGE_SCHEME=rootless`
4. Install the deb for your device from `packages`

## Credits

- [Flower](https://github.com/flowerible) for the icon
- [Staturnz](https://github.com/staturnzz) for finding `_updateRingerState` hook for me
- [Fiore](https://github.com/donato-fiore) for some of GameSeagull prefs
