//
//  ServiceClient.swift
//  BaseClasses
//
//  Created by William Hindenburg on 7/31/15.
//  Copyright © 2015 William Hindenburg. All rights reserved.
//

import UIKit

@objc public class ServiceClient: NSObject, Service {
    let ServiceErrorDomain = "com.Services.BaseClasses"
    
    public func postObject(object:AnyObject, andService:Service, withSuccessBlock:(RKMappingResult -> Void), andError:(NSError -> Void)) {
        self.checkForErrorCodesWithSuccess({ () -> Void in
            let serviceURL = andService.serviceURL?()
            let baseURL = andService.baseURL?()
            if (serviceURL != nil && baseURL != nil) {
//                if ([lifeService respondsToSelector:@selector(serviceURL)] &&
//                [lifeService respondsToSelector:@selector(baseURL)]) {
//                    RKObjectManager *objectManager = [self objectManagerForService:lifeService];
//                    [objectManager postObject:object path:[lifeService serviceURL] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                        if (successBlock) successBlock(mappingResult);
//                        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                        if (errorBlock) errorBlock(error);
//                        }];
//                }
            }
            
        }) { (error) -> Void in
             andError(error)
        }
    }
    
    public func putObject(object:AnyObject, andService:Service, withSuccessBlock:(RKMappingResult -> Void), andError:(NSError -> Void)) {
        self.checkForErrorCodesWithSuccess({ () -> Void in
            let serviceURL = andService.serviceURL?()
            let baseURL = andService.baseURL?()
            if (serviceURL != nil && baseURL != nil) {
//                if ([lifeService respondsToSelector:@selector(serviceURL)] &&
//                [lifeService respondsToSelector:@selector(baseURL)]) {
//                    RKObjectManager *objectManager = [self objectManagerForService:lifeService];
//                    [objectManager putObject:object path:[lifeService serviceURL] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                        if (successBlock) successBlock(mappingResult);
//                        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                        if (errorBlock) errorBlock(error);
//                        }];
//                }
            }
            
            }) { (error) -> Void in
                andError(error)
            }
    }
    
    private func objectManagerForService(service:Service) -> AnyObject? {
        return nil
//        RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:[service baseURL]]];
//        [objectManager setAcceptHeaderWithMIMEType:@"*/*"];
//        [objectManager setRequestSerializationMIMEType:RKMIMETypeJSON];
//        
//        [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[self getMappingForService:service] method:RKRequestMethodGET pathPattern:nil keyPath:[service rootKeyPath] statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
//        
//        RKRequestDescriptor *request = [RKRequestDescriptor requestDescriptorWithMapping:[self getSerializationMappingForService:service] objectClass:[self getSerializationObjectClassForService:service] rootKeyPath:[service rootRequestKeyPath] method:RKRequestMethodPOST|RKRequestMethodPUT|RKRequestMethodDELETE];
//        [objectManager addRequestDescriptor:request];
//        
//        User *user = [User persistentUserObject];
//        if (user.sessionToken) {
//            [objectManager.HTTPClient setDefaultHeader:@"X-Parse-Session-Token" value:user.sessionToken];
//        }
//        
//        NSDictionary *informationDictionary = [[NSBundle mainBundle] infoDictionary];
//        NSString *parseApplicationId = [informationDictionary valueForKey:@"ParseApplicationId"];
//        NSAssert(parseApplicationId != nil, @"Provide a Parse Application Id in the info PLIST file");
//        
//        NSString *parseRestAPIKey = [informationDictionary valueForKey:@"ParseRestAPIKey"];
//        NSAssert(parseRestAPIKey != nil, @"Provide a Parse Rest API key in the info PLIST file");
//        
//        [objectManager.HTTPClient setDefaultHeader:@"X-Parse-Application-Id" value:parseApplicationId];
//        [objectManager.HTTPClient setDefaultHeader:@"X-Parse-REST-API-Key" value:parseRestAPIKey];
//        RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
//        return objectManager;
    }
    
    public func getForService(service: Service, withSuccess:(RKMappingResult -> Void), andError:(NSError -> Void)) {
        self.checkForErrorCodesWithSuccess({ () -> Void in
            let serviceURL = service.serviceURL?()
            let baseURL = service.baseURL?()
            if (serviceURL != nil && baseURL != nil) {
//                if ([service respondsToSelector:@selector(serviceURL)] &&
//                [service respondsToSelector:@selector(baseURL)]) {
//                    RKObjectManager *objectManager = [self objectManagerForService:service];
//                    
//                    [objectManager getObjectsAtPath:[service serviceURL] parameters:[service parameters] success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                        successBlock(mappingResult);
//                        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                        errorBlock(error);
//                        }];
//                    
//                }
            }
            
            }) { (error) -> Void in
                andError(error)
        }
    }
    
    public func deleteObject(object:AnyObject, andService:Service, withSuccessBlock:(RKMappingResult -> Void), andError:(NSError -> Void)) {
        
        self.checkForErrorCodesWithSuccess({ () -> Void in
            let serviceURL = andService.serviceURL?()
            let baseURL = andService.baseURL?()
            if (serviceURL != nil && baseURL != nil) {
//                [self deleteObjects:@[object] andService:lifeService withSuccessBlock:successBlock andError:errorBlock];
            }
            
            }) { (error) -> Void in
                andError(error)
        }
    }
    
    public func deleteObjects(objects:Array<AnyObject>, andService:Service, withSuccessBlock:(RKMappingResult -> Void), andError:(NSError -> Void)) {
        
        self.checkForErrorCodesWithSuccess({ () -> Void in
            let serviceURL = andService.serviceURL?()
            let baseURL = andService.baseURL?()
            if (serviceURL != nil && baseURL != nil) {
//                if ([lifeService respondsToSelector:@selector(serviceURL)] &&
//                [lifeService respondsToSelector:@selector(baseURL)]) {
//                    RKObjectManager *objectManager = [self objectManagerForService:lifeService];
//                    [objectManager postObject:objects path:[lifeService serviceURL] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                        if (successBlock) successBlock(mappingResult);
//                        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                        if (errorBlock) errorBlock(error);
//                        }];
//                }
            }
            
            }) { (error) -> Void in
                andError(error)
        }
    }
    
    public func performMappingOnObject(object:AnyObject, withService:Service, withSuccessBlock:(RKMappingResult -> Void), andError:(NSError -> Void)) {
        self.checkForErrorCodesWithSuccess({ () -> Void in
            let serviceURL = withService.serviceURL?()
            let baseURL = withService.baseURL?()
            if (serviceURL != nil && baseURL != nil) {
//                RKMapperOperation *mapper = [[[RKMapperOperation alloc] init] initWithRepresentation:object mappingsDictionary:@{[service rootKeyPath] : [service mappingProvider] }];
//                NSError *mappingError = nil;
//                [mapper execute:&mappingError];
//                if (mappingError == nil) {
//                    if (successBlock) successBlock(mapper.mappingResult);
//                } else {
//                    if (errorBlock) errorBlock(mappingError);
//                }
            }
            
            }) { (error) -> Void in
                
        }
    }
    
//    - (Class)getSerializationObjectClassForService:(id<Service>)service {
//    
//    if ([service respondsToSelector:@selector(serializedMappingProvider)]) {
//    return [service serializedMappingProvider].objectClass;
//    }
//    
//    return [NSMutableDictionary class];
//    }
    
//    - (RKObjectMapping *)getSerializationMappingForService:(id<Service>)service {
//    RKObjectMapping *serializationMapping = nil;
//    
//    if ([service respondsToSelector:@selector(serializedMappingProvider)]) {
//    serializationMapping = [[service serializedMappingProvider] inverseMapping];
//    
//    if (serializationMapping) {
//    [serializationMapping setSetNilForMissingRelationships:YES];
//    }
//    }
//    if (!serializationMapping) {
//    return [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
//    }
//    return serializationMapping;
//    }
    
//    - (RKObjectMapping *)getMappingForService:(id<Service>)service {
//    RKObjectMapping *mapping = nil;
//    
//    if ([service respondsToSelector:@selector(mappingProvider)]) {
//    mapping = [service mappingProvider];
//    
//    if (mapping) {
//    [mapping setSetNilForMissingRelationships:YES];
//    }
//    }
//    if (!mapping) {
//    return [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
//    }
//    return mapping;
//    }
    
    private func checkForErrorCodesWithSuccess(success:() -> Void, andError:(NSError -> Void)) {
        if ApplicationConfigManager.sharedManager.shouldForceUpgrade() {
            let upgradeMessage = ApplicationConfigManager.sharedManager.forceUpgradeMessage()
            let upgradeTitle = ApplicationConfigManager.sharedManager.forceUpgradeTitle()
            let forceUpgradeURL = ApplicationConfigManager.sharedManager.forceUpgradeURL()
            let mutableUpgradeDictionary = [upgradeMessage: NSLocalizedDescriptionKey, upgradeTitle: kForceUpgradeTitleKey, forceUpgradeURL: kForceUpgradeURL]
            let error = NSError(domain: ServiceErrorDomain, code: ServiceErrorCode.ForceUpgrade.rawValue, userInfo: mutableUpgradeDictionary)
            andError(error)
            
        } else if ApplicationConfigManager.sharedManager.isInMaintenanceMode() {
            let userInfo = [NSLocalizedDescriptionKey: ApplicationConfigManager.sharedManager.maintenanceModeMessage(), kMaintenanceModeErrorTitleKey: "Maintenance Mode"]
            let error = NSError(domain: ServiceErrorDomain, code: ServiceErrorCode.MaintenanceMode.rawValue, userInfo: userInfo)
            andError(error)
        } else {
            success()
        }
    }

}
