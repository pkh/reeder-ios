//
//  Feed.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/26/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "Feed.h"
#import "User.h"
#import "AddFeedViewController.h"


#define kFeedCreatedDate @"feedCreatedDate"
#define kFeedDescription @"feedDescription"
#define kFeedID @"feedID"
#define kFeedStatus @"feedStatus"
#define kFeedLastModifiedDate @"feedLastModifiedDate"
#define kFeedPostsCount @"feedPostsCount"
#define kFeedRssURL @"feedRssURL"
#define kFeedSiteURL @"feedSiteURL"
#define kFeedTitle @"feedTitle"
#define kFeedUnreadPostsCount @"feedUnreadPostsCount"
#define kFeedUpdatedDate @"feedUpdatedDate"
#define kFeedPosts @"feedPosts"




@implementation Feed





#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder
{
    self = [[Feed alloc] init];
    
    if (self) {
        self.feedCreatedDate = [coder decodeObjectForKey:kFeedCreatedDate];
        self.feedDescription = [coder decodeObjectForKey:kFeedDescription];
        self.feedID = [coder decodeObjectForKey:kFeedID];
        self.feedStatus = [coder decodeObjectForKey:kFeedStatus];
        self.feedLastModifiedDate = [coder decodeObjectForKey:kFeedLastModifiedDate];
        self.feedPostsCount = [coder decodeObjectForKey:kFeedPostsCount];
        self.feedRssURL = [coder decodeObjectForKey:kFeedRssURL];
        self.feedSiteURL = [coder decodeObjectForKey:kFeedSiteURL];
        self.feedTitle = [coder decodeObjectForKey:kFeedTitle];
        self.feedUnreadPostsCount = [coder decodeObjectForKey:kFeedUnreadPostsCount];
        self.feedUpdatedDate = [coder decodeObjectForKey:kFeedUpdatedDate];
        self.feedPosts = [coder decodeObjectForKey:kFeedPosts];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.feedCreatedDate forKey:kFeedCreatedDate];
    [coder encodeObject:self.feedDescription forKey:kFeedDescription];
    [coder encodeObject:self.feedID forKey:kFeedID];
    [coder encodeObject:self.feedStatus forKey:kFeedStatus];
    [coder encodeObject:self.feedLastModifiedDate forKey:kFeedLastModifiedDate];
    [coder encodeObject:self.feedPostsCount forKey:kFeedPostsCount];
    [coder encodeObject:self.feedRssURL forKey:kFeedRssURL];
    [coder encodeObject:self.feedSiteURL forKey:kFeedSiteURL];
    [coder encodeObject:self.feedTitle forKey:kFeedTitle];
    [coder encodeObject:self.feedUnreadPostsCount forKey:kFeedUnreadPostsCount];
    [coder encodeObject:self.feedUpdatedDate forKey:kFeedUpdatedDate];
    [coder encodeObject:self.feedPosts forKey:kFeedPosts];
    
}



+ (RKObjectMapping *)objectMapping {
    
    // the "key" (on the left) is the JSON field name
    // the "value" (on the right) is the local Cocoa property
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Feed class]];
    
    NSDictionary *keyPathsAndAttributes = @{@"id": @"feedID",
                                            @"title" : @"feedTitle",
                                            @"description" : @"feedDescription",
                                            @"url" : @"feedRssURL",
                                            @"site_url" : @"feedSiteURL",
                                            @"last_modified_at" : @"feedLastModifiedDate",
                                            @"status" : @"feedStatus",
                                            @"posts_count" : @"feedPostsCount",
                                            @"unread_posts_count" : @"feedUnreadPostsCount",
                                            @"created_at" : @"feedCreatedDate",
                                            @"updated_at" : @"feedUpdatedDate"};
    
    [mapping addAttributeMappingsFromDictionary:keyPathsAndAttributes];
    
    return mapping;
    
}



#pragma mark - Subscribe to new feed

+ (void)subscribeToNewFeedWithFeedURL:(NSString *)url andDelegate:(id)delegate {
        
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:nil keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [responseDescriptor setBaseURL:manager.baseURL];
    
    // clear out any existing descriptors before adding the new ones
    for (RKRequestDescriptor *rd in [manager requestDescriptors]) {
        [manager removeRequestDescriptor:rd];
    }
    for (RKResponseDescriptor *rd in [manager responseDescriptors]) {
        [manager removeResponseDescriptor:rd];
    }
    //[manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    
    NSString *fullPathPattern = [NSString stringWithFormat:@"feeds/import"];
    NSDictionary *params = @{@"url" : url,
                             @"api_token" : [[User currentUser] apiToken]};
    
    [manager postObject:nil path:fullPathPattern parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"subscribeToNewFeedWithFeedURL--SUCCESS");
        
        
        if ([delegate respondsToSelector:@selector(newSubscriptionSuccessful)]) {
            [delegate newSubscriptionSuccessful];
        }
        
        
    } failure:^ (RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"subscribeToNewFeedWithFeedURL--FAILURE");
        NSLog(@"%@",[error localizedFailureReason]);
        
        if ([delegate respondsToSelector:@selector(newSubscriptionFailedWithError:)]) {
            [delegate newSubscriptionFailedWithError:error];
        }
        
    }];
    
    
    
}


@end
