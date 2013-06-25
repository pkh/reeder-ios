//
//  LoginViewController.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/24/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>


- (void)successfullyLoggedIn;
- (void)loginFailedWithError:(NSError *)error;

- (void)createNewUserSuccessful;
- (void)createNewUserFailedWithError:(NSError *)error;

@end
