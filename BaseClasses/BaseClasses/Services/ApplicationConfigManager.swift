//
//  ApplicationConfigManager.swift
//  BaseClasses
//
//  Created by William Hindenburg on 7/19/15.
//  Copyright © 2015 William Hindenburg. All rights reserved.
//

import Foundation

@objc public class ApplicationConfigManager: NSObject {
    public static let sharedManager = ApplicationConfigManager()
    private var config: Config?
    private var timer = NSTimer()
    
    public func isInMaintenanceMode() -> Bool {
        if let isOn = maintenanceModeDictionary()["isOn"] as? NSNumber {
            return isOn.boolValue
        } else {
            return false
        }
        
    }
    
    public func maintenanceModeMessage() -> String {
        return maintenanceModeDictionary()["message"] as! String
    }
    
    public func shouldForceUpgrade() -> Bool {
        if let shouldForceUpgrade = self.forceUpgradeDictionary()?["forceUpgrade"] as? NSNumber {
            return shouldForceUpgrade.boolValue
        } else {
            return false
        }
        
        
    }
    
    public func forceUpgradeMessage() -> String {
        return forceUpgradeDictionary()?["forceUpgradeMessage"] as? String ?? ""
    }
    
    public func forceUpgradeTitle() -> String {
        return forceUpgradeDictionary()?["forceUpgradeTitle"] as? String ?? ""
    }
    
    public func forceUpgradeURL() -> String {
        return forceUpgradeDictionary()?["forceUpgradeURL"] as? String ?? ""
    }
    
    public func fetchConfig () {
        let configService = ConfigService()
        configService.loadConfigDataWithSuccessBlock({ (newConfig) -> Void in
            self.timer.invalidate()
            self.config = newConfig
            if (self.config != nil && self.config!.configRefreshIntervalSeconds != nil) {
                let number: NSTimeInterval = self.config!.configRefreshIntervalSeconds!.doubleValue
                            self.timer = NSTimer.scheduledTimerWithTimeInterval(number, target: self, selector: "fetchConfig", userInfo: nil, repeats: false)
                
            }
            }) { (error) -> Void in
                
        }
    }
    
    private func forceUpgradeDictionary() -> [String: AnyObject]? {
        var buildDictionary = [String: AnyObject]?()
        if (NSBundle.mainBundle().infoDictionary != nil) {
            let infoDictionary = NSBundle.mainBundle().infoDictionary!
            let buildNumber = infoDictionary[kCFBundleVersionKey as String] as? String
            print(buildNumber)
            var versionNumber = infoDictionary["CFBundleShortVersionString"] as? String
            versionNumber = versionNumber?.stringByReplacingOccurrencesOfString(".", withString: "")
            print(versionNumber)
            if (self.config != nil && self.config!.forceUpgrade != nil && versionNumber != nil && buildNumber != nil) {
                let forceUpgradeDictionary = self.config!.forceUpgrade! as [String: AnyObject]
                print(forceUpgradeDictionary)
                let versionDictionary = forceUpgradeDictionary[versionNumber!] as! [String: AnyObject]
                print(versionDictionary)
                buildDictionary = versionDictionary[buildNumber!] as? [String: AnyObject]
                return buildDictionary
            } else {
                return buildDictionary
            }
        } else {
            return buildDictionary
        }
    }
    
    private func maintenanceModeDictionary() -> [NSObject: AnyObject] {
        return config?.MaintenanceMode ?? [NSObject: AnyObject]()
    }
}


