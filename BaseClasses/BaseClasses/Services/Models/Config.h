//
//  Config.h
//  Life
//
//  Created by William Hindenburg on 1/8/15.
//  Copyright (c) 2015 William Hindenburg. All rights reserved.
//

#import "BaseModel.h"

@interface Config : BaseModel
@property (strong, nonatomic, nullable) NSDictionary *MaintenanceMode;
@property (strong, nonatomic, nullable) NSNumber *configRefreshIntervalSeconds;

//TODO: This should be an integer
@property (strong, nonatomic, nullable) NSDictionary *forceUpgrade;
@end
