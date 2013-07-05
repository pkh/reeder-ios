//
//  PostDetailViewController.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/27/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "PostDetailViewController.h"
#import <FlatUIKit/UIFont+FlatUI.h>
#import <FlatUIKit/UIColor+FlatUI.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSString+HTML.h"
#import "Feed.h"
#import "ReederAPIClient.h"



@interface PostDetailViewController ()

//@property (nonatomic) UIWebView *contentView;

@property (nonatomic) UILabel *postDateLabel;
@property (nonatomic) UILabel *postTitleLabel;
@property (nonatomic) UILabel *postFeedNameLabel;
//@property (nonatomic) UITextView *postContentView;
@property (nonatomic) DTAttributedTextView *postContentView;

@property (nonatomic) UIBarButtonItem *markReadButton;
@property (nonatomic) UIBarButtonItem *bookmarkButton;
@property (nonatomic) UIBarButtonItem *actionBarButton;

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.postDateLabel = [[UILabel alloc] init];
    [self.postDateLabel setFrame:CGRectMake(0, 0, 320, 24)];
    [self.postDateLabel setTextAlignment:NSTextAlignmentCenter];
    [self.postDateLabel setFont:[UIFont boldFlatFontOfSize:10]];
    [self.postDateLabel setTextColor:[UIColor darkGrayColor]];
    [self.view addSubview:self.postDateLabel];
    
    self.postFeedNameLabel = [[UILabel alloc] init];
    [self.postFeedNameLabel setFrame:CGRectMake(0, 24, 320, 24)];
    [self.postFeedNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.postFeedNameLabel setFont:[UIFont boldFlatFontOfSize:12]];
    [self.postFeedNameLabel setTextColor:[UIColor darkGrayColor]];
    [self.view addSubview:self.postFeedNameLabel];
    
    self.postTitleLabel = [[UILabel alloc] init];
    [self.postTitleLabel setFrame:CGRectMake(10, 48, 300, 50)];
    [self.postTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.postTitleLabel setBackgroundColor:[UIColor cloudsColor]];
    [self.postTitleLabel setFont:[UIFont boldFlatFontOfSize:16]];
    [self.postTitleLabel setNumberOfLines:3];
    [self.postTitleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.postTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.postTitleLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:self.postTitleLabel];
    /*
    self.contentView = [[UIWebView alloc] init];
    [self.contentView setFrame:CGRectMake(40, 90, 240, (self.view.frame.size.height-44)-90)];
    [self.contentView loadHTMLString:self.postObject.postContent baseURL:nil];
    [self.contentView setScalesPageToFit:YES];
    [self.view addSubview:self.contentView];
    */
    
    
    //self.postContentView = [[UITextView alloc] init];
    self.postContentView = [[DTAttributedTextView alloc] init];
    [self.postContentView setFrame:CGRectMake(40, 98, 240, (self.view.frame.size.height-44)-98-54)];
    //[self.postContentView setFont:[UIFont flatFontOfSize:16]];
    //[self.postContentView setTextColor:[UIColor blackColor]];
    //[self.postContentView setEditable:NO];
    
    self.postContentView.textDelegate = self;
    self.postContentView.directionalLockEnabled = YES;
    self.postContentView.showsHorizontalScrollIndicator = NO;
    self.postContentView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    [self.view addSubview:self.postContentView];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController setToolbarHidden:NO];
    self.bookmarkButton = [[UIBarButtonItem alloc] initWithTitle:@"Bookmark" style:UIBarButtonItemStyleBordered target:self action:@selector(bookmarkButtonAction:)];
    self.markReadButton = [[UIBarButtonItem alloc] initWithTitle:@"Mark Read" style:UIBarButtonItemStyleBordered target:self action:@selector(markReadButtonAction:)];
    self.actionBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonAction:)];
    [self.actionBarButton setStyle:UIBarButtonItemStyleBordered];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[self.bookmarkButton, spacer, self.actionBarButton, spacer, self.markReadButton];
    
    
    self.postDateLabel.text = [NSString stringWithFormat:@"%@",self.postObject.postPublishedDate];
    self.postTitleLabel.text = self.postObject.postTitle;
    self.postFeedNameLabel.text = self.postObject.parentFeed.feedTitle;
    
    
    NSData *contentData = [self.postObject.postContent dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *builderOptions = @{DTDefaultFontFamily: @"Helvetica",
                                     DTUseiOS6Attributes: @YES};
    
    DTHTMLAttributedStringBuilder *stringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:contentData
                                                                                               options:builderOptions
                                                                                    documentAttributes:nil];
    
    //self.postContentView.attributedText = [stringBuilder generatedAttributedString];
    self.postContentView.attributedString = [stringBuilder generatedAttributedString];
    
    //self.postContentView.text = [self parseHTMLToDisplayableText:self.postObject.postContent];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES];
}


#pragma mark - text parsing and events

- (NSString *)parseHTMLToDisplayableText:(NSString *)htmlText {
    
    NSString *parsedText = [NSString new];
    
    NSMutableString *mutableParsedText = [NSMutableString stringWithString:parsedText];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img[^>]*>"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    [regex replaceMatchesInString:mutableParsedText
                          options:0
                            range:NSMakeRange(0, mutableParsedText.length)
                     withTemplate:@"\n<IMAGE>\n"];
    
    return mutableParsedText;
}




- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)framecontext {
    DTLinkButton *linkButton = [[DTLinkButton alloc] initWithFrame:framecontext];
    linkButton.URL = url;
    [linkButton addTarget:self
                   action:@selector(linkButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    
    return linkButton;
    
    
}


- (void)linkButtonClicked:(DTLinkButton *)sender {
    [[UIApplication sharedApplication] openURL:sender.URL];
}


#pragma mark - Bar Button Actions

- (void)bookmarkButtonAction:(id)sender {
    #warning add some check to see if it's already been bookmarked?
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [ReederAPIClient markPostAsBookmarked:[self.postObject postID] withDelegate:self];
}

- (void)markReadButtonAction:(id)sender {

#warning add some check to see if it's already been read?
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [ReederAPIClient markPostAsRead:[self.postObject postID] withDelegate:self];

}

- (void)actionButtonAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.postObject.postURL]];
}

#pragma mark - Delegate Callbacks

- (void)postMarkedReadSuccessfully {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [SVProgressHUD showSuccessWithStatus:@"Marked As Read!"];
    [self.markReadButton setEnabled:NO];
}


- (void)errorMarkingPostAsRead:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"error marking read: %@",[error localizedDescription]);
    [SVProgressHUD showSuccessWithStatus:@"Error Marking Read!"];
}





- (void)postBookmarkedSuccessfully {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [SVProgressHUD showSuccessWithStatus:@"Bookmarked!"];
    [self.bookmarkButton setEnabled:NO];
}


- (void)errorBookmarkingPost:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [SVProgressHUD showSuccessWithStatus:@"Error Bookmarking Post!"];
}





@end
