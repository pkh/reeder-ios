//
//  Post.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/26/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
//#import <CoreData/CoreData.h>

@class Feed;

//@interface Post : NSManagedObject
@interface Post : NSObject <NSCoding>

@property (nonatomic, retain) NSString * postAuthor;
@property (nonatomic, retain) NSNumber * postBookmarked;
@property (nonatomic, retain) NSString * postContent;
@property (nonatomic, retain) NSNumber * postParentFeedID;
@property (nonatomic, retain) NSNumber * postID;
@property (nonatomic, retain) NSString * postURL;
@property (nonatomic, retain) NSDate * postPublishedDate;
@property (nonatomic, retain) NSDate * postReadDate;
@property (nonatomic, retain) NSString * postTitle;
@property (nonatomic, retain) Feed *parentFeed;

@end
