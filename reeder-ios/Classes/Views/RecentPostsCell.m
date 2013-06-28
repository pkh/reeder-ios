//
//  RecentPostsCell.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/27/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "RecentPostsCell.h"
#import <FlatUIKit/UIFont+FlatUI.h>


@implementation RecentPostsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.feedNameLabel = [[UILabel alloc] init];
        [self.feedNameLabel setFrame:CGRectMake(10, 3, 210, 16)];
        [self.feedNameLabel setFont:[UIFont boldSystemFontOfSize:10]];
        [self.feedNameLabel setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.feedNameLabel];
        
        self.postTitleLabel = [[UILabel alloc] init];
        [self.postTitleLabel setFrame:CGRectMake(10, 20, 270, 38)];
        [self.postTitleLabel setFont:[UIFont boldFlatFontOfSize:14]];
        [self.postTitleLabel setNumberOfLines:2];
        [self.postTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.contentView addSubview:self.postTitleLabel];
        
        self.postContentLabel = [[UILabel alloc] init];
        [self.postContentLabel setFrame:CGRectMake(10, 59, 270, 18)];
        [self.postContentLabel setTextColor:[UIColor lightGrayColor]];
        [self.postContentLabel setFont:[UIFont systemFontOfSize:10]];
        [self.contentView addSubview:self.postContentLabel];
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
