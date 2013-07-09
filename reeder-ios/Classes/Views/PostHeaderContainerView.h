//
//  PostHeaderContainerView.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 7/8/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostHeaderContainerView : UIView

@property (nonatomic) NSString *postDateString;
@property (nonatomic) NSString *postBlogNameString;
@property (nonatomic) NSString *postTitleString;

- (void)draw;

@end
