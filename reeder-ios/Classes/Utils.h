//
//  Utils.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/26/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kNAV_BAR_COLOR [UIColor blackColor]
#define kSEPIA_COLOR [UIColor colorWithRed:(245.0/255.0) green:(222.0/255.0) blue:(179.0/255.0) alpha:1.0]


typedef enum {
    RecentPostsVCType,
    BookmakedPostsVCType,
    SingleFeedPostsVCType,
} PostsVCType;