//
//  ConfigService.swift
//  BaseClasses
//
//  Created by William Hindenburg on 8/2/15.
//  Copyright © 2015 William Hindenburg. All rights reserved.
//

import UIKit
import RestKit

@objc public class ConfigService: BaseService, Service {
    public func loadConfigDataWithSuccessBlock(successBlock:Config -> Void, errorBlock:NSError -> Void) {
        ServiceClient().getForService(self, withSuccess: { (mappingResult) -> Void in
            let dataArray = mappingResult.array() as NSArray
            if let config = dataArray.firstObject as? Config {
                successBlock(config)
            } else {
                errorBlock(ServiceClient().genericErrorCode())
            }
        }) { (error) -> Void in
                
        }
    }
    
    public func serviceURL() -> String {
        return "/1/config"
    }
    
    public func rootKeyPath() -> String? {
        return "params"
    }
    
    public func mappingProvider() -> RKObjectMapping {
        let mapping = RKObjectMapping(withClass: Config.self)
        mapping.addAttributeMappingsFromDictionary(["MaintenanceMode": "MaintenanceMode"])
        mapping.addAttributeMappingsFromDictionary(["configRefreshIntervalSeconds": "configRefreshIntervalSeconds"])
        mapping.addAttributeMappingsFromDictionary(["forceUpgrade": "forceUpgrade"])
        return mapping
    }
}
