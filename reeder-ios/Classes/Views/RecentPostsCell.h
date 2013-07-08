//
//  RecentPostsCell.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/27/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostCellActionDelegate.h"


@interface RecentPostsCell : UITableViewCell

@property (nonatomic) id<PostCellActionDelegate> delegate;

@property (nonatomic) UILabel *feedNameLabel;
@property (nonatomic) UILabel *postTitleLabel;
@property (nonatomic) UILabel *postContentLabel;
@property (nonatomic) NSNumber *postID;
@property (nonatomic) UILabel *markReadLabel;

@end
