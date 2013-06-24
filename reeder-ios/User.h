//
//  User.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/23/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@interface User : NSObject

@property (nonatomic) NSNumber *userID;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *apiToken;
@property (nonatomic) NSDate *createdDate;


+ (User *)currentUser;

+ (void)loginWithName:(NSString *)name emailAddress:(NSString *)email password:(NSString *)password andDelegate:(id)delegate;
+ (void)authenticateWithEmail:(NSString *)email andPassword:(NSString *)password withDelegate:(id)delegate;

- (BOOL)isLoggedIn;

@end
