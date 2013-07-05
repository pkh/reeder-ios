//
//  SliderMenuViewController.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/28/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "SliderMenuViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/UIFont+FlatUI.h>
#import <FlatUIKit/UINavigationBar+FlatUI.h>
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "PostsViewController.h"
#import "FeedsViewController.h"
#import "Utils.h"
#import "SettingsViewController.h"




#define kLOGOUT_ALERTVIEW 0


@interface SliderMenuViewController ()
@property (nonatomic) UITableView *tableView;
@end

@implementation SliderMenuViewController


- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView setFrame:CGRectMake(0, 0, 320, (60*6))];
    //[self.tableView setBackgroundColor:[UIColor blackColor]];
    //[self.tableView setSeparatorColor:[UIColor midnightBlueColor]];
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setRowHeight:60];
    [self.tableView setScrollEnabled:NO];
    [self.view addSubview:self.tableView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - TableView Delegate/Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    */
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"All Recent Posts";
            break;
        case 1:
            cell.textLabel.text = @"View By Feed";
            break;
        case 2:
            cell.textLabel.text = @"Bookmarked";
            break;
        case 3:
            cell.textLabel.text = @"Manage Feeds";
            break;
        case 4:
            cell.textLabel.text = @"Settings";
            break;
        case 5:
            cell.textLabel.text = @"Log Out";
            break;
        default:
            break;
    }
    
    
    //[cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    //[cell.contentView setBackgroundColor:[UIColor colorWithRed:(20.0/255.0) green:(20.0/255.0) blue:(20.0/255.0) alpha:1.0]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    /*
    UIView *orangeBarView = [[UIView alloc] init];
    [orangeBarView setFrame:CGRectMake(2, 10, 3, 40)];
    [orangeBarView setBackgroundColor:[UIColor pumpkinColor]];
    [cell.contentView addSubview:orangeBarView];
    */
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
    switch (indexPath.row) {
        case 0: { // recent posts
            PostsViewController *pvc = [[PostsViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pvc];
            //[navController.navigationBar configureFlatNavigationBarWithColor:kNAV_BAR_COLOR];
            self.sidePanelController.centerPanel = navController;
            [self.sidePanelController toggleLeftPanel:nil];
            break;
        }
        case 1: { // view by feed
            FeedsViewController *fvc = [[FeedsViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:fvc];
            //[navController.navigationBar configureFlatNavigationBarWithColor:kNAV_BAR_COLOR];
            self.sidePanelController.centerPanel = navController;
            break;
        }
        case 2: { // bookmarked
            PostsViewController *pvc = [[PostsViewController alloc] init];
            pvc.postsViewControllerType = BookmakedPostsVCType;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pvc];
            //[navController.navigationBar configureFlatNavigationBarWithColor:kNAV_BAR_COLOR];
            self.sidePanelController.centerPanel = navController;
            [self.sidePanelController toggleLeftPanel:nil];
            break;
        }
        case 3: // manage feeds
#warning implement manage feeds!
            break;
        case 4: { // settings
            SettingsViewController *svc = [[SettingsViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:svc];
            //[navController.navigationBar configureFlatNavigationBarWithColor:kNAV_BAR_COLOR];
            self.sidePanelController.centerPanel = navController;
            break;
        }
        case 5: {   // logout
            FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"Log Out" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log Out",nil];
            
            alertView.titleLabel.textColor = [UIColor whiteColor];
            alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
            alertView.messageLabel.textColor = [UIColor whiteColor];
            alertView.messageLabel.font = [UIFont flatFontOfSize:14];
            alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
            alertView.alertContainer.backgroundColor = [UIColor blackColor];
            alertView.defaultButtonColor = [UIColor carrotColor];
            alertView.defaultButtonShadowColor = [UIColor pumpkinColor];
            alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
            alertView.defaultButtonTitleColor = [UIColor whiteColor];
            alertView.tag = kLOGOUT_ALERTVIEW;
            [alertView show];
            break;
        }
        default:
            break;
    }
    
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
