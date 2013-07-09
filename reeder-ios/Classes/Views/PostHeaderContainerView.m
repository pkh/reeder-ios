//
//  PostHeaderContainerView.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 7/8/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "PostHeaderContainerView.h"
#import "Utils.h"
#import <FlatUIKit/UIFont+FlatUI.h>


@interface PostHeaderContainerView ()

@property (nonatomic) UILabel *postDate;
@property (nonatomic) UILabel *postBlogName;
@property (nonatomic) UILabel *postTitle;

@end


@implementation PostHeaderContainerView

- (id)init {
    if (self = [super init]) {
        _postDate = [[UILabel alloc] init];
        _postBlogName = [[UILabel alloc] init];
        _postTitle = [[UILabel alloc] init];
        
        [_postDate setFrame:CGRectZero];
        [_postDate setTextAlignment:NSTextAlignmentCenter];
        [_postDate setFont:[UIFont boldFlatFontOfSize:10]];
        [_postDate setTextColor:[UIColor darkGrayColor]];
        [_postDate setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_postDate];
        
        [_postBlogName setFrame:CGRectZero];
        [_postBlogName setTextAlignment:NSTextAlignmentCenter];
        [_postBlogName setFont:[UIFont boldFlatFontOfSize:12]];
        [_postBlogName setTextColor:[UIColor darkGrayColor]];
        [_postBlogName setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_postBlogName];
        
        [_postTitle setFrame:CGRectZero];
        [_postTitle setTextAlignment:NSTextAlignmentCenter];
        [_postTitle setBackgroundColor:[UIColor clearColor]];
        [_postTitle setFont:[UIFont boldFlatFontOfSize:20]];
        [_postTitle setNumberOfLines:0];
        //[_postTitle setAdjustsFontSizeToFitWidth:YES];
        [_postTitle setLineBreakMode:NSLineBreakByWordWrapping];
        [_postTitle setTextColor:[UIColor blackColor]];
        [self addSubview:_postTitle];
        
        
        _postDateString = [[NSString alloc] init];
        _postBlogNameString = [[NSString alloc] init];
        _postTitleString = [[NSString alloc] init];
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGFloat blackLineColor[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    CGContextSetStrokeColor(c, blackLineColor);
    CGContextBeginPath(c);
    
    CGFloat lineYCoord = (_postTitle.frame.origin.y + _postTitle.frame.size.height)+10;
    
    CGContextMoveToPoint(c, 10.0f, lineYCoord);
    CGContextAddLineToPoint(c, 310.0f, lineYCoord);
    CGContextStrokePath(c);

}


- (void)draw {
    
    // --------------------
    // Set label's text
    // --------------------
    [_postDate setText:_postDateString];
    [_postBlogName setText:_postBlogNameString];
    [_postTitle setText:_postTitleString];
    
    // --------------------
    // Set Frames
    // --------------------
    [_postDate setFrame:CGRectMake(0, 0, 320, 24)];
    [_postBlogName setFrame:CGRectMake(0, 24, 320, 24)];
    
    
    // --------------------
    // Size for whatever the title is
    // --------------------
    CGSize sizeForTitle = [_postTitleString sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(300, 150) lineBreakMode:NSLineBreakByWordWrapping];
    [_postTitle setFrame:CGRectMake(40, 48, 240, 50)];
    CGRect titleRect = _postTitle.frame;
    titleRect.size.height = sizeForTitle.height;
    _postTitle.frame = titleRect;
    NSLog(@"_postTitle height: %f",_postTitle.frame.size.height);
    
    
    // --------------------
    // Resize "self" to the proper height
    // --------------------
    CGFloat measuredHeight = (_postDate.frame.size.height + _postBlogName.frame.size.height + _postTitle.frame.size.height + 10 + 5);
    CGRect selfFrame = self.frame;
    selfFrame.size.height = measuredHeight;
    self.frame = selfFrame;
    
    // --------------------
    // Redraw view
    // --------------------
    [self setNeedsDisplay];
    
}

@end
