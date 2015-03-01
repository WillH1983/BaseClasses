//
//  ApplicationConfigManager.m
//  Life
//
//  Created by William Hindenburg on 1/3/15.
//  Copyright (c) 2015 William Hindenburg. All rights reserved.
//

#import "ApplicationConfigManager.h"
#import "ConfigService.h"

@interface ApplicationConfigManager()
@property (strong, nonatomic) Config *config;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation ApplicationConfigManager

+ (instancetype)sharedManager {
    static ApplicationConfigManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] initPrivate];
    });
    return sharedManager;
}

- (id)initPrivate {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)fetchConfig {
    ConfigService *configService = [ConfigService new];
    [configService loadConfigDataWithSuccessBlock:^(Config *config) {
        [self.timer invalidate];
        NSNumber *timeInterval = config.configRefreshIntervalSeconds;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:[timeInterval integerValue] target:self selector:@selector(fetchConfig) userInfo:nil repeats:NO];
        self.config = config;
    } andError:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (BOOL)isInMaintenanceMode {
    NSNumber *isOnNumber = [[self maintenanceModeDictionary] objectForKey:@"isOn"];
    BOOL isOn = [isOnNumber boolValue];
    return isOn;
}

- (NSString *)maintenanceModeMessage {
    NSString *maintenanceModeString = [[self maintenanceModeDictionary] objectForKey:@"message"];
    return maintenanceModeString;
}

- (BOOL)shouldForceUpgrade {
    NSDictionary *forceUpgradeDictionary = [self forceUpgradeDictionary];
    NSNumber *shouldForceUpgrade = [forceUpgradeDictionary valueForKey:@"forceUpgrade"];
    return [shouldForceUpgrade boolValue];
}

- (NSString *)forceUpgradeMessage {
    NSDictionary *forceUpgradeDictionary = [self forceUpgradeDictionary];
    return [forceUpgradeDictionary valueForKey:@"forceUpgradeMessage"];
}

- (NSString *)forceUpgradeTitle {
    NSDictionary *forceUpgradeDictionary = [self forceUpgradeDictionary];
    return [forceUpgradeDictionary valueForKey:@"forceUpgradeTitle"];
}

- (NSString *)forceUpgradeURL {
    NSDictionary *forceUpgradeDictionary = [self forceUpgradeDictionary];
    return [forceUpgradeDictionary valueForKey:@"forceUpgradeURL"];
}

- (NSDictionary *)forceUpgradeDictionary {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *buildNumber = [infoDictionary objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *versionNumber = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSDictionary *forceUpgradeDictionary = [self topLevelForceUpgradeDictionary];
    NSDictionary *versionDictionary = [forceUpgradeDictionary objectForKey:versionNumber];
    NSDictionary *buildDictionary = [versionDictionary objectForKey:buildNumber];
    return buildDictionary;
}

- (NSDictionary *)maintenanceModeDictionary {
    return self.config.MaintenanceMode;
}

- (NSDictionary *)topLevelForceUpgradeDictionary {
    return self.config.forceUpgrade;
}

@end
