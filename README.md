# dleovl says:
This is a fork of `itsnebulalol/ding` to incorporate a GitHub Actions workflow `.yml` for building without a Mac. As the `LICENSE` allows for distribution and modification, this repository can be made. The changes to the source are noted below, making it more reliable and safer than a piracy repository. The link to purchase the tweak is noted below, please do so if you want to support the developer.

Builds for current-day `roothide` will not be available, as the architecture is quickly evolving. Please use the [RootHidePatcher](https://github.com/roothide/RootHidePatcher).

If you want a `rootful` build, [buy Ding from Chariz](https://chariz.com/buy/ding).

## Licensing

The source is untouched, only `.github/workflows/build.yml` has been created for building, and this message created in `README.md`.

At the time of writing, `itsnebulalol/ding` has a GNU General Public License v3.0 license, you can view it [here](https://github.com/itsnebulalol/ding/blob/main/LICENSE). This repository uses the same license.

## Notes

If you like Ding, [buy it on Chariz](https://chariz.com/buy/ding).

Should any issues arise with this repository, do ***NOT*** report it to the developer. While the tweak itself is **untouched**, problems may arise from errors in the `.yml`, which should be addressed in this repository. As there are no Issues, you can state your problems with the tweak in a Pull Request.

<hr>

<picture>
	<source media="(prefers-color-scheme: light)" srcset="https://cdn.discordapp.com/attachments/1028398976640229380/1113461306939412490/DingBannerBlack.png">
	<img align="left" height="120" src="https://cdn.discordapp.com/attachments/1028398976640229380/1113461307182690364/DingBanner.png" alt="Ding Banner" style="float: left;"/>
</picture>

<br clear="both"/>

## Building

1. Install latest [theos](https://theos.dev) and [these SDKs](https://github.com/itsnebulalol/sdks)
2. Run `make clean && make do`
3. Install the deb for your device from `packages`

## Credits

- [Flower](https://github.com/flowerible) for the icon
- [Staturnz](https://github.com/staturnzz) for finding `_updateRingerState` hook for me
- [Fiore](https://github.com/donato-fiore) for some of GameSeagull prefs
- [Alexia](https://github.com/0xallie) for help with manually calling `setRingerMuted`
- [Hydrate](https://github.com/hydrationMan) for figuring out you need Xcode 11 for building rootful on latest Ventura and Sonoma
- [iCraze](https://github.com/iCrazeiOS) for general improvements
