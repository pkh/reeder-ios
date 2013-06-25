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


#define kReederLabelFrame CGRectMake(10, 132, 300, 44)

#define kLeftButtonFrame_Up CGRectMake(10, 220, 145, 44)
#define kLeftButtonFrame_Down CGRectMake(10, 380, 145, 44)
#define kRightButtonFrame_Up CGRectMake(165, 220, 145, 44)
#define kRightButtonFrame_Down CGRectMake(165, 380, 145, 44)


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

- (void)leftButtonAction:(id)sender {
    NSLog(@"left button");
    
    if (self.buttonsAreLowered && [self.leftButton.titleLabel.text isEqualToString:@"Cancel"]) {
        // --------------------------------------------------
        // RETURN EVERYTHING TO DEFAULT POSITION AND LABELS
        // --------------------------------------------------
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
        
    } else {
        
        if (!self.buttonsAreLowered) {
            [UIView animateWithDuration:0.333 animations:^() {
                
                self.leftButton.frame = kLeftButtonFrame_Down;
                self.rightButton.frame = kRightButtonFrame_Down;

            } completion:^(BOOL finished) {
                
                //self.emailTextField = [[UITextField alloc] init];
                [self.leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
                [self.rightButton setTitle:@"Create User" forState:UIControlStateNormal];
                self.leftButton.buttonColor = [UIColor alizarinColor];
                self.leftButton.shadowColor = [UIColor pomegranateColor];
                
                self.buttonsAreLowered = YES;
                
                [self showTextFieldsWithNameField:YES];
            }];
        }
        
    }
    
}

- (void)rightButtonAction:(id)sender {
    NSLog(@"log in");
    
    if (!self.buttonsAreLowered) {
        
        [UIView animateWithDuration:0.333 animations:^() {
            
            self.leftButton.frame = kLeftButtonFrame_Down;
            self.rightButton.frame = kRightButtonFrame_Down;

        } completion:^(BOOL finished) {
            
            //self.emailTextField = [[UITextField alloc] init];
            [self.leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
            self.leftButton.buttonColor = [UIColor alizarinColor];
            self.leftButton.shadowColor = [UIColor pomegranateColor];
            
            self.buttonsAreLowered = YES;
            
            [self showTextFieldsWithNameField:NO];
            
        }];
        
    } else {
        NSLog(@"buttons are already lowered");
    }
    
    
    
}


- (void)showTextFieldsWithNameField:(BOOL)showNameField {
 
    self.emailTextField = [[UITextField alloc] init];
    self.emailTextField.backgroundColor = [UIColor redColor];
    self.emailTextField.frame = CGRectMake(30, 190, 260, 30);
    self.emailTextField.placeholder = @"Email Address...";
    self.emailTextField.delegate = self;
    [self.view addSubview:self.emailTextField];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.backgroundColor = [UIColor greenColor];
    self.passwordTextField.frame = CGRectMake(30, 230, 260, 30);
    self.passwordTextField.placeholder = @"Password...";
    self.passwordTextField.delegate = self;
    [self.passwordTextField setSecureTextEntry:YES];
    [self.view addSubview:self.passwordTextField];

    if (showNameField == YES) {
        self.nameTextField = [[UITextField alloc] init];
        self.nameTextField.frame = CGRectMake(30, 284, 260, 30);
        self.nameTextField.placeholder = @"Username...";
        self.nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
        self.nameTextField.delegate = self;
        self.nameTextField.alpha = 0;
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

@end
