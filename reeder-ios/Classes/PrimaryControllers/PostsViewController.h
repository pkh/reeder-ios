//
//  PostsViewController.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/28/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "PostCellActionDelegate.h"

@class Feed;


@interface PostsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PostCellActionDelegate>

@property (nonatomic) Feed *singleFeed;
@property PostsVCType postsViewControllerType;


- (void)postsLoadedSuccessfully:(NSMutableArray *)posts;
- (void)failedToLoadPostsWithError:(NSError *)error;

//- (void)feedsReloadedSuccessfully;
//- (void)feedReloadFailedWithError:(NSError *)error;


@end
