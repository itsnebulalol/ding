#import <Foundation/Foundation.h>
#import <rootless.h>
#import "Tweak.h"
#import <UIKit/UIKit.h>
#include <Cephei/HBPreferences.h>

HBPreferences *preferences;
BOOL isEnabled;
NSInteger mode;
BOOL alwaysRingtone;
BOOL hapticFeedback;
NSInteger switchAction;

BOOL bannerActive = NO;
NSInteger state;

void ringerAction(int pos) {
    // 0 = Unmuted
    // 1 = Muted

    // Switch Actions
    // --------------
    // 1 = None (shouldn't be called here)
    // 2 = Flashlight
    // 3 = Orientation Lock
    // 4 = Airplane Mode
    // 5 = Wi-Fi
    // 6 = Bluetooth
    // 7 = Cellular Data
    // 8 = Low Power Mode
    if (switchAction == 2) {
        SBUIFlashlightController *flashlightController = [%c(SBUIFlashlightController) sharedInstance];
        [flashlightController setLevel:(pos == 0) ? 0 : 4];
    } else if (switchAction == 3) {
        SBOrientationLockManager *olockManager = [%c(SBOrientationLockManager) sharedInstance];
        if (pos == 0) {
            [olockManager unlock];
        } else {
            [olockManager lock];
        }
    } else if (switchAction == 4) {
        RadiosPreferences *radiosPrefs = [[%c(RadiosPreferences) alloc] init];
        [radiosPrefs setAirplaneMode:(pos == 0) ? NO : YES];
    } else if (switchAction == 5) {
        SBWiFiManager *wifiManager = [%c(SBWiFiManager) sharedInstance];
        [wifiManager setWiFiEnabled:(pos == 0) ? NO : YES];
    } else if (switchAction == 6) {
        BluetoothManager *btManager = [%c(BluetoothManager) sharedInstance];
        [btManager setEnabled:(pos == 0) ? NO : YES];
        [btManager setPowered:(pos == 0) ? NO : YES];
    } else if (switchAction == 7) {
        SBWiFiManager *wifiManager = [%c(SBWiFiManager) sharedInstance];
        [wifiManager setMobileDataEnabled:(pos == 0) ? NO : YES];
    } else if (switchAction == 8) {
        _PMLowPowerMode *lpm = [%c(_PMLowPowerMode) sharedInstance];
        [lpm setPowerMode:pos fromSource:@"SpringBoard"];
    } else {
        NSLog(@"[Ding] what?");
    }

    if (hapticFeedback) {
        UIImpactFeedbackGenerator *feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleMedium)];
        [feedback prepare];
        [feedback impactOccurred];
    }
}

%group HookGroup
%hook SBRingerControl
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

%hook SBRingerHUDViewController
- (void)viewWillAppear:(BOOL)arg1 {
    %orig(NO);
}

- (void)viewDidLoad {}

- (void)loadView {}

- (BOOL)isPresented {
    return NO;
}
%end

%hook SpringBoard
- (void)_updateRingerState:(int)arg1 withVisuals:(BOOL)arg2 updatePreferenceRegister:(BOOL)arg3 {
    NSLog(@"[Ding] _updateRingerState : %d", arg1);
    if (switchAction != 0) {
        state = (arg1 == 0) ? 1 : 0;
        ringerAction(state);
    }

    %orig;
}
%end
%end

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

%ctor {
    NSLog(@"Ding started!");
    NSLog(@"[Ding] Root path: %s", THEOS_PACKAGE_INSTALL_PREFIX);
    preferences = [[HBPreferences alloc] initWithIdentifier:@"me.nebula.ding.prefs"];
    [preferences registerBool:&isEnabled default:NO forKey:@"isEnabled"];
    [preferences registerInteger:&mode default:1 forKey:@"mode"];
    [preferences registerBool:&alwaysRingtone default:NO forKey:@"alwaysRingtone"];
    [preferences registerBool:&hapticFeedback default:YES forKey:@"hapticFeedback"];
    [preferences registerInteger:&switchAction default:1 forKey:@"switchAction"];

    if (isEnabled) {
        %init(HookGroup);
        
        if (alwaysRingtone) {
            %init(CallGroup);
        }
    }
}
