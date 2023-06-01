#import "Ding.h"

HBPreferences *preferences;

BOOL isEnabled;
BOOL bannerActive = NO;
BOOL alwaysRingtone;
BOOL hapticFeedback;

NSInteger switchAction;
NSInteger mode;
NSInteger state;


%group CallGroup
%hook SBInCallBannerPresentableViewController
- (void)presentableDidAppearAsBanner:(id)arg1 {
    bannerActive = YES;
    %orig;
}

- (void)presentableDidDisappearAsBanner:(id)arg1 withReason:(id)arg2 {
    bannerActive = NO;
    %orig;
}
%end
%end


%hook SpringBoard
-(void)_updateRingerState:(int)arg1 withVisuals:(BOOL)arg2 updatePreferenceRegister:(BOOL)arg3  {
	NSLog(@"[Ding] _updateRingerState: %d", arg1);
		switch(switchAction) {
	case 2:
		[[%c(SBUIFlashlightController) sharedInstance] setLevel:(arg1 == 0) ? 0 : 4];
		break;
	case 3: 
		if (arg1 == 0) [[%c(SBOrientationLockManager) sharedInstance] unlock]; 
		else [[%c(SBOrientationLockManager) sharedInstance] lock];
		break;
	case 4: 
		[[[%c(RadiosPreferences) alloc] init] setAirplaneMode:(arg1 == 0) ? NO : YES];
		break;
	case 5: 
		[[%c(SBWiFiManager) sharedInstance] setWiFiEnabled:(arg1 == 0) ? NO : YES];
		break;
	case 6: 
		[[%c(BluetoothManager) sharedInstance] setEnabled:(arg1 == 0) ? NO : YES];
		[[%c(BluetoothManager) sharedInstance] setPowered:(arg1 == 0) ? NO : YES];
		break; 
	case 7: 
		[[%c(SBWiFiManager) sharedInstance] setMobileDataEnabled:(arg1 == 0) ? NO : YES];
		break;
	case 8:	
		[[%c(_PMLowPowerMode) sharedInstance] setPowerMode:arg1 fromSource:@"SpringBoard"];
		break;
	default:
		NSLog(@"[Ding] Unsure what you did...");
		break;
   }
   
    if (hapticFeedback) {
        UIImpactFeedbackGenerator *feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleMedium)];
        [feedback prepare];
        [feedback impactOccurred];
    }

   %orig(arg1, NO, arg3);
}
%end

%ctor {
    NSLog(@"Ding started!");
	
    preferences = [[HBPreferences alloc] initWithIdentifier:@"me.nebula.ding.prefs"];
    [preferences registerBool:&isEnabled default:NO forKey:@"isEnabled"];
    [preferences registerInteger:&mode default:1 forKey:@"mode"];
    [preferences registerBool:&alwaysRingtone default:NO forKey:@"alwaysRingtone"];
    [preferences registerBool:&hapticFeedback default:YES forKey:@"hapticFeedback"];
    [preferences registerInteger:&switchAction default:1 forKey:@"switchAction"];

    if (isEnabled) {
        %init;

		if (alwaysRingtone) {
            %init(CallGroup);
        }
    }
}
