//
//  Users.h
//  Yo Bro
//
//  Created by Jesus Rodriguez on 5/11/16.
//  Copyright © 2016 com.example. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Users : NSObject

+ (void)loginWithUsername:(NSString *)username Password:(NSString *)password onSuccess:(void(^)())success onFailure:(void(^)(NSString *error))failure;
+ (void)registerUserWithData:(NSDictionary *)userData onSuccess:(void(^)())success;
+ (void)getBrosForUserByToken:(NSString *)token onSuccess:(void (^)(NSDictionary *items))success;
+ (void)sendBroTo:(NSString *)username successBlock:(void(^)())success failureBlock:(void(^)())failure;

@end
