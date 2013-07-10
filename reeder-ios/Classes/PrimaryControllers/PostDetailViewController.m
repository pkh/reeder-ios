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
#import "Utils.h"
#import "PostHeaderContainerView.h"


@interface PostDetailViewController ()

@property (nonatomic) PostHeaderContainerView *headerContainer;

@property (nonatomic) DTAttributedTextView *postContentView;

@property (nonatomic) UIBarButtonItem *markReadButton;
@property (nonatomic) UIBarButtonItem *bookmarkButton;
@property (nonatomic) UIBarButtonItem *actionBarButton;

@end

@implementation PostDetailViewController


- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headerContainer = [[PostHeaderContainerView alloc] init];
    self.headerContainer.frame = CGRectMake(0, 0, 320, 230);
    [self.view addSubview:self.headerContainer];
    self.headerContainer.backgroundColor = [UIColor whiteColor];
    
    //self.postContentView = [[UITextView alloc] init];
    self.postContentView = [[DTAttributedTextView alloc] init];
    [self.postContentView setFrame:CGRectMake(10, (self.headerContainer.frame.size.height+2), 300, (self.view.frame.size.height-88)-self.headerContainer.frame.size.height-2)];
    //[self.postContentView setFont:[UIFont flatFontOfSize:16]];
    //[self.postContentView setTextColor:[UIColor blackColor]];
    //[self.postContentView setEditable:NO];
    
    self.postContentView.textDelegate = self;
    self.postContentView.directionalLockEnabled = YES;
    self.postContentView.showsHorizontalScrollIndicator = NO;
    self.postContentView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
    self.postContentView.backgroundColor = [UIColor whiteColor];
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
    
    // --------------------
    // Set up header container
    // --------------------
    self.headerContainer.postDateString = [NSString stringWithFormat:@"%@",self.postObject.postPublishedDate];
    self.headerContainer.postBlogNameString = self.postObject.parentFeed.feedTitle;
    self.headerContainer.postTitleString = self.postObject.postTitle;

    [self.headerContainer draw];
    
    // --------------------
    // Set up content view data and frame
    // --------------------
    NSData *contentData = [self.postObject.postContent dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *builderOptions = @{DTDefaultFontFamily : @"Georgia",
                                     DTDefaultFontSize : @(16),
                                     DTUseiOS6Attributes : @YES};
    
    DTHTMLAttributedStringBuilder *stringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:contentData
                                                                                               options:builderOptions
                                                                                    documentAttributes:nil];
    
    self.postContentView.attributedString = [stringBuilder generatedAttributedString];
    
    CGRect contentRect = self.postContentView.frame;
    CGFloat contentY = self.headerContainer.frame.size.height;
    CGFloat contentHeight = (self.view.frame.size.height - (self.headerContainer.frame.size.height + 88));
    contentRect.origin.y = contentY;
    contentRect.size.height = contentHeight;
    self.postContentView.frame = contentRect;
    
    
    
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
    [self.delegate markPostReadWithID:self.postObject.postID];
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
