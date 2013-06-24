//
//  AppDelegate.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/23/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // ---------------------------------------------------
    // Set up RestKit
    // ---------------------------------------------------
#warning TESTING API ENDPOINT
    [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://reeder.doejoapp.com/api/"]];    // development (staging) api endpoint
    
    
    
    
    //[self attemptTestLogin];
    
    NSLog(@"username: %@",[[User currentUser] name]);
    NSLog(@"api_token: %@",[[User currentUser] apiToken]);
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Testing

- (void)attemptTestLogin {
    
    //[User loginWithName:@"pkh" emailAddress:@"patrick@doejo.com" password:@"password" andDelegate:nil];   
    //[User authenticateWithEmail:@"patrick@doejo.com" andPassword:@"password" withDelegate:nil];
}

@end
