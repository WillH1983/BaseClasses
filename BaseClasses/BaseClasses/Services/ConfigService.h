//
//  ConfigService.h
//  Life
//
//  Created by William Hindenburg on 1/8/15.
//  Copyright (c) 2015 William Hindenburg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "BaseService.h"

@interface ConfigService : BaseService
- (void)loadConfigDataWithSuccessBlock:(void (^ __nullable)(Config * __nonnull data))successBlock andError:(void (^ __nullable)(NSError * __nonnull error))errorBlock;
@end
