//
//  FeedsViewController.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 7/3/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "FeedsViewController.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/UIBarButtonItem+FlatUI.h>
#import <FlatUIKit/UINavigationBar+FlatUI.h>
#import <FlatUIKit/UIFont+FlatUI.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Utils.h"
#import "Feed.h"
#import "AddFeedViewController.h"
#import "ReederAPIClient.h"
#import "PostsViewController.h"
#import "FeedCell.h"




#define kTableViewFrame CGRectMake(0, 0, 320, (self.view.frame.size.height-44))
#define kCellReuseIdentifier @"CellIdentifier"


@interface FeedsViewController ()
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation FeedsViewController

- (void)loadView
{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"Feeds";
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView setFrame:kTableViewFrame];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setRowHeight:44];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    //[self.refreshControl setTintColor:[UIColor blackColor]];
    [self.tableView addSubview:self.refreshControl];
    
    [self.view addSubview:self.tableView];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    if (!self.dataSource) {
        self.dataSource = [[NSMutableArray alloc] init];
    }
    
    [self.tableView registerClass:[FeedCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    
    [SVProgressHUD showWithStatus:@"Loading Feeds..." maskType:SVProgressHUDMaskTypeGradient];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [ReederAPIClient loadFeedsListWithDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Handle Pull-to-Refresh

- (void)handleRefresh:(id)sender {
    NSLog(@"refresh");
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [ReederAPIClient loadFeedsListWithDelegate:self];
    
    //[[DataController sharedObject] loadFeedsFromServerWithDelegate:self];
    
}

#pragma mark - Bar Button Item Actions

- (void)addButtonAction:(id)sender {
    
    AddFeedViewController *afvc = [[AddFeedViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:afvc];
    //[navController.navigationBar configureFlatNavigationBarWithColor:kNAV_BAR_COLOR];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navController animated:YES completion:nil];
    
}


#pragma mark - TableView Delegate/Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}


- (FeedCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = kCellReuseIdentifier;
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    Feed *f = (Feed *)[self.dataSource objectAtIndex:indexPath.row];
    cell.feedTitleLabel.text = f.feedTitle;
    cell.unreadCountLabel.text = [f.feedUnreadPostsCount stringValue];
    
    cell.textLabel.font = [UIFont boldFlatFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.textLabel.backgroundColor = [UIColor greenColor];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PostsViewController *pvc = [[PostsViewController alloc] init];
    pvc.postsViewControllerType = SingleFeedPostsVCType;
    pvc.singleFeed = (Feed *)[self.dataSource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:pvc animated:YES];
    
    //PostDetailViewController *pdvc = [[PostDetailViewController alloc] init];
    //pdvc.postObject = [self.dataSource objectAtIndex:indexPath.row];
    //[self.navigationController pushViewController:pdvc animated:YES];
    
}


#pragma mark - Delegate Callbacks

- (void)feedsListLoadedSuccessfully:(NSMutableArray *)feeds {
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:feeds];
    
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [SVProgressHUD dismiss];
    [self.tableView reloadData];
    
}

- (void)feedReloadFailedWithError:(NSError *)error {
    NSLog(@"%@: %@",NSStringFromSelector(_cmd), [error localizedDescription]);
    
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}


@end
