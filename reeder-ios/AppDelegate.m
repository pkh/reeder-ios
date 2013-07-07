//
//  AppDelegate.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/23/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "AppDelegate.h"

#import <FlatUIKit/UINavigationBar+FlatUI.h>
#import <FlatUIKit/UIColor+FlatUI.h>
#import "Utils.h"
#import "User.h"
#import "LoginViewController.h"
#import "Feed.h"
#import "Post.h"
#import "SliderMenuViewController.h"
#import "PostsViewController.h"

#import "JASidePanelController.h"



@implementation AppDelegate

/*
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
*/
@synthesize viewController = _viewController;


+ (NSInteger)OSVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //self.window.backgroundColor = kNAV_BAR_COLOR;
    self.window.backgroundColor = [UIColor whiteColor];
    // Override point for customization after application launch.
    
    /*
    // CORE DATA TESTING CODE
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newFeed = [NSEntityDescription insertNewObjectForEntityForName:@"Feed" inManagedObjectContext:context];
    [newFeed setValue:@"Soccernet" forKey:@"title"];
    [newFeed setValue:@"http://espnfc.com/blog/rss/_/name/juventus" forKey:@"rssURL"];
    
    NSManagedObject *post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:context];
    [post setValue:@"Post Title" forKey:@"title"];
    [post setValue:@"My Post Content!" forKey:@"content"];
    
    [newFeed setValue:[NSSet setWithObject:post] forKey:@"posts"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"save error! %@",[error localizedDescription]);
    }
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Feed" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *feed in fetchedObjects) {
        NSLog(@"feed title: %@",[feed valueForKey:@"title"]);
        NSLog(@"rssURL: %@",[feed valueForKey:@"rssURL"]);
        NSSet *allPosts = [feed valueForKey:@"posts"];
        NSManagedObject *singlePost = [allPosts anyObject];
        NSLog(@"post title: %@",[singlePost valueForKey:@"title"]);
        
    }
    */
    
    
    
    // ---------------------------------------------------
    // Set up RestKit
    // ---------------------------------------------------
#warning TESTING API ENDPOINT
    [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://reeder.doejoapp.com/api/"]];    // development (staging) api endpoint
    
    
    
    
    
    if ([[User currentUser] isLoggedIn]) {
        NSLog(@"user IS logged in");
        
        NSLog(@"user id: %@",[[[User currentUser] userID] stringValue]);
        NSLog(@"email: %@",[[User currentUser] email]);
        NSLog(@"api_token: %@",[[User currentUser] apiToken]);
        
        
        [self loadRootViewController];
        
    } else {
        NSLog(@"user is NOT logged in");
        
        LoginViewController *lvc = [[LoginViewController alloc] init];
        self.window.rootViewController = lvc;
        
    }
    

    
    
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

/*
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ReederDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ReederData.sqlite"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CoreDataTutorial2" ofType:@"sqlite"]];
        NSError *err = nil;
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
            NSLog(@"Oops, couldn't copy preloaded data");
        }
    }

    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
//         Replace this implementation with code to handle the error appropriately.
//         
//         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//         
//         Typical reasons for an error here include:
//         * The persistent store is not accessible;
//         * The schema for the persistent store is incompatible with current managed object model.
//         Check the error message to determine what the actual problem was.
//         
//         
//         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
//         
//         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
//         * Simply deleting the existing store:
//         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
//         
//         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
//         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
//         
//         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
 
         
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
*/


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



#pragma mark - Custom Methods

- (void)loadRootViewController {
    
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.leftPanel = [[SliderMenuViewController alloc] init];
    
    PostsViewController *pvc = [[PostsViewController alloc] init];
    pvc.postsViewControllerType = RecentPostsVCType;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pvc];
    //[navController.navigationBar configureFlatNavigationBarWithColor:kNAV_BAR_COLOR];
    self.viewController.centerPanel = navController;
    
    self.viewController.recognizesPanGesture = NO;

    self.window.rootViewController = self.viewController;
    
    
    
    
    
    
    /*
    PostsViewController *pvc = [[PostsViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pvc];
    [navController.navigationBar configureFlatNavigationBarWithColor:kNAV_BAR_COLOR];
    self.window.rootViewController = navController;
    */
    
    
    //self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[PostsViewController alloc] init]];
    
    /*
    
    RootViewController *rvc = [[RootViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rvc];
    [navController.navigationBar configureFlatNavigationBarWithColor:kNAV_BAR_COLOR];

    self.window.rootViewController = navController;
    */
}



@end
