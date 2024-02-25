#import "Ding.h"

HBPreferences *preferences;

BOOL isEnabled;
BOOL bannerActive = NO;
BOOL prevIsRingerMuted = NO;
BOOL alwaysRingtone;
BOOL hapticFeedback;
BOOL actionMute;

NSInteger switchAction;
NSInteger mode;

extern "C" {
	Boolean CTCellularDataPlanGetIsEnabled(void);
	void CTCellularDataPlanSetIsEnabled(Boolean enabled);
}

BOOL findActionBool(int position) {
	// position (arg1)
	// ---------------
	// 0 = Muted
	// 1 = Unmuted

	return (position == 0) == actionMute;
}

%group CallGroup
%hook SBInCallTransientOverlayViewController
- (void)viewWillAppear:(BOOL)arg1 {
	bannerActive = YES;
	if (alwaysRingtone) [[%c(SBRingerControl) ding_sharedInstance] setRingerMuted:NO];
	%orig;
}

- (void)viewWillDisappear:(BOOL)arg1 {
	bannerActive = NO;
	if (alwaysRingtone) [[%c(SBRingerControl) ding_sharedInstance] setRingerMuted:prevIsRingerMuted];
	%orig;
}
%end

%hook SBRemoteTransientOverlayHostViewController
- (void)viewWillAppear:(BOOL)arg1 {
	bannerActive = YES;
	if (alwaysRingtone) [[%c(SBRingerControl) ding_sharedInstance] setRingerMuted:NO];
	%orig;
}

- (void)viewWillDisappear:(BOOL)arg1 {
	bannerActive = NO;
	if (alwaysRingtone) [[%c(SBRingerControl) ding_sharedInstance] setRingerMuted:prevIsRingerMuted];
	%orig;
}
%end

%hook SBInCallBannerPresentableViewController
- (void)presentableWillAppearAsBanner:(id)arg1 {
	bannerActive = YES;
	if (alwaysRingtone) [[%c(SBRingerControl) ding_sharedInstance] setRingerMuted:NO];
	%orig;
}

- (void)presentableWillDisappearAsBanner:(id)arg1 withReason:(id)arg2 {
	bannerActive = NO;
	if (alwaysRingtone) [[%c(SBRingerControl) ding_sharedInstance] setRingerMuted:prevIsRingerMuted];
	%orig;
}
%end
%end

%hook SpringBoard
- (void)_updateRingerState:(int)arg1 withVisuals:(BOOL)arg2 updatePreferenceRegister:(BOOL)arg3 {
	if (!(switchAction == 1) && hapticFeedback) {
		UIImpactFeedbackGenerator *feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleMedium)];
		[feedback prepare];
		[feedback impactOccurred];
	}

	prevIsRingerMuted = (arg1 == 0) ? YES : NO;

	// Switch Actions
	// --------------
	// 1 = None
	// 2 = Flashlight
	// 3 = Orientation Lock
	// 4 = Airplane Mode
	// 5 = Wi-Fi
	// 6 = Bluetooth
	// 7 = Low Power Mode
	// 8 = Do Not Disturb
	// 9 = Cellular Data
	// 10 = Dark Mode
	switch (switchAction) {
		case 1: break;
		case 2: {
			if (actionMute) {
				[[%c(SBUIFlashlightController) sharedInstance] setLevel:(arg1 == 0) ? 4 : 0];
			} else {
				[[%c(SBUIFlashlightController) sharedInstance] setLevel:(arg1 == 0) ? 0 : 4];
			}
			break;
		}
		case 3: {
			BOOL lock = ((actionMute && arg1 == 0) || (!actionMute && arg1));
			lock ? [[%c(SBOrientationLockManager) sharedInstance] lock] : [[%c(SBOrientationLockManager) sharedInstance] unlock];
			break;
		}
		case 4: {
			[[[%c(RadiosPreferences) alloc] init] setAirplaneMode:findActionBool(arg1)];
			break;
		}
		case 5: {
			[[%c(SBWiFiManager) sharedInstance] setWiFiEnabled:findActionBool(arg1)];
			break;
		}
		case 6: {
			[[%c(BluetoothManager) sharedInstance] setEnabled:findActionBool(arg1)];
			[[%c(BluetoothManager) sharedInstance] setPowered:findActionBool(arg1)];
			break;
		}
		case 7: {
			if (@available(iOS 15.0, *)) {
				if (actionMute) [[%c(_PMLowPowerMode) sharedInstance] setPowerMode:(arg1 == 0) ? 1 : 0 fromSource:@"SpringBoard"];
				else [[%c(_PMLowPowerMode) sharedInstance] setPowerMode:arg1 fromSource:@"SpringBoard"];
			} else {
				if (actionMute) [[%c(_CDBatterySaver) batterySaver] setPowerMode:(arg1 == 0) ? 1 : 0 error:nil];
				else [[%c(_CDBatterySaver) batterySaver] setPowerMode:arg1 error:nil];
			}
			break;
		}
		case 8: {
			DNDModeAssertionService *assertionService = (DNDModeAssertionService *)[objc_getClass("DNDModeAssertionService") serviceForClientIdentifier:@"com.apple.donotdisturb.control-center.module"];
			if (arg1 == 0) {
				if (actionMute) {
					DNDModeAssertionDetails *newAssertion = [objc_getClass("DNDModeAssertionDetails") userRequestedAssertionDetailsWithIdentifier:@"com.apple.control-center.manual-toggle" modeIdentifier:@"com.apple.donotdisturb.mode.default" lifetime:nil];
					[assertionService takeModeAssertionWithDetails:newAssertion error:NULL];
				} else {
					[assertionService invalidateAllActiveModeAssertionsWithError:NULL];
				}
			} else {
				if (actionMute) {
					[assertionService invalidateAllActiveModeAssertionsWithError:NULL];
				} else {
					DNDModeAssertionDetails *newAssertion = [objc_getClass("DNDModeAssertionDetails") userRequestedAssertionDetailsWithIdentifier:@"com.apple.control-center.manual-toggle" modeIdentifier:@"com.apple.donotdisturb.mode.default" lifetime:nil];
					[assertionService takeModeAssertionWithDetails:newAssertion error:NULL];
				}
			}
			[[NSNotificationCenter defaultCenter] postNotificationName:@"SBQuietModeStatusChangedNotification" object:nil];
			break;
		}
		case 9: {
			CTCellularDataPlanSetIsEnabled(findActionBool(arg1));
			break;
		}
		case 10: {
			UISUserInterfaceStyleMode *styleMode = [[%c(UISUserInterfaceStyleMode) alloc] init];
			BOOL dark = ((actionMute && arg1 == 0) || (!actionMute && arg1));
			dark ? styleMode.modeValue = 2 : styleMode.modeValue = 1;
			break;
		}
		default: {
			NSLog(@"[Ding] Unsure what you did...");
			break;
		}
	}

	%orig(arg1, (mode == 2) ? YES : NO, arg3);
}
%end

%hook SBRingerControl
static SBRingerControl *__strong ding_sharedInstance;

// Init for iOS 15 and lower
- (id)initWithHUDController:(id)arg1 soundController:(id)arg2 {
	ding_sharedInstance = %orig;
	return ding_sharedInstance;
}

// Init for iOS 16+
- (id)initWithBannerManager:(id)arg1 soundController:(id)arg2 {
	ding_sharedInstance = %orig;
	return ding_sharedInstance;
}

%new
+ (id)ding_sharedInstance {
	return ding_sharedInstance;
}

- (BOOL)isRingerMuted {
	if (bannerActive && alwaysRingtone) {
		return NO;
	} else {
		if (mode == 2) {
			return %orig;
		} else {
			if (mode == 1) {
				return YES;
			} else {
				return NO;
			}
		}
	}
}

- (void)setRingerMuted:(BOOL)arg1 {
	if (bannerActive && alwaysRingtone) {
		%orig(NO);
	} else {
		if (mode == 2) {
			%orig;
		} else {
			if (mode == 1) {
				%orig(YES);
			} else {
				%orig(NO);
			}
		}
	}
}
%end

%ctor {
	NSLog(@"Ding started!");
	
	preferences = [[HBPreferences alloc] initWithIdentifier:@"me.nebula.ding.prefs"];
	[preferences registerBool:&isEnabled default:YES forKey:@"isEnabled"];
	[preferences registerInteger:&mode default:1 forKey:@"mode"];
	[preferences registerBool:&alwaysRingtone default:NO forKey:@"alwaysRingtone"];
	[preferences registerBool:&hapticFeedback default:YES forKey:@"hapticFeedback"];
	[preferences registerInteger:&switchAction default:1 forKey:@"switchAction"];
	[preferences registerBool:&actionMute default:NO forKey:@"actionMute"];

	if (!isEnabled) return;

	%init;
	if (alwaysRingtone) %init(CallGroup);
}
