//
//  PostDetailViewController.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/27/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <DTCoreText/DTCoreText.h>


@interface PostDetailViewController : UIViewController <DTAttributedTextContentViewDelegate>

@property (nonatomic) Post *postObject;

@end
