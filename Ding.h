#ifndef DING_H
#define DING_H

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

@interface SBRingerPillView : UIView
@property (nonatomic,retain) UIView * materialView;
@property (nonatomic,retain) UIView * silentModeLabel;
@property (nonatomic,retain) UIView * ringerLabel;
@property (nonatomic,retain) UIView * onLabel;
@property (nonatomic,retain) UIView * offLabel;
@property (nonatomic,retain) UIView * slider;
@property (nonatomic,retain) UIColor * glyphTintColor;
@property (nonatomic,copy) NSArray * glyphTintBackgroundLayers;
@property (nonatomic,copy) NSArray * glyphTintShapeLayers;
@property (assign,nonatomic) unsigned long long state;  
@end

@interface SBWiFiManager : NSObject
+ (id)sharedInstance;
- (void)setWiFiEnabled:(BOOL)enabled;
- (void)setMobileDataEnabled:(BOOL)enabled;
@end

@interface BluetoothManager : NSObject
+ (id)sharedInstance;
- (void)setEnabled:(BOOL)enabled;
- (void)setPowered:(BOOL)powered;
@end

@interface SBUIFlashlightController : NSObject
+ (id)sharedInstance;
- (void)setLevel:(unsigned long long)arg1;
@end

@interface RadiosPreferences : NSObject
- (id)init;
- (void)setAirplaneMode:(BOOL)arg1;
@end

@interface _PMLowPowerMode : NSObject
+ (id)sharedInstance;
- (NSInteger)getPowerMode;
- (void)setPowerMode:(NSInteger)arg0 fromSource:(id)arg1;
@end

// LPM for iOS 13+
@interface _CDBatterySaver
- (id)batterySaver;
- (BOOL)setPowerMode:(long long)arg1 error:(id *)arg2;
@end

@interface SBOrientationLockManager : NSObject
+ (id)sharedInstance;
- (void)lock;
- (void)unlock;
@end

@interface SBRingerControl
+ (id)sharedInstance;
- (BOOL)isRingerMuted;
- (void)setRingerMuted:(BOOL)arg1;
@end

#endif