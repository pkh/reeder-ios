//
//  AddFeedViewController.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/26/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit/FUIAlertView.h>

@interface AddFeedViewController : UIViewController <UITextFieldDelegate, FUIAlertViewDelegate>

- (void)newSubscriptionSuccessful;
- (void)newSubscriptionFailedWithError:(NSError *)error;

@end
