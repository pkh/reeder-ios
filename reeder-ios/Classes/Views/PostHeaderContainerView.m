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
        
    }
    return self;
}

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
    }
    return self;
}
*/

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGFloat blackLineColor[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    CGContextSetStrokeColor(c, blackLineColor);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 0.0f, 100.0f);
    CGContextAddLineToPoint(c, 320.0f, 100.0f);
    CGContextStrokePath(c);
    /*
    // Drawing code
    //
    // DRAW A HORIZONTAL DIVIDER
    //
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    // Set the starting point of the shape.
    [aPath moveToPoint:CGPointMake(20.0, 200.0)];
    [aPath setLineWidth:2.0];
    [[UIColor blackColor] setStroke];
    
    // Draw the lines.
    [aPath addLineToPoint:CGPointMake(100.0, 200.0)];
    [aPath stroke];
    [aPath closePath];
    */ 
}


- (void)redraw {
    
    [_postDate setFrame:CGRectMake(0, 0, 320, 24)];
    [_postBlogName setFrame:CGRectMake(0, 24, 320, 24)];
    
    
    
    CGSize sizeForTitle = [self.postObject.postTitle sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(300, 150) lineBreakMode:NSLineBreakByWordWrapping];
    [_postTitle setFrame:CGRectMake(40, 48, 240, 50)];
    CGRect titleRect = self.postTitleLabel.frame;
    titleRect.size.height = sizeForTitle.height;
    _postTitle.frame = titleRect;
}

@end
