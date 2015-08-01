//
//  ConfigService.m
//  Life
//
//  Created by William Hindenburg on 1/8/15.
//  Copyright (c) 2015 William Hindenburg. All rights reserved.
//

#import <BaseClasses/BaseClasses-Swift.h>
#import "ConfigService.h"
#import "Config.h"
#import "RestKitMapping.h"

@implementation ConfigService

- (void)loadConfigDataWithSuccessBlock:(void (^ __nullable)(Config * __nonnull data))successBlock andError:(void (^ __nullable)(NSError * __nonnull error))errorBlock {
    ServiceClient *serviceClient = [ServiceClient new];
    [serviceClient getForService:self withSuccess:^(RKMappingResult *result) {
        Config *config;
        NSArray *data = result.array;
        if ([data.firstObject isKindOfClass:[Config class]]) {
            config = data.firstObject;
        }
        
        if (successBlock) successBlock(config);
    } andError:^(NSError *error) {
        if (errorBlock) errorBlock(error);
    }];
}

- (NSString *)serviceURL {
    return @"/1/config";
}

- (NSString *)baseURL {
    return @"https://api.parse.com";
}

- (NSString *)rootKeyPath {
    return @"params";
}

- (RKObjectMapping *)mappingProvider {
    RKObjectMapping *mapping = [[RKObjectMapping alloc] initWithClass:[Config class]];
    [mapping addAttributeMappingsFromDictionary:@{@"MaintenanceMode": @"MaintenanceMode"}];
    [mapping addAttributeMappingsFromDictionary:@{@"configRefreshIntervalSeconds": @"configRefreshIntervalSeconds"}];
    [mapping addAttributeMappingsFromDictionary:@{@"forceUpgrade": @"forceUpgrade"}];
    return mapping;
}

@end
