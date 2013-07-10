//
//  PostMarkedReadDelegate.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 7/10/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PostMarkedReadDelegate <NSObject>

@required
- (void)markPostReadWithID:(NSNumber *)postID;

@end
