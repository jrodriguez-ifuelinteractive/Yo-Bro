//
//  AppDelegate.m
//  Yo Bro
//
//  Created by Jesus Rodriguez on 5/7/16.
//  Copyright © 2016 com.example. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "Users.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self registerObservers];
    
    /* Register application for notifications */
    
    // Register the supported interaction types.
    UIUserNotificationType types = (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
    NSSet *categories = [NSSet setWithObjects:[self createNotification], nil];
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories: categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    // Register for remote notifications.
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    /* Setting up for Authentication */
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *broToken = [defaults objectForKey:@"bro_token"];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController = nil;
    if (broToken) {
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"BrosVC"];
    } else {
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    }
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    [Fabric with:@[[Twitter class]]];
    
#if TARGET_IPHONE_SIMULATOR
    [defaults setObject:@"FAKE_TOKEN_12345" forKey:@"bro_device_token"];
    [defaults synchronize];
#endif
    
    return YES;
}

- (void)registerObservers
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [center addObserverForName:@"OMPNotification" object:nil
                         queue:mainQueue
                    usingBlock:^(NSNotification *note) {
                        [Users sendBroTo:[note.userInfo objectForKey:@"username"] successBlock:nil failureBlock:nil];
                    }];
}

- (UIUserNotificationCategory *)createNotification
{
    UIMutableUserNotificationAction *acceptAction =
    [[UIMutableUserNotificationAction alloc] init];
    
    // The identifier that you use internally to handle the action.
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    
    // The localized title of the action button.
    acceptAction.title = @"Bro!";
    
    // Specifies whether the app must be in the foreground to perform the action.
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    
    // Destructive actions are highlighted appropriately to indicate their nature.
    acceptAction.destructive = NO;
    
    // Indicates whether user authentication is required to perform the action.
    acceptAction.authenticationRequired = NO;
    
    // First create the category
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    // Identifier to include in your push payload and local notification
    inviteCategory.identifier = @"BRO_BACK_CATEGORY";
    
    // Set the actions to display in the default context
    [inviteCategory setActions:@[acceptAction]
                    forContext:UIUserNotificationActionContextDefault];
    
    // Set the actions to display in a minimal context
    [inviteCategory setActions:@[acceptAction]
                    forContext:UIUserNotificationActionContextMinimal];
    
    return inviteCategory;
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    
    if ([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OMPNotification" object:self userInfo:userInfo];
    }
    
    completionHandler();
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"bro_device_token"];
    [defaults synchronize];
    
    NSLog(@"Token: %@", token);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OMPNotificationAlert" object:self userInfo:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
