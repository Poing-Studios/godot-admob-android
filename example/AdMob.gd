extends Control

signal banner_loaded
signal banner_destroyed
signal banner_failed_to_load(error_code)
signal banner_opened
signal banner_clicked
signal banner_left_application
signal banner_closed

signal interstitial_loaded
signal interstitial_failed_to_load(error_code)
signal interstitial_opened
signal interstitial_clicked
signal interstitial_left_application
signal interstitial_closed

signal rewarded_ad_loaded
signal rewarded_ad_failed_to_load
signal rewarded_ad_opened
signal rewarded_ad_closed
signal rewarded_user_earned_rewarded(currency, amount)
signal rewarded_ad_failed_to_show(error_code)

signal unified_native_loaded
signal unified_native_destroyed
signal unified_native_failed_to_load(error_code)
signal unified_native_opened
signal unified_native_closed

var admob_enabled := true

var _AdMob
var initialized := false

onready var ad_formats : Dictionary = {
	"banner" : {
		"unit_id": {
			"iOS" : "ca-app-pub-3940256099942544/2934735716",
			"Android" : "ca-app-pub-3940256099942544/6300978111",
		},
		"gravity" : {
			"TOP" : 48,
			"BOTTOM" : 80,
			"CENTER" : 17,
			"NO_GRAVITY" : 0
		}
	},
	"interstitial" : {
		"unit_id": {
			"iOS" : "ca-app-pub-3940256099942544/4411468910",
			"Android" : "ca-app-pub-3940256099942544/1033173712",
		},
	},
	"rewarded" : {
		"unit_id": {
			"iOS" : "ca-app-pub-3940256099942544/1712485313",
			"Android" : "ca-app-pub-3940256099942544/5224354917",
		},
	},
	"unified_native" : {
		"unit_id": {
			"iOS" : "",
			"Android" : "ca-app-pub-3940256099942544/2247696110",
		},
		"scale" : {
			"x" : OS.get_screen_size().x / get_viewport_rect().size.x,
			"y" : OS.get_screen_size().y / get_viewport_rect().size.y,
		},
	},
}

var local_size = ["BANNER", "MEDIUM_RECTANGLE", "FULL_BANNER", "LEADERBOARD", "SMART_BANNER"]

func _ready():
	if admob_enabled:
		if (Engine.has_singleton("AdMob")):
			_AdMob = Engine.get_singleton("AdMob")
			_initialize()
			get_tree().connect("screen_resized", self, "_on_get_tree_resized")

func _initialize(is_for_child_directed_treatment := true, is_personalized := false, max_ad_content_rating := "G", is_real := false):
	if _AdMob and !initialized:
		_AdMob.initialize(is_for_child_directed_treatment, is_personalized, max_ad_content_rating, is_real, get_instance_id())
		load_interstitial()
		load_rewarded()
		initialized = !initialized

func load_banner(gravity : int = ad_formats.banner.gravity.BOTTOM, size : String = "SMART_BANNER", unit_id : String = ad_formats.banner.unit_id[OS.get_name()]):
	if _AdMob:
		_AdMob.load_banner(unit_id, gravity, local_size[0])

func load_interstitial(unit_id : String = ad_formats.interstitial.unit_id[OS.get_name()]):
	if _AdMob:
		_AdMob.load_interstitial(unit_id)

func load_rewarded(unit_id : String = ad_formats.rewarded.unit_id[OS.get_name()]):
	if _AdMob:
		_AdMob.load_rewarded(unit_id)

func load_unified_native(control_node_to_be_replaced : Control, unit_id : String = ad_formats.unified_native.unit_id[OS.get_name()]):
	if _AdMob:
		var params := {
			"size" : {
				"w" : control_node_to_be_replaced.rect_size.x * ad_formats.unified_native.scale.x,
				"h" : control_node_to_be_replaced.rect_size.y * ad_formats.unified_native.scale.y
			},
			"position" : {
				"x" : control_node_to_be_replaced.rect_position.x * ad_formats.unified_native.scale.x,
				"y" : control_node_to_be_replaced.rect_position.y * ad_formats.unified_native.scale.y
			}
		}
		_AdMob.load_unified_native(unit_id, [params.size.w, params.size.h], [params.position.x, params.position.y])

func destroy_banner():
	if _AdMob:
		_AdMob.destroy_banner()

func destroy_unified_native():
	if _AdMob:
		_AdMob.destroy_unified_native()

func show_interstitial():
	if _AdMob:
		_AdMob.show_interstitial()

func show_rewarded():
	if _AdMob:
		_AdMob.show_rewarded()

func _on_get_tree_resized():
	if _AdMob:
		ad_formats.unified_native.scale = {
			"x" : OS.get_screen_size().x / get_viewport_rect().size.x,
			"y" : OS.get_screen_size().y / get_viewport_rect().size.y
		}


#SIGNALS
func _on_AdMob_banner_loaded():
	emit_signal("banner_loaded")
	
func _on_AdMob_banner_destroyed():
	emit_signal("banner_destroyed")

func _on_AdMob_banner_failed_to_load(error_code : int):
	emit_signal("banner_failed_to_load", error_code)
	
func _on_AdMob_banner_opened():
	emit_signal("banner_opened")
	
func _on_AdMob_banner_clicked():
	emit_signal("banner_clicked")
	
func _on_AdMob_banner_left_application():
	emit_signal("banner_left_application")
	
func _on_AdMob_banner_closed():
	emit_signal("banner_closed")
	
func _on_AdMob_interstitial_loaded():
	emit_signal("interstitial_loaded")

func _on_AdMob_interstitial_failed_to_load(error_code : int):
	emit_signal("interstitial_failed_to_load", error_code)
	
func _on_AdMob_interstitial_clicked():
	emit_signal("interstitial_clicked")
	
func _on_AdMob_interstitial_left_application():
	emit_signal("interstitial_left_application")

func _on_AdMob_interstitial_opened():
	emit_signal("interstitial_opened")
	get_tree().paused = true

func _on_AdMob_interstitial_closed():
	load_interstitial()
	emit_signal("interstitial_closed")
	get_tree().paused = false

func _on_AdMob_rewarded_ad_opened():
	emit_signal("rewarded_ad_opened")
	get_tree().paused = true

func _on_AdMob_rewarded_ad_closed():
	load_rewarded()
	emit_signal("rewarded_ad_closed")
	get_tree().paused = false

func _on_AdMob_rewarded_ad_loaded():
	emit_signal("rewarded_ad_loaded")

func _on_AdMob_rewarded_ad_failed_to_load():
	emit_signal("rewarded_ad_failed_to_load")
	
func _on_AdMob_user_earned_rewarded(currency : String, amount : int):
	emit_signal("rewarded_user_earned_rewarded", currency, amount)

func _on_AdMob_rewarded_ad_failed_to_show(error_code : int):
	emit_signal("rewarded_ad_failed_to_show", error_code)

func _on_AdMob_unified_native_loaded():
	emit_signal("unified_native_loaded")

func _on_AdMob_unified_native_destroyed():
	emit_signal("unified_native_destroyed")

func _on_AdMob_unified_native_failed_to_load(error_code : int):
	emit_signal("unified_native_failed_to_load", error_code)

func _on_AdMob_unified_native_opened():
	emit_signal("unified_native_opened")
	
func _on_AdMob_unified_native_closed():
	emit_signal("unified_native_closed")