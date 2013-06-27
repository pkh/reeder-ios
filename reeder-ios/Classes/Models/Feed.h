//
//  Feed.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/26/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
//#import <CoreData/CoreData.h>


//@interface Feed : NSManagedObject
@interface Feed : NSObject /*<NSCoding>*/


@property (nonatomic, retain) NSDate * feedCreatedDate;
@property (nonatomic, retain) NSString * feedDescription;
@property (nonatomic, retain) NSNumber * feedID;
@property (nonatomic, retain) NSString * feedStatus;
@property (nonatomic, retain) NSDate * feedLastModifiedDate;
@property (nonatomic, retain) NSNumber * feedPostsCount;
@property (nonatomic, retain) NSString * feedRssURL;
@property (nonatomic, retain) NSString * feedSiteURL;
@property (nonatomic, retain) NSString * feedTitle;
@property (nonatomic, retain) NSNumber * feedUnreadPostsCount;
@property (nonatomic, retain) NSDate * feedUpdatedDate;
@property (nonatomic, retain) NSMutableArray *feedPosts;


- (id)initWithDictionary:(NSDictionary *)dict;




+ (void)subscribeToNewFeedWithFeedURL:(NSString *)url andDelegate:(id)delegate;

//+ (RKObjectMapping *)objectMapping;



@end

/*
@interface Feed (CoreDataGeneratedAccessors)

- (void)addPostsObject:(NSManagedObject *)value;
- (void)removePostsObject:(NSManagedObject *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
*/