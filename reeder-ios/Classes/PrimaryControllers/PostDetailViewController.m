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
#import "NSString+HTML.h"
#import "Feed.h"



@interface PostDetailViewController ()

//@property (nonatomic) UIWebView *contentView;

@property (nonatomic) UILabel *postDateLabel;
@property (nonatomic) UILabel *postTitleLabel;
@property (nonatomic) UILabel *postFeedNameLabel;
//@property (nonatomic) UITextView *postContentView;
@property (nonatomic) DTAttributedTextView *postContentView;

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
    [self.postContentView setFrame:CGRectMake(40, 98, 240, (self.view.frame.size.height-44)-98)];
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

#pragma mark - Events

- (void)linkButtonClicked:(DTLinkButton *)sender {
    [[UIApplication sharedApplication] openURL:sender.URL];
}

@end
