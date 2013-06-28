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
#import "RootViewController.h"
#import "ReederRequest.h"

@implementation ReederAPIClient


#define kLOAD_RECENT_POSTS_URL @"http://reeder.doejoapp.com/api/posts"

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

@end
