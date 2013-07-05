//
//  PostsViewController.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/28/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "PostsViewController.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/UIBarButtonItem+FlatUI.h>
#import <FlatUIKit/UINavigationBar+FlatUI.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "SettingsViewController.h"
#import "Feed.h"
#import "AddFeedViewController.h"
#import "User.h"
#import "Post.h"
#import "ReederAPIClient.h"
#import "RecentPostsCell.h"
#import "PostDetailViewController.h"



#define kTableViewFrame CGRectMake(0, 0, 320, (self.view.frame.size.height-44))
#define kCellReuseIdentifier @"CellIdentifier"

@interface PostsViewController ()
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation PostsViewController


static dispatch_queue_t reederQueue;

dispatch_queue_t background_load_queue()
{
    if (reederQueue == NULL) {
        reederQueue = dispatch_queue_create("com.pkh.reeder.reederQueue", 0);
    }
    return reederQueue;
}



- (void)loadView {
    [super loadView];
    /*
    [UIBarButtonItem configureFlatButtonsWithColor:[UIColor carrotColor]
                                  highlightedColor:[UIColor pumpkinColor]
                                      cornerRadius:6];
    */
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView setFrame:kTableViewFrame];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setRowHeight:80];
    
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
    
    
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    [self.tableView registerClass:[RecentPostsCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    
    if (!self.dataSource) {
        self.dataSource = [[NSMutableArray alloc] init];
    } else {
        [self.dataSource removeAllObjects];
    }
    
    [SVProgressHUD showWithStatus:@"Loading Posts..." maskType:SVProgressHUDMaskTypeGradient];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    switch (self.postsViewControllerType) {
        case RecentPostsVCType:
            self.title = @"Recent Posts";
            [ReederAPIClient loadRecentPostsWithDelegate:self];
            break;
        case SingleFeedPostsVCType:
            self.title = self.singleFeed.feedTitle;
            [ReederAPIClient loadPostsForFeedID:[self.singleFeed feedID] withDelegate:self];
            break;
        case BookmakedPostsVCType:
            self.title = @"Bookmarked";
            [ReederAPIClient loadBookmarkedPostsWithDelegate:self];
            break;
        default:
            break;
    }
    
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
    
    [ReederAPIClient loadRecentPostsWithDelegate:self];
    
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


- (RecentPostsCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = kCellReuseIdentifier;
    RecentPostsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[RecentPostsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    Post *p = [self.dataSource objectAtIndex:indexPath.row];
    cell.feedNameLabel.text = p.parentFeed.feedTitle;
    cell.postTitleLabel.text = p.postTitle;
    cell.postContentLabel.text = p.postContent;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PostDetailViewController *pdvc = [[PostDetailViewController alloc] init];
    pdvc.postObject = [self.dataSource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:pdvc animated:YES];
    
}


#pragma mark - Delegate Callbacks

- (void)postsLoadedSuccessfully:(NSMutableArray *)posts {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:posts];
    
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [SVProgressHUD dismiss];
    [self.tableView reloadData];
}

- (void)failedToLoadPostsWithError:(NSError *)error {
    NSLog(@"%@: %@",NSStringFromSelector(_cmd), [error localizedDescription]);
    
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

/*
- (void)feedsReloadedSuccessfully {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.refreshControl endRefreshing];
    
    [self.tableView reloadData];
    
}

- (void)feedReloadFailedWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.refreshControl endRefreshing];
    
}
*/

@end
