//
//  Service.swift
//  BaseClasses
//
//  Created by William Hindenburg on 7/31/15.
//  Copyright © 2015 William Hindenburg. All rights reserved.
//

import RestKit

@objc public protocol Service: NSObjectProtocol {
    
    /**
        This methoded is called to get the URL path.  This URL is appended to the base URL.
    
            - (NSString *)serviceURL {
                return @"/1/login";
            }
        - Returns: The service URL that is to be called to retrieve the data

    */
    optional func serviceURL() -> String
    
    /**
        This methoded is called to retrieve the mapping of the response data
    
            - (RKObjectMapping *)mappingProvider {
                RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[User class]];
                [mapping addAttributeMappingsFromDictionary:@{@"objectId":@"objectId"}];
                [mapping addAttributeMappingsFromDictionary:@{@"sessionToken":@"sessionToken"}];
                [mapping addAttributeMappingsFromDictionary:@{@"username":@"username"}];
                [mapping addAttributeMappingsFromDictionary:@{@"pointsPerWeek":@"pointsPerWeek"}];
                return mapping;
            }
        - Returns: The mapping that will be used to map the service response
    */
    optional func mappingProvider() -> RKObjectMapping
    
    /**
        This methoded is called to retrieve the mapping of the data object that is being posted
    
            - (RKObjectMapping *)serializedMappingProvider {
                RKObjectMapping *seriallMapping = [RKObjectMapping mappingForClass:[User class]];
                [seriallMapping addAttributeMappingsFromDictionary:@{@"username":@"username"}];
                [seriallMapping addAttributeMappingsFromDictionary:@{@"password":@"password"}];
                
                return seriallMapping;
            }
        - Returns: The mapping that will be used to map the object being posted
    */
    @objc optional func serializedMappingProvider() -> RKObjectMapping
    
    /**
        This methoded is called to get base URL of the service.
        
            - (NSString *)baseURL {
                return @"https://api.parse.com";
            }
        - Returns: The base URL that is to be called to retrieve the data
    */
    optional func baseURL() -> String
    
    /**
        This methoded is used to determine where the mapping of the response JSON starts.
        
        For example, consider the following JSON:
        
            {
                "users": {
                    "blake": {
                        "id": 1234,
                        "email": "blake@restkit.org"
                    },
                    "rachit": {
                        "id": 5678,
                        "email": "rachit@restkit.org"
                    }
                }
            }
    
        In order to map the users, the rootKeyPath would be "users".
        
    
            - (NSString *)rootKeyPath {
                return @"users";
            }
        - Returns The path where the mapping starts for the response data
    */
    optional func rootKeyPath() -> String?
    
    /**
    This method is used to determine where the mapping of the post Object starts in relation to the JSON.
    
    For example, consider the following JSON:
    
        {
            "users": {
                "blake": {
                    "id": 1234,
                    "email": "blake@restkit.org"
                },
                "rachit": {
                    "id": 5678,
                    "email": "rachit@restkit.org"
                }
            }
        }
    
    In order to post the users, the rootRequestKeyPath would be "users".
    
        - (NSString *)rootRequestKeyPath {
            return @"users";
        }
    
    - Returns: The base URL that is to be called to retrieve the data
    */
    optional func rootRequestKeyPath() -> String?
    
    /**
        This method is used to determine where the mapping of the post Object starts in relation to the JSON.
        
        For example, consider this URL: https://api.parse.com/1/login?username=cooldude6&password=password123. The dictionary to return will look like this: @{@"username":@"cooldude6", @"password":@"password123"};
        
            - (NSDictionary *)parameters {
                return @{@"username":@"cooldude6", @"password":@"password123"};
            }
        
        - Returns: The parameters to be encoded and appended as the query string for the request URL.
    */
    optional func parameters() -> [NSObject : AnyObject]?
}

