//
//  MealAuthenticationService.m
//  MealTracker
//
//  Created by William Hindenburg on 2/11/15.
//
//

#import "RestKit.h"
#import "AuthenticationService.h"
#import "User.h"
#import "ServiceClient.h"

@interface AuthenticationService()
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, assign) BOOL loggingIn;
@end

@implementation AuthenticationService
- (void)registerUser:(User *)user withSuccessBlock:(void (^)(User *user))successBlock andError:(void (^)(NSError *error))errorBlock {
    ServiceClient *serviceClient = [ServiceClient new];
    [serviceClient postObject:user andService:self withSuccessBlock:^(RKMappingResult *result) {
        successBlock(result.firstObject);
    } andError:^(NSError *error) {
        errorBlock(error);
    }];
}

- (void)loginUser:(User *)user withSuccessBlock:(void (^)(User *user))successBlock andError:(void (^)(NSError *error))errorBlock {
    self.params = @{@"username":user.username, @"password":user.password};
    self.loggingIn = YES;
    ServiceClient *serviceClient = [ServiceClient new];
    [serviceClient getForService:self withSuccess:^(RKMappingResult *result) {
        successBlock(result.firstObject);
    } andError:^(NSError *error) {
        errorBlock(error);
    }];
}

- (NSString *)serviceURL {
    if (self.loggingIn ) {
        return @"/1/login";
    } else {
        return @"/1/users";
    }
    
}

- (NSString *)rootKeyPath {
    return nil;
}

- (NSString *)rootRequestKeyPath {
    return nil;
}

- (NSDictionary *)parameters {
    return self.params;
}

- (RKObjectMapping *)mappingProvider {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[User class]];
    [mapping addAttributeMappingsFromDictionary:@{@"objectId":@"objectId"}];
    [mapping addAttributeMappingsFromDictionary:@{@"sessionToken":@"sessionToken"}];
    [mapping addAttributeMappingsFromDictionary:@{@"username":@"username"}];
    [mapping addAttributeMappingsFromDictionary:@{@"pointsPerWeek":@"pointsPerWeek"}];
    return mapping;
}

- (RKObjectMapping *)serializedMappingProvider {
    RKObjectMapping *seriallMapping = [RKObjectMapping mappingForClass:[User class]];
    [seriallMapping addAttributeMappingsFromDictionary:@{@"username":@"username"}];
    [seriallMapping addAttributeMappingsFromDictionary:@{@"password":@"password"}];
    
    return seriallMapping;
}
@end
