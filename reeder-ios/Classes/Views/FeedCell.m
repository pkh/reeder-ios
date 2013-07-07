//
//  FeedCell.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 7/7/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "FeedCell.h"
#import <FlatUIKit/UIFont+FlatUI.h>



@implementation FeedCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self.textLabel removeFromSuperview];
        
        self.feedTitleLabel = [[UILabel alloc] init];
        [self.feedTitleLabel setFrame:CGRectMake(10, 0, 265, 44)];
        [self.feedTitleLabel setFont:[UIFont boldFlatFontOfSize:16]];
        [self.contentView addSubview:self.feedTitleLabel];
        
        
        self.unreadCountLabel = [[UILabel alloc] init];
        [self.unreadCountLabel setFrame:CGRectMake(280, 0, 20, 44)];
        [self.unreadCountLabel setFont:[UIFont boldFlatFontOfSize:12]];
        [self.unreadCountLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.unreadCountLabel];
        
        
        
        [self setSelectionStyle:UITableViewCellSelectionStyleGray];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
