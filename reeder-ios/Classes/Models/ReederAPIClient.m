//
//  ReederAPIClient.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/27/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "ReederAPIClient.h"
#import "User.h"
#import "Feed.h"
#import "Post.h"
#import "PostsViewController.h"
#import "ReederRequest.h"
#import "AddFeedViewController.h"


@implementation ReederAPIClient


#define kLOAD_RECENT_POSTS_URL @"http://reeder.doejoapp.com/api/posts"
#define kADD_NEW_FEED_URL @"http://reeder.doejoapp.com/api/feeds/import"





/*
static ReederAPIClient *reederAPIClient = nil;

+ (ReederAPIClient *)sharedObject {
    
    @synchronized(self) {
        if (reederAPIClient == nil) {
            reederAPIClient = [[ReederAPIClient alloc] init];
        }
    }
    return reederAPIClient;
}
*/

+ (void)loadRecentPostsWithDelegate:(id)delegate {
    
    NSURL *url = [NSURL URLWithString:kLOAD_RECENT_POSTS_URL];
    ReederRequest *request = [[ReederRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            
                                                                                            NSArray *recs = JSON;
                                                                                            NSLog(@"recs count: %i",[recs count]);
                                                                                            NSMutableArray *postsArray = [[NSMutableArray alloc] init];
                                                                                            for (NSDictionary *dict in recs) {
                                                                                                Post *p = [[Post alloc] initWithDictionary:dict];
                                                                                                [postsArray addObject:p];
                                                                                            }

                                                                                            if ([delegate respondsToSelector:@selector(postsLoadedSuccessfully:)]) {
                                                                                                [delegate postsLoadedSuccessfully:postsArray];
                                                                                            }
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure: %@",JSON);
                                                                                            
                                                                                            if ([delegate respondsToSelector:@selector(failedToLoadPostsWithError:)]) {
                                                                                                [delegate failedToLoadPostsWithError:error];
                                                                                            }
                                                                                        }];
    
    [operation start];
    
    
}


+ (void)subscribeToNewFeedWithFeedURL:(NSString *)url andDelegate:(id)delegate {

    NSString *fullURLStr = [NSString stringWithFormat:@"%@?url=%@", kADD_NEW_FEED_URL, url];
    NSURL *fullURL = [NSURL URLWithString:fullURLStr];
    ReederRequest *request = [[ReederRequest alloc] initWithURL:fullURL];
    
    [request setHTTPMethod:@"POST"];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                        
                                                                                            NSLog(@"subscribeToNewFeedWithFeedURL--SUCCESS");
                                                                                            if ([delegate respondsToSelector:@selector(newSubscriptionSuccessful)]) {
                                                                                                [delegate newSubscriptionSuccessful];
                                                                                            }
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                        
                                                                                            NSLog(@"subscribeToNewFeedWithFeedURL--FAILURE");
                                                                                            NSLog(@"%@",[error localizedFailureReason]);
                                                                                            if ([delegate respondsToSelector:@selector(newSubscriptionFailedWithError:)]) {
                                                                                                [delegate newSubscriptionFailedWithError:error];
                                                                                            }
                                                                                            
                                                                                        }];
    
    [operation start];
}

@end
