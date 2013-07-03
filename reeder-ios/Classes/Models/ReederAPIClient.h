//
//  ReederAPIClient.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/27/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@interface ReederAPIClient : NSObject



//+ (ReederAPIClient *)sharedObject;

+ (void)loadRecentPostsWithDelegate:(id)delegate;
+ (void)subscribeToNewFeedWithFeedURL:(NSString *)url andDelegate:(id)delegate;

+ (void)loadFeedsListWithDelegate:(id)delegate;

+ (void)loadPostsForFeedID:(NSNumber *)feedID withDelegate:(id)delegate;

@end
