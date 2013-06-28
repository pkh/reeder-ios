//
//  AddFeedViewController.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/26/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "AddFeedViewController.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/UIFont+FlatUI.h>
#import <FlatUIKit/FUIButton.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Feed.h"
#import "ReederAPIClient.h"


#define kSUCCESS_ALERTVIEW 0
#define kFAILURE_ALERTVIEW 1



@interface AddFeedViewController ()
@property (nonatomic) UITextField *urlTextField;
@property (nonatomic) FUIButton *saveFeedButton;
@end

@implementation AddFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"Add Feed"];
    
    self.urlTextField = [[UITextField alloc] init];
    self.urlTextField.backgroundColor = [UIColor cloudsColor];
    self.urlTextField.frame = CGRectMake(30, 44, 260, 26);
    self.urlTextField.placeholder = @"Type or Paste Feed URL...";
    self.urlTextField.keyboardType = UIKeyboardTypeURL;
    self.urlTextField.font = [UIFont flatFontOfSize:20];
    self.urlTextField.delegate = self;
    self.urlTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:self.urlTextField];
    
    self.saveFeedButton = [FUIButton buttonWithType:UIButtonTypeCustom];
    self.saveFeedButton.frame = CGRectMake(30, 90, 260, 44);
    self.saveFeedButton.buttonColor = [UIColor asbestosColor];
    self.saveFeedButton.shadowColor = [UIColor wetAsphaltColor];
    self.saveFeedButton.shadowHeight = 3.0f;
    self.saveFeedButton.cornerRadius = 6.0f;
    self.saveFeedButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.saveFeedButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.saveFeedButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    [self.saveFeedButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.saveFeedButton setTitle:@"Add New Feed" forState:UIControlStateNormal];
    [self.saveFeedButton addTarget:self action:@selector(addNewFeedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveFeedButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doneButtonAction:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Bar Button Actions

- (void)doneButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Other Button Actions

- (void)addNewFeedButtonAction:(id)sender {
    NSLog(@"add new feed");
    
#warning add some more sanitizing here
    if (self.urlTextField.text.length > 0) {
        [self.urlTextField resignFirstResponder];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [ReederAPIClient subscribeToNewFeedWithFeedURL:self.urlTextField.text andDelegate:self];
    }
}


#pragma mark - Networking Callbacks

- (void)newSubscriptionSuccessful {
    
    [SVProgressHUD dismiss];
    
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"Subscribed Successfully" message:@"Go ahead and refresh your feeds to see your new subscription." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    alertView.tag = kSUCCESS_ALERTVIEW;
    [alertView show];
}

- (void)newSubscriptionFailedWithError:(NSError *)error {
    
    [SVProgressHUD dismiss];
    
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"Error!" message:@"There was an error adding your new feed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    alertView.tag = kFAILURE_ALERTVIEW;
    [alertView show];
    
}


#pragma mark - FUIAlertView Delegate

- (void)alertView:(FUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == kSUCCESS_ALERTVIEW) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


@end
