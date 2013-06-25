//
//  LoginViewController.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/24/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "LoginViewController.h"
#import <FlatUIKit/FUIButton.h>
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/UIFont+FlatUI.h>
#import "User.h"
#import "RootViewController.h"
#import "AppDelegate.h"



#define kReederLabelFrame CGRectMake(10, 10, 300, 44)

#define kLeftButtonFrame_Up CGRectMake(10, 88, 145, 44)
#define kLeftButtonFrame_Down CGRectMake(10, 140, 145, 44)
#define kRightButtonFrame_Up CGRectMake(165, 88, 145, 44)
#define kRightButtonFrame_Down CGRectMake(165, 140, 145, 44)


@interface LoginViewController ()

@property (nonatomic) UILabel *reederLabel;

@property (nonatomic) FUIButton *leftButton;
@property (nonatomic) FUIButton *rightButton;

@property (nonatomic) UITextField *emailTextField;
@property (nonatomic) UITextField *passwordTextField;
@property (nonatomic) UITextField *nameTextField;

@property BOOL buttonsAreLowered;

@end

@implementation LoginViewController
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/


- (void)loadView {
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.reederLabel = [[UILabel alloc] init];
    self.reederLabel.frame = CGRectZero;
    [self.reederLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.reederLabel setTextAlignment:NSTextAlignmentCenter];
    [self.reederLabel setFont:[UIFont flatFontOfSize:24]];
    [self.reederLabel setText:@"reeder.io"];
    [self.view addSubview:self.reederLabel];
    
    /*
    NSLayoutConstraint *reederLabelConstraint = [NSLayoutConstraint constraintWithItem:self.reederLabel
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0
                                                                   constant:0.0];
    [self.view addConstraint:reederLabelConstraint];
    
    
    reederLabelConstraint = [NSLayoutConstraint constraintWithItem:self.reederLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:-132.0];
    
    [self.view addConstraint:reederLabelConstraint];
    */
    
    //UIButton *createUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton = [FUIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectZero;
    self.leftButton.buttonColor = [UIColor turquoiseColor];
    self.leftButton.shadowColor = [UIColor greenSeaColor];
    self.leftButton.shadowHeight = 3.0f;
    self.leftButton.cornerRadius = 6.0f;
    self.leftButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.leftButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    [self.leftButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.leftButton setTitle:@"Create User" forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftButton];
    
    //UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.rightButton = [FUIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectZero;
    self.rightButton.buttonColor = [UIColor turquoiseColor];
    self.rightButton.shadowColor = [UIColor greenSeaColor];
    self.rightButton.shadowHeight = 3.0f;
    self.rightButton.cornerRadius = 6.0f;
    self.rightButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.rightButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    [self.rightButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.rightButton setTitle:@"Log In" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightButton];
    
    
    self.reederLabel.frame = kReederLabelFrame;
    
    self.leftButton.frame = kLeftButtonFrame_Up;
    self.rightButton.frame = kRightButtonFrame_Up;
    
    
    
    /*
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.leftButton
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.reederLabel
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1.0
                                                                   constant:(44+22)];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.rightButton
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.reederLabel
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1.0
                                               constant:(44+22)];
    
    [self.view addConstraint:constraint];


    NSMutableArray *buttonConstraints = [[NSMutableArray alloc] init];
    
    UIButton *leftButtonRef = self.leftButton;
    UIButton *rightButtonRef = self.rightButton;
    
    [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[leftButtonRef]-10-[rightButtonRef(==leftButtonRef)]-10-|"
                                                                                   options:NSLayoutFormatAlignAllBaseline
                                                                                   metrics:nil
                                                                                     views:NSDictionaryOfVariableBindings(leftButtonRef, rightButtonRef)]];
    
    [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[leftButtonRef(HEIGHT)]"
                                                                                   options:0
                                                                                   metrics:@{@"HEIGHT" : @44}
                                                                                     views:NSDictionaryOfVariableBindings(leftButtonRef)]];
    
    [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rightButtonRef(HEIGHT)]"
                                                                                   options:0
                                                                                   metrics:@{@"HEIGHT" : @44}
                                                                                     views:NSDictionaryOfVariableBindings(rightButtonRef)]];
    
    [self.view addConstraints:buttonConstraints];
    */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (void)leftButtonAction:(id)sender {   // Create User
    NSLog(@"left button");
    
    if (self.buttonsAreLowered && [self.leftButton.titleLabel.text isEqualToString:@"Cancel"]) {
        // --------------------------------------------------
        // RETURN EVERYTHING TO DEFAULT POSITION AND LABELS
        // --------------------------------------------------
        [self raiseButtons];
        
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self.nameTextField resignFirstResponder];
        
    } else {
        
        if (!self.buttonsAreLowered) {
            [self lowerButtonsAndCreateUser:YES];
            
        }
        
    }
    
}

- (void)rightButtonAction:(id)sender {
    NSLog(@"log in");
    
    if (!self.buttonsAreLowered) {
        [self lowerButtonsAndCreateUser:NO];
        
    } else if (self.buttonsAreLowered) {
        // DO the action
        
        if ([self.rightButton.titleLabel.text isEqualToString:@"Log In"]) {
            NSLog(@"Log in user: %@",self.emailTextField.text);
            NSLog(@"And password: %@",self.passwordTextField);
            
            [User authenticateWithEmail:self.emailTextField.text andPassword:self.passwordTextField.text withDelegate:self];
            
        } else if ( [self.rightButton.titleLabel.text isEqualToString:@"Create User"]) {
            NSLog(@"Create User: %@", self.nameTextField.text);
            
            [User createNewUserWithName:self.nameTextField.text emailAddress:self.emailTextField.text password:self.passwordTextField.text andDelegate:self];
        }
        
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        
        
    } else {
        NSLog(@"buttons are already lowered");
        [self raiseButtons];
        
    }
    
    
}





- (void)lowerButtonsAndCreateUser:(BOOL)shouldCreateUser {
    
    [UIView animateWithDuration:0.333 animations:^() {
        
        if (shouldCreateUser == NO) {
            self.leftButton.frame = kLeftButtonFrame_Down;
            self.rightButton.frame = kRightButtonFrame_Down;
        } else {
            CGRect lButtonFrame = kLeftButtonFrame_Down;
            lButtonFrame.origin.y = lButtonFrame.origin.y + 40;
            self.leftButton.frame = lButtonFrame;
            
            CGRect rButtonFrame = kRightButtonFrame_Down;
            rButtonFrame.origin.y = rButtonFrame.origin.y + 40;
            self.rightButton.frame = rButtonFrame;
        }
        
    } completion:^(BOOL finished) {
        
        if (shouldCreateUser) {
            //self.emailTextField = [[UITextField alloc] init];
            [self.leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
            [self.rightButton setTitle:@"Create User" forState:UIControlStateNormal];
            self.leftButton.buttonColor = [UIColor alizarinColor];
            self.leftButton.shadowColor = [UIColor pomegranateColor];
            
            self.buttonsAreLowered = YES;
            
            [self showTextFieldsWithNameField:YES];
            
        } else {
            //self.emailTextField = [[UITextField alloc] init];
            [self.leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
            self.leftButton.buttonColor = [UIColor alizarinColor];
            self.leftButton.shadowColor = [UIColor pomegranateColor];
            
            self.buttonsAreLowered = YES;
            
            [self showTextFieldsWithNameField:NO];
            
            
        }

    }];
    
    
}

- (void)raiseButtons {
    
    [UIView animateWithDuration:0.333 animations:^() {
        
        self.emailTextField.alpha = 0;
        self.passwordTextField.alpha = 0;
        self.nameTextField.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.333 animations:^() {
            self.leftButton.frame = kLeftButtonFrame_Up;
            self.rightButton.frame = kRightButtonFrame_Up;
        } completion:^(BOOL finished) {
            [self.leftButton setTitle:@"Create User" forState:UIControlStateNormal];
            [self.rightButton setTitle:@"Log In" forState:UIControlStateNormal];
            self.leftButton.buttonColor = [UIColor turquoiseColor];
            self.leftButton.shadowColor = [UIColor greenSeaColor];
            
            self.buttonsAreLowered = NO;
        }];

    }];
    
}


- (void)showTextFieldsWithNameField:(BOOL)showNameField {
    
    self.emailTextField = [[UITextField alloc] init];
    self.emailTextField.backgroundColor = [UIColor cloudsColor];
    self.emailTextField.frame = CGRectMake(30, 58, 260, 26);
    self.emailTextField.placeholder = @"Email Address...";
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.delegate = self;
    self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:self.emailTextField];
    
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.backgroundColor = [UIColor cloudsColor];
    self.passwordTextField.frame = CGRectMake(30, 94, 260, 26);
    self.passwordTextField.placeholder = @"Password...";
    self.passwordTextField.delegate = self;
    [self.passwordTextField setSecureTextEntry:YES];
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:self.passwordTextField];

    
    if (showNameField == YES) {
        self.nameTextField = [[UITextField alloc] init];
        self.nameTextField.backgroundColor = [UIColor cloudsColor];
        self.nameTextField.frame = CGRectMake(30, 134, 260, 26);
        self.nameTextField.placeholder = @"Username...";
        self.nameTextField.delegate = self;
        self.nameTextField.alpha = 0;
        self.nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.view addSubview:self.nameTextField];
        
    }
    
    self.emailTextField.alpha = 0;
    self.passwordTextField.alpha = 0;
    
    [UIView animateWithDuration:0.333 animations:^() {
        [self.emailTextField setAlpha:1.0];
        [self.passwordTextField setAlpha:1.0];
        if (showNameField == YES) {
            [self.nameTextField setAlpha:1.0];
        }
    }];
    
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    
}


#pragma mark - Backend Actions

- (void)successfullyLoggedIn {
    NSLog(@"logged in successfully!");
    NSLog(@"username: %@",[[User currentUser] name]);
    NSLog(@"apiToken: %@",[[User currentUser] apiToken]);
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app loadRootViewController];
    
}

- (void)loginFailedWithError:(NSError *)error {
    NSLog(@"login failed: %@",[error localizedDescription]);
}

- (void)createNewUserSuccessful {
    NSLog(@"createNewUserSuccessful!");
    NSLog(@"username: %@",[[User currentUser] name]);
    NSLog(@"apiToken: %@",[[User currentUser] apiToken]);
}

- (void)createNewUserFailedWithError:(NSError *)error {
    NSLog(@"createNewUserFailedWithError failed: %@",[error localizedDescription]);
}





@end
