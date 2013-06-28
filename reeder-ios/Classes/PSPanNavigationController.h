//
//  PSSwipeViewController.h
//  PSSwipeController
//
//  Created by Andrew Carter on 6/20/13.
//  Copyright (c) 2013 PinchStudios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PSPanNavigationControllerPosition)
{
    PSPanNavigationControllerPositionLeft,
    PSPanNavigationControllerPositionCenter,
    PSPanNavigationControllerPositionRight
};

@interface PSPanNavigationController : UIViewController

@property (nonatomic, readonly) UIScrollView *scrollView;

// Controllers
@property (nonatomic, strong) UIViewController *centerViewController;
@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIViewController *rightViewController;

// Settings
@property (nonatomic, assign) CGFloat maxVisibleWidthForLeftViewController;
@property (nonatomic, assign) CGFloat maxVisibleWidthForRightViewController;

// Container views
@property (nonatomic, readonly) UIView *centerContainerView;
@property (nonatomic, readonly) UIView *leftContainerView;
@property (nonatomic, readonly) UIView *rightContainerView;

- (void)panToPosition:(PSPanNavigationControllerPosition)position;
- (void)panToPosition:(PSPanNavigationControllerPosition)position animated:(BOOL)animated;

@end

@interface UIViewController (PSPanNavigationController)

@property (nonatomic, readonly) PSPanNavigationController *panNavigationController;

@end