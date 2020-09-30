# Godot AdMob (All Godot 3 versions)
![example](https://i.imgur.com/9Gl22Ta.png)

### Android and iOS
- Banner 
- Interstitial
- Rewarded
- Unified Native (Native Ads) (ONLY Android at moment)

Is high recommended that when you use AdMob, please include it as AutoLoad and Singleton

Download example project to see how the Plugin works!

# Android:
- Clone or download the repository
- Follow this tutorial: https://godotengine.org/article/godot-3-2-will-get-new-android-plugin-system
- Copy and paste the folder "admob/android/admob" to "res://android/build" into your game project
- Change "admob/AndroidManifest.conf" to your APPLICATION_ID on https://admob.google.com/

# iOS:
- Clone or download the repository
- Download Godot's source-code version that your game is using **(recommended above 3.2)**: https://github.com/godotengine/godot/releases
- Copy and paste the folder "admob" to folder "modules" of Godot's source-code
- Download and extract the [Google Mobile Ads SDK](https://developers.google.com/admob/ios/download) **(recommended 7.58.0)** inside the directory "admob/ios/lib"; (If you are unable to download the version informed above, you can alternatively download it through [Cocoapods](https://cocoapods.org/#install))
- Compile for iOS: http://docs.godotengine.org/en/stable/development/compiling/compiling_for_ios.html
- Export your game to iOS
- Copy the library (.a) you have compiled following the official documentation inside the exported Xcode project. You must override the 'your_project_name.a' file with this file.
- Add the following frameworks to the project linking it using the "Link Binary with Libraries" option:
	- GoogleAppMeasurement.framework (from GoogleMobileAdsSdkiOS)
	- GoogleMobileAds.framework (from GoogleMobileAdsSdkiOS)
	- GoogleUtilities.xcframework (from GoogleMobileAdsSdkiOS)
	- nanopb.xcframework (from GoogleMobileAdsSdkiOS)
	- StoreKit
	- GameKit
	- CoreVideo
	- AdSupport
	- MessageUI
	- CoreTelephony
	- CFNetwork
	- MobileCoreServices
	- SQLite (libsqlite3.0.tbd)
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
