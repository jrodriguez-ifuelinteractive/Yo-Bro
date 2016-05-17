//
//  Users.m
//  Yo Bro
//
//  Created by Jesus Rodriguez on 5/11/16.
//  Copyright © 2016 com.example. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Users.h"


@implementation Users

+ (void)loginWithUsername:(NSString *)username Password:(NSString *)password onSuccess:(void(^)())success onFailure:(void (^)(NSString *error))failure
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userData = @{
                               @"username": username,
                               @"password": password,
                               @"device": [defaults objectForKey:@"bro_device_token"]
                               };
    
    NSLog(@"Token Registered: %@", [defaults objectForKey:@"bro_device_token"]);
    
    NSData *payload = [NSJSONSerialization dataWithJSONObject:userData
                                                      options:NSJSONWritingPrettyPrinted
                                                        error:nil];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://ec2-52-6-240-197.compute-1.amazonaws.com/yobro/web/loginPost"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: payload];
    
    [[session dataTaskWithRequest: request
                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                    NSLog(@"Status Code: %lu", statusCode);
                    NSLog(@"Response: %@", [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding]);

                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:&error];
                    
                    if (statusCode == 200) {

                        dispatch_async(dispatch_get_main_queue(), ^{
                            [defaults setObject:[json objectForKey:@"token"]
                                         forKey:@"bro_token"];
                            [defaults synchronize];
                            
                            success();
                            
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failure([json objectForKey:@"error"]);
                        });
                    }
                }] resume];
    
}

+ (void)registerUserWithData:(NSMutableDictionary *)userData onSuccess:(void(^)())success
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [userData setObject:[defaults objectForKey:@"bro_device_token"] forKey:@"device"];
    
    NSData *payload = [NSJSONSerialization dataWithJSONObject:userData
                                                      options:NSJSONWritingPrettyPrinted
                                                        error:nil];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://ec2-52-6-240-197.compute-1.amazonaws.com/yobro/web/registerPost"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: payload];
    
    [[session dataTaskWithRequest: request
                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                    NSLog(@"Status Code: %lu", statusCode);
                    NSLog(@"Response: %@", [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding]);
                    if (statusCode == 200) {
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:kNilOptions
                                                                               error:&error];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [defaults setObject:[json objectForKey:@"token"]
                                         forKey:@"bro_token"];
                            [defaults synchronize];
                            
                            //[NSThread sleepForTimeInterval:5.0f];
                            success();
                        });
                    }
                }] resume];
    
}

+ (void)getBrosForUserByToken:(NSString *)token onSuccess:(void (^)(NSDictionary *items))success
{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://ec2-52-6-240-197.compute-1.amazonaws.com/yobro/web/bros"];
    [[session dataTaskWithURL:url
            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                if (statusCode == 200) {
                    NSDictionary *_items = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:kNilOptions
                                                                            error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Main thread
                        //[self assignItems: items];
                        success(_items);
                    });
                }
            }] resume];
    
}

+ (void)sendBroTo:(NSString *)username successBlock:(void (^)())success failureBlock:(void (^)())failure
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"bro_token"];
    
    NSString *payload = [NSString stringWithFormat:@"user=%@&msg=%@&token=%@", username, @"Bro!", token];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://ec2-52-6-240-197.compute-1.amazonaws.com/yobro/web/bro"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [payload dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    [[session dataTaskWithRequest: request
                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                    NSLog(@"Status Code: %lu", statusCode);
                    NSLog(@"Response: %@", [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding]);
                    if (statusCode == 200) {                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            success();
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failure();
                        });
                    }
                }] resume];
    
}

@end
