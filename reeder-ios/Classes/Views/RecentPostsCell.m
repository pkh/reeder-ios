//
//  RecentPostsCell.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/27/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "RecentPostsCell.h"
#import <FlatUIKit/UIFont+FlatUI.h>
#import <FlatUIKit/UIColor+FlatUI.h>


#define kROOT_CONTENTVIEW_X_COORD 10


@interface RecentPostsCell () {
    CGFloat percentage;
}

@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property BOOL allowClose;

@end


@implementation RecentPostsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        self.postID = [[NSNumber alloc] init];
        
        self.feedNameLabel = [[UILabel alloc] init];
        [self.feedNameLabel setFrame:CGRectMake(kROOT_CONTENTVIEW_X_COORD, 3, 210, 16)];
        [self.feedNameLabel setFont:[UIFont boldSystemFontOfSize:10]];
        [self.feedNameLabel setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.feedNameLabel];
        
        self.postTitleLabel = [[UILabel alloc] init];
        [self.postTitleLabel setFrame:CGRectMake(kROOT_CONTENTVIEW_X_COORD, 20, 270, 38)];
        [self.postTitleLabel setFont:[UIFont boldFlatFontOfSize:14]];
        [self.postTitleLabel setNumberOfLines:2];
        [self.postTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.contentView addSubview:self.postTitleLabel];
        
        self.postContentLabel = [[UILabel alloc] init];
        [self.postContentLabel setFrame:CGRectMake(kROOT_CONTENTVIEW_X_COORD, 59, 270, 18)];
        [self.postContentLabel setTextColor:[UIColor lightGrayColor]];
        [self.postContentLabel setFont:[UIFont systemFontOfSize:10]];
        [self.contentView addSubview:self.postContentLabel];
        
        
        self.markReadLabel = [[UILabel alloc] init];
        [self.markReadLabel setFrame:CGRectMake(30, (40-15), 90, 30)];
        [self.markReadLabel setTextAlignment:NSTextAlignmentCenter];
        [self.markReadLabel setFont:[UIFont boldFlatFontOfSize:12]];
        [self.markReadLabel setBackgroundColor:[UIColor alizarinColor]];
        [self.markReadLabel setTextColor:[UIColor whiteColor]];
        [self.markReadLabel setText:@"Mark Read"];
        [self.markReadLabel setAlpha:0];
        //[self addSubview:self.markReadLabel];
        
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
        [self.panGestureRecognizer setDelegate:self];
        [self addGestureRecognizer:self.panGestureRecognizer];
        
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setSelectionStyle:UITableViewCellSelectionStyleGray];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - Sliding Animations

- (void)panGestureHandler:(UIPanGestureRecognizer *)panRecognizer {
    
    UIGestureRecognizerState state = [panRecognizer state];
    CGPoint translation = [panRecognizer translationInView:self];
    //CGPoint velocity = [panRecognizer velocityInView:self];
    CGFloat panPercentage = [self percentageWithOffset:CGRectGetMinX(self.contentView.frame) relativeToWidth:CGRectGetWidth(self.bounds)];
    //NSTimeInterval animationDuration = [self animationDurationWithVelocity:velocity];
    
    if (state == UIGestureRecognizerStateBegan) {
        
    } else if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        
        if (![self.subviews containsObject:self.markReadLabel]) {
            [self addSubview:self.markReadLabel];
        }
        
        if (self.markReadLabel.alpha <= 1.0 && panPercentage > 0.10) {
            self.markReadLabel.alpha = (panPercentage * 2);
        }
        
        CGPoint center = {self.contentView.center.x + translation.x, self.contentView.center.y};
        if (panPercentage < 0.40f && self.allowClose == NO) {    // continue animating the slide

            [self.contentView setCenter:center];
            [self animateWithOffset:CGRectGetMinX(self.contentView.frame)];
            [panRecognizer setTranslation:CGPointZero inView:self];
            
        } else {
            
            //[self displayRemoveButton:NO];
            
            [self.contentView setCenter:center];
            [self animateWithOffset:CGRectGetMinX(self.contentView.frame)];
            [panRecognizer setTranslation:CGPointZero inView:self];
            
        }
        
    } else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
        //_currentImageName = [self imageNameWithPercentage:percentage];
        
        percentage = panPercentage;
        if (percentage < 0.50f || percentage > 0.99f) {
            [self bounceToOrigin];
        } else {
            //[self bounceToOpen];
            
            [self.markReadLabel removeFromSuperview];
            [self.delegate markCellAsRead:self];
            
        }
        
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer) {
        UIScrollView *superview = (UIScrollView *) self.superview;
        CGPoint translation = [(UIPanGestureRecognizer *) gestureRecognizer translationInView:superview];
        
        // Make sure it is scrolling horizontally
        return ((fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO && (superview.contentOffset.y == 0.0 && superview.contentOffset.x == 0.0));
    }
    return NO;
}


- (CGFloat)percentageWithOffset:(CGFloat)offset relativeToWidth:(CGFloat)width {
    CGFloat percent = offset / width;
    
    if (percent < -1.0) percent = -1.0;
    else if (percent > 1.0) percent = 1.0;
    
    return percent;
}

- (void)animateWithOffset:(CGFloat)offset {
    
    //CGFloat percentage = [self percentageWithOffset:offset relativeToWidth:CGRectGetWidth(self.bounds)];
    
}

- (void)bounceToOpen {
    
    CGFloat bounceDistance = 10.0 * percentage;
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:(UIViewAnimationOptionCurveEaseOut)
                     animations:^{
                         CGRect frame = self.contentView.frame;
                         frame.origin.x = (self.frame.size.width/2) + -bounceDistance;
                         [self.contentView setFrame:frame];
                         //[_slidingImageView setAlpha:0.0];
                         //[self slideImageWithPercentage:0 imageName:_currentImageName isDragging:NO];
                         [self.contentView setAlpha:0.6];
                     }
                     completion:^(BOOL finished1) {
                         
                         [UIView animateWithDuration:0.1
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              CGRect frame = self.contentView.frame;
                                              frame.origin.x = (self.frame.size.width/2);
                                              [self.contentView setFrame:frame];
                                          }
                                          completion:^(BOOL finished2) {
                                              //[self displayRemoveButton:YES];
                                              [self setSelectionStyle:UITableViewCellSelectionStyleNone];
                                          }];
                     }];
    
}


- (void)bounceToOrigin {
    
    CGFloat bounceDistance = 20.0 * percentage;
    
    self.markReadLabel.alpha = 0;
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:(UIViewAnimationOptionCurveEaseOut)
                     animations:^{
                         CGRect frame = self.contentView.frame;
                         frame.origin.x = -bounceDistance;
                         [self.contentView setFrame:frame];
                         
                     }
                     completion:^(BOOL finished1) {
                         
                         [UIView animateWithDuration:0.1
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              CGRect frame = self.contentView.frame;
                                              frame.origin.x = 0;
                                              [self.contentView setFrame:frame];
                                          }
                                          completion:^(BOOL finished2) {
                                              [self.contentView setAlpha:1.0];
                                              //self.isSlidAside = NO;
                                              [self.markReadLabel removeFromSuperview];
                                              [self setSelectionStyle:UITableViewCellSelectionStyleGray];
                                          }];
                     }];
}



@end
