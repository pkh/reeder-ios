//
//  LoginViewController.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/24/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

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
    
    UILabel *reederLabel = [[UILabel alloc] init];
    [reederLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [reederLabel setTextAlignment:NSTextAlignmentCenter];
    [reederLabel setFont:[UIFont boldSystemFontOfSize:24]];
    [reederLabel setText:@"reeder.io"];
    [self.view addSubview:reederLabel];
    
    NSLayoutConstraint *reederLabelConstraint = [NSLayoutConstraint constraintWithItem:reederLabel
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0
                                                                   constant:1.0];
    
    [self.view addConstraint:reederLabelConstraint];
    
    
    UIButton *createUserButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [createUserButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [createUserButton setTitle:@"Create User" forState:UIControlStateNormal];
    [createUserButton addTarget:self action:@selector(createUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createUserButton];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    
    NSDictionary *buttonsDictionary = NSDictionaryOfVariableBindings(createUserButton, loginButton);
    
    NSMutableArray *buttonConstraints = [[NSMutableArray alloc] init];
    [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[createUserButton]-10-[loginButton(==createUserButton)]-10-|"
                                                                                   options:NSLayoutFormatAlignAllBaseline
                                                                                   metrics:nil
                                                                                     views:buttonsDictionary]];
    
    [buttonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-132-[reederLabel(44)]-44-[createUserButton]"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:NSDictionaryOfVariableBindings(reederLabel, createUserButton, loginButton)]];
    
    [self.view addConstraints:buttonConstraints];
    
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

- (void)createUserButtonAction:(id)sender {
    NSLog(@"create user");
}

- (void)loginButtonAction:(id)sender {
    NSLog(@"log in");
}


@end
