//
//  ServiceClient.swift
//  BaseClasses
//
//  Created by William Hindenburg on 7/31/15.
//  Copyright © 2015 William Hindenburg. All rights reserved.
//

import UIKit
import RestKit

@objc public class ServiceClient: NSObject, Service {
    let ServiceErrorDomain = "com.Services.BaseClasses"
    
    public func postObject(object:AnyObject, andService:Service, withSuccessBlock:(RKMappingResult -> Void), andError:(NSError -> Void)) {
        self.checkForErrorCodesWithSuccess({ () -> Void in
            let serviceURL = andService.serviceURL?()
            let baseURL = andService.baseURL?()
            if (serviceURL != nil && baseURL != nil) {
                let objectManager = self.objectManagerForService(andService)
                objectManager.postObject(object, path: serviceURL, parameters: nil, success: { (operation, mappingResult) -> Void in
                    withSuccessBlock(mappingResult)
                }, failure: { (operation, error) -> Void in
                    andError(error)
                })
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
                let objectManager = self.objectManagerForService(andService)
                objectManager.putObject(object, path: serviceURL, parameters: nil, success: { (operation, mappingResult) -> Void in
                    withSuccessBlock(mappingResult)
                }, failure: { (operation, error) -> Void in
                    andError(error)
                })
            }
            
            }) { (error) -> Void in
                andError(error)
            }
    }
    
    public func getForService(service: Service, withSuccess:(RKMappingResult -> Void), andError:(NSError -> Void)) {
        self.checkForErrorCodesWithSuccess({ () -> Void in
            let serviceURL = service.serviceURL?()
            let baseURL = service.baseURL?()
            if (serviceURL != nil && baseURL != nil) {
                let objectManager = self.objectManagerForService(service)
                objectManager.getObjectsAtPath(serviceURL, parameters: service.parameters!(), success: { (operation, mappingResult) -> Void in
                    withSuccess(mappingResult)
                }, failure: { (operation, error) -> Void in
                    andError(error)
                })
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
                self.deleteObjects([object], andService: andService, withSuccessBlock: withSuccessBlock, andError: andError)
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
                let objectManager = self.objectManagerForService(andService)
                objectManager.deleteObject(objects, path: serviceURL, parameters: andService.parameters!(), success: { (operation, mappingResult) -> Void in
                    withSuccessBlock(mappingResult)
                }, failure: { (operation, error) -> Void in
                    andError(error)
                })
            }
        }) { (error) -> Void in
            andError(error)
        }
    }
    
    public func performMappingOnObject(object:AnyObject, withService:Service, withSuccessBlock:(RKMappingResult -> Void), andError:(NSError -> Void)) {
        self.checkForErrorCodesWithSuccess({ () -> Void in
            let serviceURL = withService.serviceURL?()
            let baseURL = withService.baseURL?()
            let rootKeyPath = withService.rootKeyPath?()
            if (serviceURL != nil && baseURL != nil && rootKeyPath != nil) {
                let mapper = RKMapperOperation(representation: object, mappingsDictionary: [rootKeyPath!: withService.mappingProvider!()])
                do {
                    try mapper.execute()
                    withSuccessBlock(mapper.mappingResult)
                } catch {
                    andError(mapper.error)
                }
            }
            
        }) { (error) -> Void in
                
        }
    }
    
    private func objectManagerForService(service:Service) -> RKObjectManager {
        let objectManager = RKObjectManager(baseURL: NSURL(string: service.baseURL!()))
        objectManager.setAcceptHeaderWithMIMEType("*/*")
        objectManager.requestSerializationMIMEType = RKMIMETypeJSON
        let responseDescriptor = RKResponseDescriptor(mapping: self.getMappingForService(service), method: RKRequestMethod.GET, pathPattern: nil, keyPath: service.rootKeyPath!(), statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful))
        objectManager.addResponseDescriptor(responseDescriptor)
        
        let requestDescriptor = RKRequestDescriptor(mapping: self.getSerializationMappingForService(service), objectClass: self.getSerializationObjectClassForService(service), rootKeyPath: service.rootRequestKeyPath?(), method: RKRequestMethod.POST)
        let requestDescriptor2 = RKRequestDescriptor(mapping: self.getSerializationMappingForService(service), objectClass: self.getSerializationObjectClassForService(service), rootKeyPath: service.rootRequestKeyPath?(), method: RKRequestMethod.PUT)
        let requestDescriptor3 = RKRequestDescriptor(mapping: self.getSerializationMappingForService(service), objectClass: self.getSerializationObjectClassForService(service), rootKeyPath: service.rootRequestKeyPath?(), method: RKRequestMethod.DELETE)
        objectManager.addRequestDescriptorsFromArray([requestDescriptor, requestDescriptor2, requestDescriptor3])
        
        if let userSessionToken = User.persistentUserObject().sessionToken {
            objectManager.HTTPClient.setDefaultHeader("X-Parse-Session-Token", value: userSessionToken)
        }
        
        if let parseApplicationId = NSBundle.mainBundle().infoDictionary?["ParseApplicationId"] as? String {
            objectManager.HTTPClient.setDefaultHeader("X-Parse-Application-Id", value: parseApplicationId)
        } else {
            assertionFailure("Provide a Parse Application Id in the info PLIST file")
        }
        
        if let parseRestAPIKey = NSBundle.mainBundle().infoDictionary?["ParseRestAPIKey"] as? String {
            objectManager.HTTPClient.setDefaultHeader("X-Parse-REST-API-Key", value: parseRestAPIKey)
        } else {
            assertionFailure("Provide a Parse Rest API key in the info PLIST file")
        }
        
        //        RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
        
        return objectManager;
    }
    
    private func getSerializationObjectClassForService(service: Service) -> AnyClass {
        
        if let object = service.serializedMappingProvider?() {
            return object.objectClass!
        } else {
            return object_getClass(NSMutableDictionary)
        }
    }
    
    private func getSerializationMappingForService(service: Service) -> RKObjectMapping {
        var serializationMapping: RKObjectMapping
        if service.serializedMappingProvider?() != nil {
            serializationMapping = service.serializedMappingProvider!().inverseMapping()
            serializationMapping.setNilForMissingRelationships = true
        } else {
            serializationMapping = RKObjectMapping(forClass: NSMutableDictionary.self)
        }
        return serializationMapping
    }
    
    private func getMappingForService(service:Service) -> RKObjectMapping {
        var mapping: RKObjectMapping
        if service.mappingProvider?() != nil {
            mapping = service.mappingProvider!()
            mapping.setNilForMissingRelationships = true
        } else {
            mapping = RKObjectMapping(forClass: NSMutableDictionary.self)
        }
        return mapping
    }
    
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
