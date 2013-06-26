//
//  DataController.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/26/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@class Feed;

@interface DataController : NSObject


@property (nonatomic) NSMutableArray *feedsArray;


+ (DataController *)sharedObject;


+ (DataController *)loadDataControllerFromDisk;

- (NSInteger)numberOfFeeds;
- (NSInteger)numberOfPostsForFeed:(NSNumber *)feedID;
- (NSInteger)numberOfUnreadPostsForFeed:(NSNumber *)feedID;

- (Feed *)feedAtIndex:(NSInteger)idx;
- (NSMutableArray *)postsForFeed:(NSNumber *)feedID;
- (Feed *)feedWithID:(NSNumber *)feedID;


- (void)loadFeedsFromServerWithDelegate:(id)delegate;

@end
