//
//  Post.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/26/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "Post.h"
#import "Feed.h"


#define kPostAuthor @"postAuthor"
#define kPostBookmarked @"postBookmarked"
#define kPostContent @"postContent"
#define kPostParentFeedID @"postParentFeedID"
#define kPostID @"postID"
#define kPostURL @"postURL"
#define kPostPublishedDate @"postPublishedDate"
#define kPostReadDate @"postReadDate"
#define kPostTitle @"postTitle"
#define kParentFeed @"parentFeed"





@implementation Post




#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder
{
    self = [[Post alloc] init];
    
    if (self) {
        self.postAuthor = [coder decodeObjectForKey:kPostAuthor];
        self.postBookmarked = [coder decodeObjectForKey:kPostBookmarked];
        self.postContent = [coder decodeObjectForKey:kPostContent];
        self.postParentFeedID = [coder decodeObjectForKey:kPostParentFeedID];
        self.postID = [coder decodeObjectForKey:kPostID];
        self.postURL = [coder decodeObjectForKey:kPostURL];
        self.postPublishedDate = [coder decodeObjectForKey:kPostPublishedDate];
        self.postReadDate = [coder decodeObjectForKey:kPostReadDate];
        self.postTitle = [coder decodeObjectForKey:kPostTitle];
        self.parentFeed = [coder decodeObjectForKey:kParentFeed];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.postAuthor forKey:kPostAuthor];
    [coder encodeObject:self.postBookmarked forKey:kPostBookmarked];
    [coder encodeObject:self.postContent forKey:kPostContent];
    [coder encodeObject:self.postParentFeedID forKey:kPostParentFeedID];
    [coder encodeObject:self.postID forKey:kPostID];
    [coder encodeObject:self.postURL forKey:kPostURL];
    [coder encodeObject:self.postPublishedDate forKey:kPostPublishedDate];
    [coder encodeObject:self.postReadDate forKey:kPostReadDate];
    [coder encodeObject:self.postTitle forKey:kPostTitle];
    [coder encodeObject:self.parentFeed forKey:kParentFeed];

}



@end
