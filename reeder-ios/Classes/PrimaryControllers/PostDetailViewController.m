//
//  PostDetailViewController.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/27/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "PostDetailViewController.h"

@interface PostDetailViewController ()

@property (nonatomic) UIWebView *contentView;

@end

@implementation PostDetailViewController
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
    
    self.contentView = [[UIWebView alloc] init];
    [self.contentView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44)];
    [self.contentView loadHTMLString:self.postObject.postContent baseURL:nil];
    [self.contentView setScalesPageToFit:YES];
    [self.view addSubview:self.contentView];
    
    
    
    
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

@end
