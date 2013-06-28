//
//  RootViewController.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/28/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"
#import <FlatUIKit/UINavigationBar+FlatUI.h>
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/UIFont+FlatUI.h>
#import <FlatUIKit/UIBarButtonItem+FlatUI.h>
#import "Utils.h"
#import "PostsViewController.h"
#import "LoginViewController.h" 
#import "User.h"



#define kLOGOUT_ALERTVIEW 0


@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [UIBarButtonItem configureFlatButtonsWithColor:[UIColor wetAsphaltColor]
                                  highlightedColor:[UIColor midnightBlueColor]
                                      cornerRadius:6];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
}


- (void)showMenu
{
    if (!_sideMenu) {
        RESideMenuItem *recentPostsItem = [[RESideMenuItem alloc] initWithTitle:@"Recent Posts" action:^(RESideMenu *menu, RESideMenuItem *item) {
            [menu hide];
            
//            DemoViewController *viewController = [[DemoViewController alloc] init];
//            viewController.title = item.title;
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//            [menu setRootViewController:navigationController];
            
            PostsViewController *pvc = [[PostsViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pvc];
            [navController.navigationBar configureFlatNavigationBarWithColor:kNAV_BAR_COLOR];
            [menu setRootViewController:navController];
            
        }];
        RESideMenuItem *viewByFeedItem = [[RESideMenuItem alloc] initWithTitle:@"View by Feed" action:^(RESideMenu *menu, RESideMenuItem *item) {
            [menu hide];
            
//            SecondViewController *secondViewController = [[SecondViewController alloc] init];
//            secondViewController.title = item.title;
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
//            [menu setRootViewController:navigationController];
        }];
        RESideMenuItem *bookmarkedItem = [[RESideMenuItem alloc] initWithTitle:@"Bookmarked" action:^(RESideMenu *menu, RESideMenuItem *item) {
            [menu hide];
            NSLog(@"Item %@", item);
        }];
        RESideMenuItem *manageFeedsItem = [[RESideMenuItem alloc] initWithTitle:@"Manage Feeds" action:^(RESideMenu *menu, RESideMenuItem *item) {
            [menu hide];
            NSLog(@"Item %@", item);
        }];
        RESideMenuItem *settingsItem = [[RESideMenuItem alloc] initWithTitle:@"Settings" action:^(RESideMenu *menu, RESideMenuItem *item) {
            [menu hide];
            NSLog(@"Item %@", item);
            
            SettingsViewController *svc = [[SettingsViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:svc];
            [navController.navigationBar configureFlatNavigationBarWithColor:kNAV_BAR_COLOR];
            [menu setRootViewController:navController];
            
        }];
        RESideMenuItem *logOutItem = [[RESideMenuItem alloc] initWithTitle:@"Log Out" action:^(RESideMenu *menu, RESideMenuItem *item) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log Out" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log Out", nil];
            [alertView show];
            
            /*
            FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"Log Out" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log Out",nil];
            
            alertView.titleLabel.textColor = [UIColor cloudsColor];
            alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
            alertView.messageLabel.textColor = [UIColor cloudsColor];
            alertView.messageLabel.font = [UIFont flatFontOfSize:14];
            alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
            alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
            alertView.defaultButtonColor = [UIColor cloudsColor];
            alertView.defaultButtonShadowColor = [UIColor asbestosColor];
            alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
            alertView.defaultButtonTitleColor = [UIColor asbestosColor];
            alertView.tag = kLOGOUT_ALERTVIEW;
            [alertView show];
            */
        }];
        
        _sideMenu = [[RESideMenu alloc] initWithItems:@[recentPostsItem, viewByFeedItem, bookmarkedItem, manageFeedsItem, settingsItem, logOutItem]];
        _sideMenu.verticalOffset = IS_WIDESCREEN ? 110 : 76;
        _sideMenu.hideStatusBarArea = [AppDelegate OSVersion] < 7;
    }
    
    [_sideMenu show];
}




- (void)alertView:(FUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Log Out"]) {
    
        [[User currentUser] drop];
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        LoginViewController *lvc = [[LoginViewController alloc] init];
        app.window.rootViewController = lvc;
    }
    
    
}


@end
