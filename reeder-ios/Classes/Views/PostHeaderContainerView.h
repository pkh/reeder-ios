//
//  PostHeaderContainerView.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 7/8/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostHeaderContainerView : UIView



@property (nonatomic) UILabel *postDate;
@property (nonatomic) UILabel *postBlogName;
@property (nonatomic) UILabel *postTitle;

- (void)redraw;

@end
