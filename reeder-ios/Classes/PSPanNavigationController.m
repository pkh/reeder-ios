//
//  PSSwipeViewController.m
//  PSSwipeController
//
//  Created by Andrew Carter on 6/20/13.
//  Copyright (c) 2013 PinchStudios. All rights reserved.
//

#import "PSPanNavigationController.h"

#import <objc/runtime.h>

const char *PSPanNavigationControllerKey = "PSPanNavigationControllerKey";

static inline void ps_UIViewSetFrameOriginX(UIView *view, CGFloat originX) {
    [view setFrame:CGRectMake(originX, CGRectGetMinY([view frame]), CGRectGetWidth([view frame]), CGRectGetHeight([view frame]))];
}

@implementation UIViewController (PSPanNavigationController)

- (PSPanNavigationController *)panNavigationController
{
    PSPanNavigationController *panNavigationController = objc_getAssociatedObject(self, &PSPanNavigationControllerKey);
    
    if (!panNavigationController && [self panNavigationController] != nil)
    {
        panNavigationController = [[self parentViewController] panNavigationController];
    }
    
    return panNavigationController;
}

- (void)setPanNavigationController:(PSPanNavigationController *)panNavigationController
{
    objc_setAssociatedObject(self, &panNavigationController, panNavigationController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface PSPanNavigationController () <UIScrollViewDelegate>
{
    CGFloat _scrollViewScrollStartX;
}
@end

@implementation PSPanNavigationController

#pragma mark - UIViewController Overrides

- (id)init
{
    self = [super init];
    if (self)
    {
        _maxVisibleWidthForLeftViewController = 200.0f;
        _maxVisibleWidthForRightViewController = 200.0f;
        
        _centerContainerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        ps_UIViewSetFrameOriginX(_centerContainerView, [self maxVisibleWidthForLeftViewController]);
        [_centerContainerView setBackgroundColor:[UIColor blueColor]];
        
        _leftContainerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        _rightContainerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [view addSubview:_leftContainerView];
    [view addSubview:_rightContainerView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:[view bounds]];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setBounces:NO];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_scrollView setDelegate:self];
    [_scrollView addSubview:_centerContainerView];
    [view addSubview:_scrollView];
    
    [self setView:view];
}

- (void)viewDidLoad
{
    CGSize contentSize = CGSizeMake(_maxVisibleWidthForLeftViewController + _maxVisibleWidthForRightViewController + CGRectGetWidth([_scrollView bounds]), CGRectGetHeight([_scrollView bounds]));
    [_scrollView setContentSize:contentSize];
    [_scrollView setContentOffset:CGPointMake(_maxVisibleWidthForLeftViewController, 0.0f) animated:NO];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    ps_UIViewSetFrameOriginX(_rightContainerView, CGRectGetWidth([_rightContainerView frame]) - [self maxVisibleWidthForRightViewController]);
}

#pragma mark - Accessors

- (void)setLeftViewController:(UIViewController *)leftViewController
{
    UIViewController *currentLeftViewController = [self leftViewController];
    _leftViewController = leftViewController;
    [self replaceController:currentLeftViewController newController:leftViewController container:[self leftContainerView]];
}

- (void)setRightViewController:(UIViewController *)rightViewController
{
    UIViewController *currentRightViewController = [self rightViewController];
    _rightViewController = rightViewController;
    [self replaceController:currentRightViewController newController:rightViewController container:[self rightContainerView]];
}

- (void)setCenterViewController:(UIViewController *)centerViewController
{
    UIViewController *currentCenterViewController = [self centerViewController];
    _centerViewController = centerViewController;
    [self replaceController:currentCenterViewController newController:centerViewController container:[self centerContainerView]];
}

- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController container:(UIView *)container
{
    if (newController)
    {
        [self addChildViewController:newController];
        [[newController view] setFrame:[container bounds]];
        [newController setPanNavigationController:self];
        
        if (oldController)
        {
            [self transitionFromViewController:oldController toViewController:newController duration:0.0 options:0 animations:nil completion:^(BOOL finished) {
                
                [oldController removeFromParentViewController];
                [oldController setPanNavigationController:nil];
                
            }];
        }
        else
        {
            [container addSubview:[newController view]];
        }
    }
    else
    {
        [[oldController view] removeFromSuperview];
        [oldController removeFromParentViewController];
        [oldController setPanNavigationController:nil];
    }
}

#pragma mark - Instance Methods

- (void)panToPosition:(PSPanNavigationControllerPosition)position
{
    [self panToPosition:position animated:YES];
}

- (void)panToPosition:(PSPanNavigationControllerPosition)position animated:(BOOL)animated
{
    CGFloat offsetX = 0.0f;
    switch (position) {
        case PSPanNavigationControllerPositionLeft:
            offsetX = CGRectGetMinX([_leftContainerView frame]);
            break;
            
        case PSPanNavigationControllerPositionCenter:
            offsetX = CGRectGetMinX([_centerContainerView frame]);
            break;
            
        case PSPanNavigationControllerPositionRight:
            offsetX = CGRectGetMinX([_rightContainerView frame]);
            break;
    }
    
    [_scrollView scrollRectToVisible:CGRectMake(offsetX, 0.0f, CGRectGetWidth([_scrollView bounds]), CGRectGetHeight([_scrollView bounds])) animated:animated];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView contentOffset].x < CGRectGetMinX([_centerContainerView frame]))
    {
        [[self view] sendSubviewToBack:_rightContainerView];
    }
    else
    {
        [[self view] sendSubviewToBack:_leftContainerView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _scrollViewScrollStartX = [scrollView contentOffset].x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat leftClamp = _maxVisibleWidthForLeftViewController / 2.0f;
    CGFloat rightClamp = ([_scrollView contentSize].width - _maxVisibleWidthForRightViewController) - _maxVisibleWidthForRightViewController;
    
    if (_scrollViewScrollStartX < CGRectGetMinX([_centerContainerView frame]) / 2.0f && targetContentOffset->x > CGRectGetMinX([_centerContainerView frame]))
    {
        targetContentOffset->x = CGRectGetMinX([_centerContainerView frame]);
    }
    else if (_scrollViewScrollStartX >= [_scrollView contentSize].width - CGRectGetWidth([_scrollView bounds]))
    {
        targetContentOffset->x = CGRectGetMinX([_centerContainerView frame]);
    }
    else if (targetContentOffset->x <= leftClamp)
    {
        targetContentOffset->x = 0.0f;
    }
    else if (targetContentOffset->x >= rightClamp)
    {
        targetContentOffset->x = [_scrollView contentSize].width - CGRectGetWidth([_scrollView bounds]);
    }
    else
    {
        targetContentOffset->x = CGRectGetMinX([_centerContainerView frame]);
    }
}

@end
