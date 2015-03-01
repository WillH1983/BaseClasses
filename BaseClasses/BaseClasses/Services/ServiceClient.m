//
//  ServiceClient.m
//  Life
//
//  Created by William Hindenburg on 1/4/15.
//  Copyright (c) 2015 William Hindenburg. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "ServiceClient.h"
#import "User.h"
#import "ApplicationConfigManager.h"
#import "ServiceErrors.h"

NSString* const ServiceErrorDomain = @"com.Services.BaseClasses";

@implementation ServiceClient

- (void)postObject:(id)object andService:(id<Service>)lifeService withSuccessBlock:(void (^)(RKMappingResult *result))successBlock andError:(void (^)(NSError *error))errorBlock {
    [self checkForLifeErrorCodesWithSuccess:^{
        if ([lifeService respondsToSelector:@selector(serviceURL)] &&
            [lifeService respondsToSelector:@selector(baseURL)]) {
            RKObjectManager *objectManager = [self objectManagerForService:lifeService];
            [objectManager postObject:object path:[lifeService serviceURL] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                if (successBlock) successBlock(mappingResult);
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                if (errorBlock) errorBlock(error);
            }];
        }
    } andError:^(NSError *error) {
        if (errorBlock) errorBlock(error);
    }];
    

}

- (void)putObject:(id)object andService:(id<Service>)lifeService withSuccessBlock:(void (^)(RKMappingResult *result))successBlock andError:(void (^)(NSError *error))errorBlock {
    [self checkForLifeErrorCodesWithSuccess:^{
        if ([lifeService respondsToSelector:@selector(serviceURL)] &&
            [lifeService respondsToSelector:@selector(baseURL)]) {
            RKObjectManager *objectManager = [self objectManagerForService:lifeService];
            [objectManager putObject:object path:[lifeService serviceURL] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                if (successBlock) successBlock(mappingResult);
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                if (errorBlock) errorBlock(error);
            }];
        }
    } andError:^(NSError *error) {
        if (errorBlock) errorBlock(error);
    }];
    
}

- (RKObjectManager *)objectManagerForService:(id<Service>)service {
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:[service baseURL]]];
    [objectManager setAcceptHeaderWithMIMEType:@"*/*"];
    [objectManager setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[self getMappingForService:service] method:RKRequestMethodGET pathPattern:nil keyPath:[service rootKeyPath] statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    RKRequestDescriptor *request = [RKRequestDescriptor requestDescriptorWithMapping:[self getSerializationMappingForService:service] objectClass:[self getSerializationObjectClassForService:service] rootKeyPath:[service rootRequestKeyPath] method:RKRequestMethodPOST|RKRequestMethodPUT|RKRequestMethodDELETE];
    [objectManager addRequestDescriptor:request];
        
    User *user = [User persistentUserObject];
    if (user.sessionToken) {
        [objectManager.HTTPClient setDefaultHeader:@"X-Parse-Session-Token" value:user.sessionToken];
    }
    
    NSDictionary *informationDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *parseApplicationId = [informationDictionary valueForKey:@"ParseApplicationId"];
    NSAssert(parseApplicationId != nil, @"Provide a Parse Application Id in the info PLIST file");
    
    NSString *parseRestAPIKey = [informationDictionary valueForKey:@"ParseRestAPIKey"];
    NSAssert(parseRestAPIKey != nil, @"Provide a Parse Rest API key in the info PLIST file");
    
    [objectManager.HTTPClient setDefaultHeader:@"X-Parse-Application-Id" value:parseApplicationId];
    [objectManager.HTTPClient setDefaultHeader:@"X-Parse-REST-API-Key" value:parseRestAPIKey];
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    return objectManager;
}

- (void)getForService:(id<Service>)service withSuccess:(void (^)(RKMappingResult *result))successBlock andError:(void (^)(NSError *error))errorBlock {
    [self checkForLifeErrorCodesWithSuccess:^{
        if ([service respondsToSelector:@selector(serviceURL)] &&
            [service respondsToSelector:@selector(baseURL)]) {
            RKObjectManager *objectManager = [self objectManagerForService:service];
            
            [objectManager getObjectsAtPath:[service serviceURL] parameters:[service parameters] success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                successBlock(mappingResult);
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                errorBlock(error);
            }];
            
        }
    } andError:^(NSError *error) {
        if (errorBlock) errorBlock(error);
    }];
    
}

- (void)deleteObject:(id)object andService:(id<Service>)lifeService withSuccessBlock:(void (^)(RKMappingResult *result))successBlock andError:(void (^)(NSError *error))errorBlock {
    [self deleteObjects:@[object] andService:lifeService withSuccessBlock:successBlock andError:errorBlock];
}

- (void)deleteObjects:(NSArray *)objects andService:(id<Service>)lifeService withSuccessBlock:(void (^)(RKMappingResult *result))successBlock andError:(void (^)(NSError *error))errorBlock {
    [self checkForLifeErrorCodesWithSuccess:^{
        if ([lifeService respondsToSelector:@selector(serviceURL)] &&
            [lifeService respondsToSelector:@selector(baseURL)]) {
            RKObjectManager *objectManager = [self objectManagerForService:lifeService];
            [objectManager postObject:objects path:[lifeService serviceURL] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                if (successBlock) successBlock(mappingResult);
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                if (errorBlock) errorBlock(error);
            }];
        }
    } andError:^(NSError *error) {
        if (errorBlock) errorBlock(error);
    }];
    
}

- (Class)getSerializationObjectClassForService:(id<Service>)service {
    
    if ([service respondsToSelector:@selector(serializedMappingProvider)]) {
        return [service serializedMappingProvider].objectClass;
    }
    
    return [NSMutableDictionary class];
}

- (RKObjectMapping *)getSerializationMappingForService:(id<Service>)service {
    RKObjectMapping *serializationMapping = nil;
    
    if ([service respondsToSelector:@selector(serializedMappingProvider)]) {
        serializationMapping = [[service serializedMappingProvider] inverseMapping];
        
        if (serializationMapping) {
            [serializationMapping setSetNilForMissingRelationships:YES];
        }
    }
    if (!serializationMapping) {
        return [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    }
    return serializationMapping;
}

- (RKObjectMapping *)getMappingForService:(id<Service>)service {
    RKObjectMapping *mapping = nil;
    
    if ([service respondsToSelector:@selector(mappingProvider)]) {
        mapping = [service mappingProvider];
        
        if (mapping) {
            [mapping setSetNilForMissingRelationships:YES];
        }
    }
    if (!mapping) {
        return [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    }
    return mapping;
}

- (void)checkForLifeErrorCodesWithSuccess:(void (^)())successBlock andError:(void (^)(NSError *error))errorBlock {
    NSError *error;
    if ([[ApplicationConfigManager sharedManager] shouldForceUpgrade]) {
        NSString *upgradeMessage = [[ApplicationConfigManager sharedManager] forceUpgradeMessage];
        NSString *upgradeTitle = [[ApplicationConfigManager sharedManager] forceUpgradeTitle];
        NSString *forceUpgradeURL = [[ApplicationConfigManager sharedManager] forceUpgradeURL];
        
        NSMutableDictionary *mutableUpgradeDictionary = [NSMutableDictionary new];
        if (upgradeMessage) {
            [mutableUpgradeDictionary setObject:upgradeMessage forKey:NSLocalizedDescriptionKey];
        }
        
        if (upgradeTitle) {
            [mutableUpgradeDictionary setObject:upgradeTitle forKey:kForceUpgradeTitleKey];
        }
        
        if (forceUpgradeURL) {
            [mutableUpgradeDictionary setObject:forceUpgradeURL forKey:kForceUpgradeURL];
        }
        error = [NSError errorWithDomain:ServiceErrorDomain code:ServiceErrorForceUpgrade userInfo:mutableUpgradeDictionary];
        if (errorBlock) errorBlock(error);
    } else if ([[ApplicationConfigManager sharedManager] isInMaintenanceMode]) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [[ApplicationConfigManager sharedManager] maintenanceModeMessage],
                                   kMaintenanceModeErrorTitleKey: @"Maintenance Mode"};
        error = [NSError errorWithDomain:ServiceErrorDomain code:ServiceErrorMaintenanceMode userInfo:userInfo];
        if (errorBlock) errorBlock(error);
    } else {
        if (successBlock) successBlock();
    }
    
}

@end
