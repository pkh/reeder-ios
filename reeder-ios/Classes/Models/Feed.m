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

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.feedID = [dict objectForKey:@"id"];
        self.feedTitle = [dict objectForKey:@"title"];
        self.feedDescription = [dict objectForKey:@"description"];
        self.feedRssURL = [dict objectForKey:@"url"];
        self.feedSiteURL = [dict objectForKey:@"site_url"];
        self.feedLastModifiedDate = [dict objectForKey:@"last_modified_at"];
        self.feedStatus = [dict objectForKey:@"status"];
        self.feedPostsCount = [dict objectForKey:@"posts_count"];
        self.feedUnreadPostsCount = [dict objectForKey:@"unread_posts_count"];
        self.feedCreatedDate = [dict objectForKey:@"created_at"];
        self.feedUpdatedDate = [dict objectForKey:@"updated_at"];
        
    }
    return self;
}




/*
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
*/


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



@end
