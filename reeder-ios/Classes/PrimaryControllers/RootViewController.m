//
//  RootViewController.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/24/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "RootViewController.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/UIBarButtonItem+FlatUI.h>
#import <FlatUIKit/UINavigationBar+FlatUI.h>

#import "Utils.h"
#import "SettingsViewController.h"
#import "Feed.h"
#import "AddFeedViewController.h"


#define kTableViewFrame CGRectMake(0, 0, 320, self.view.frame.size.height)
#define kCellReuseIdentifier @"CellIdentifier"

@interface RootViewController ()
@property (nonatomic) UITableView *tableView;
@end

@implementation RootViewController
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
- (void)loadView {
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"Reeder"];
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView setFrame:kTableViewFrame];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setRowHeight:64];
    [self.view addSubview:self.tableView];
    
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [UIBarButtonItem configureFlatButtonsWithColor:[UIColor wetAsphaltColor]
                                  highlightedColor:[UIColor midnightBlueColor]
                                      cornerRadius:6];
    
    UIBarButtonItem *settingsButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(settingsBarButtonAction:)];
    self.navigationItem.leftBarButtonItem = settingsButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Bar Button Item Actions

- (void)settingsBarButtonAction:(id)sender {
    NSLog(@"settings");
    
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:svc];
    [navController.navigationBar configureFlatNavigationBarWithColor:kNAV_BAR_COLOR];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void)addButtonAction:(id)sender {
    
    AddFeedViewController *afvc = [[AddFeedViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:afvc];
    [navController.navigationBar configureFlatNavigationBarWithColor:kNAV_BAR_COLOR];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navController animated:YES completion:nil];
    
    
}


#pragma mark - TableView Delegate/Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = kCellReuseIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
