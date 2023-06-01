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

@interface SBOrientationLockManager : NSObject
+ (id)sharedInstance;
- (void)lock;
- (void)unlock;
@end
