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
#import "FeedsViewController.h"
#import "PostDetailViewController.h"



@implementation ReederAPIClient


#define kPOSTS_URL @"http://reeder.doejoapp.com/api/posts"
#define kADD_NEW_FEED_URL @"http://reeder.doejoapp.com/api/feeds/import"
#define kLOAD_FEEDS_LIST_URL @"http://reeder.doejoapp.com/api/feeds"





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

#pragma mark - Load Recent Posts

+ (void)loadRecentPostsWithDelegate:(id)delegate {
    
    NSURL *url = [NSURL URLWithString:kPOSTS_URL];
    ReederRequest *request = [[ReederRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            
                                                                                            NSArray *recs = [JSON objectForKey:@"records"];
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



#pragma mark - Subscribe to New Feed

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



#pragma mark - Load Feeds List

+ (void)loadFeedsListWithDelegate:(id)delegate {
    
    NSURL *url = [NSURL URLWithString:kLOAD_FEEDS_LIST_URL];
    ReederRequest *request = [[ReederRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");                                                                                            
                                                                                            
                                                                                            NSArray *recs = JSON;
                                                                                            NSLog(@"recs count: %i",[recs count]);
                                                                                            NSMutableArray *feedsArray = [[NSMutableArray alloc] init];
                                                                                            for (NSDictionary *dict in recs) {
                                                                                                Feed *f = [[Feed alloc] initWithDictionary:dict];
                                                                                                [feedsArray addObject:f];
                                                                                            }
                                                                                            
                                                                                            if ([delegate respondsToSelector:@selector(feedsListLoadedSuccessfully:)]) {
                                                                                                [delegate feedsListLoadedSuccessfully:feedsArray];
                                                                                            }
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure: %@",JSON);
                                                                                            
                                                                                            if ([delegate respondsToSelector:@selector(feedReloadFailedWithError:)]) {
                                                                                                [delegate feedReloadFailedWithError:error];
                                                                                            }
                                                                                        }];
    
    [operation start];
    
}



#pragma mark - Load Posts for Feed ID

+ (void)loadPostsForFeedID:(NSNumber *)feedID withDelegate:(id)delegate {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://reeder.doejoapp.com/api/feeds/%@/posts",feedID]];
    ReederRequest *request = [[ReederRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            
                                                                                            NSArray *recs = [JSON objectForKey:@"records"];
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



#pragma mark - Load Bookmarked Posts

+ (void)loadBookmarkedPostsWithDelegate:(id)delegate {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?bookmarked=true",kPOSTS_URL]];
    ReederRequest *request = [[ReederRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            
                                                                                            NSArray *recs = [JSON objectForKey:@"records"];
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



#pragma mark - Make Post as Read/Bookmarked

+ (void)markPostAsRead:(NSNumber *)postID withDelegate:(id)delegate {
 
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/read",kPOSTS_URL,[postID stringValue]]];
    ReederRequest *request = [[ReederRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success -- %@",NSStringFromSelector(_cmd));
                                                                                                                                                                                        
                                                                                            if ([delegate respondsToSelector:@selector(postMarkedReadSuccessfully)]) {
                                                                                                [delegate postMarkedReadSuccessfully];
                                                                                            }
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure: %@",JSON);
                                                                                            
                                                                                            if ([delegate respondsToSelector:@selector(errorMarkingPostAsRead:)]) {
                                                                                                [delegate errorMarkingPostAsRead:error];
                                                                                            }
                                                                                        }];
    
    [operation start];
    
}


+ (void)markPostAsBookmarked:(NSNumber *)postID withDelegate:(id)delegate {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/bookmark",kPOSTS_URL,[postID stringValue]]];
    ReederRequest *request = [[ReederRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success -- %@",NSStringFromSelector(_cmd));
                                                                                            
                                                                                            if ([delegate respondsToSelector:@selector(postBookmarkedSuccessfully)]) {
                                                                                                [delegate postBookmarkedSuccessfully];
                                                                                            }
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure: %@",JSON);
                                                                                            
                                                                                            if ([delegate respondsToSelector:@selector(errorBookmarkingPost:)]) {
                                                                                                [delegate errorBookmarkingPost:error];
                                                                                            }
                                                                                        }];
    
    [operation start];
    
}



@end
