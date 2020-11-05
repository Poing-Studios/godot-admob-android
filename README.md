# Godot AdMob for Android and iOS
This repository uses [GitHub Actions](https://github.com/features/actions), this means that whenever a new update is sent to the repository, the action will automatically test the code of the module, compile, compress the binary files and export to the "Releases" tab of the repository for the respective versions supported by the module, like v3.2.3.

You can check the status here:[![Release](https://github.com/Poing-Studios/Godot-AdMob-Android-iOS/workflows/Build/badge.svg)](https://github.com/Poing-Studios/Godot-AdMob-Android-iOS/actions)

The releases tab: https://github.com/Poing-Studios/Godot-AdMob-Android-iOS/releases


<p align="center">
	<img align="center" src="https://i.imgur.com/u5y2GEx.png">
</p>

### Ad Formats
- Banner 
- Interstitial
- Rewarded
- Unified Native (Native Ads) (ONLY Android at moment)

Is high recommended that when you use AdMob, please include it as AutoLoad and Singleton

Download example project to see how the Plugin works!

# Android (v3.2.2+):
- Download the ```android-template.zip``` in the releases tab. [Choice the Godot version of your game.](https://github.com/Poing-Studios/Godot-AdMob-Android-iOS/releases)
- Enable Android Build Template. [Check the tutorial here](https://docs.godotengine.org/en/stable/getting_started/workflow/export/android_custom_build.html)
- Extract the content in android-template.zip into ```res://android/plugins``` directory on your Godot project
- On your Game Project go to:
	1. Project
		1. Export
			1. Android
				1. Options
					1. Custom Package 
						- [x] ```Use Custom Build```
					1. Plugins 
						- [x] ```Ad Mob```
- Add your AdMob App ID to your app's ```res://android/build/AndroidManifest.xml``` file by adding a ```<meta-data>``` tag with name ```com.google.android.gms.ads.APPLICATION_ID```, as shown below.
```xml
<!-- Sample AdMob App ID: ca-app-pub-3940256099942544~3347511713 -->
<meta-data
	android:name="com.google.android.gms.ads.APPLICATION_ID"
	android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
```

# iOS (v3.0.0+):
- Download the ```ios-template.zip``` in the releases tab. [Choice the Godot version of your game.](https://github.com/Poing-Studios/Godot-AdMob-Android-iOS/releases)
- Export your game to iOS
- Copy the library ```libgodot.iphone.release.fat.a``` you have downloaded from releases tab inside the exported Xcode project. **You must override the 'your_project_name.a' file with this file.**
- Add the following frameworks to the project linking it using the "Link Binary with Libraries" option:
	- Extract the following .framework from ```ios-template.zip```:
		- GoogleAppMeasurement.framework (from GoogleMobileAdsSdkiOS)
		- GoogleMobileAds.framework (from GoogleMobileAdsSdkiOS)
		- GoogleUtilities.xcframework (from GoogleMobileAdsSdkiOS)
		- nanopb.xcframework (from GoogleMobileAdsSdkiOS)
	- These frameworks are already in your computer
		- StoreKit
		- GameKit
		- CoreVideo
		- AdSupport
		- MessageUI
		- CoreTelephony
		- CFNetwork
		- MobileCoreServices
		- SQLite (libsqlite3.0.tbd)
		- JavaScriptCore
- Add the -ObjC linker flag to Other Linker Flags in your project's build settings:
![-ObjC](https://developers.google.com/admob/images/ios/objc_linker_flag.png)
- Update your GAMENAME-Info.plist file, add a GADApplicationIdentifier key with a string value of your [AdMob app ID](https://support.google.com/admob/answer/7356431):
![plist](https://i.imgur.com/1tcKXx5.png)

### API References
---
Signals:
```GDScript
banner_loaded #when an ad finishes loading
banner_destroyed #when banner view is destroyed
banner_failed_to_load(error_code : int) #when an ad request fails
banner_opened #when an ad opens an overlay that
banner_left_application #when the user has left the app
banner_closed #when the user is about to return to the app after tapping on an ad

interstitial_loaded #when an ad finishes loading
interstitial_failed_to_load(error_code : int) #when an ad request fails
interstitial_opened #when the ad is displayed
interstitial_left_application #when the user has left the app
interstitial_closed #when the interstitial ad is closed

rewarded_ad_loaded #when ad successfully loaded
rewarded_ad_failed_to_load #when ad failed to load
rewarded_ad_opened #when the ad is displayed
rewarded_ad_closed #when the ad is closed
rewarded_user_earned_rewarded(currency : String, amount : int) #when user earner rewarded
rewarded_ad_failed_to_show(error_code) #when the ad request fails

unified_native_loaded #when unified native loaded and shows the ad
unified_native_destroyed #when unified native view destroyed
unified_native_failed_to_load(error_code : int) #when an ad request fails
unified_native_opened #when an ad opens an overlay that
unified_native_closed #when the user is about to return to the app after tapping on an ad
```

Methods
```GDScript
init(is_for_child_directed_treatment := true, is_personalized := false, max_ad_content_rating := "G", instance_id := get_instance_id(), test_device_id := "") #init the AdMob

load_banner(gravity : int = GRAVITY.BOTTOM, size : String = "SMART_BANNER", unit_id : String = ad.banner.unit_id[OS.get_name()]) #load the banner will make him appear instantly
load_interstitial(unit_id: String = ad.interstitial.unit_id[OS.get_name()]) #loads the interstitial and make ready for show
load_rewarded(unit_id : String = ad.rewarded.unit_id[OS.get_name()]) #loads the rewarded and make ready for show
load_unified_native(control_node_to_be_replaced : Control = Control.new(), unit_id : String = ad.unified_native.unit_id[OS.get_name()]) #load the unified native will make him appear instantly (unified native and banner are View in Android and iOS, it is recommended to only use one of them at a time, if you try to use both, the module will not allow it, it will remove the older view

destroy_banner() #completely destroys the Banner View
destroy_unified_native() #completely destroys the Unified Native View

show_interstitial() #shows interstitial
show_rewarded() #shows rewarded

_on_AdMob_*() #just to emit signals
```
