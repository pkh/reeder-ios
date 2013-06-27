//
//  RootViewController.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/24/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>



- (void)postsLoadedSuccessfully:(NSMutableArray *)posts;
- (void)failedToLoadPostsWithError:(NSError *)error;

- (void)feedsReloadedSuccessfully;
- (void)feedReloadFailedWithError:(NSError *)error;

@end
