//
//  FeedsViewController.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 7/3/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


- (void)feedsListLoadedSuccessfully:(NSMutableArray *)feeds;
- (void)feedReloadFailedWithError:(NSError *)error;


@end
