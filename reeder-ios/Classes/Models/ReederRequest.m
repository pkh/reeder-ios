//
//  ReederRequest.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/28/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "ReederRequest.h"
#import "User.h"


@implementation ReederRequest

- (id)initWithURL:(NSURL *)URL {
    if (self = [super initWithURL:URL]) {
        [self setValue:[[User currentUser] apiToken] forHTTPHeaderField:@"X-API-TOKEN"];
    }
    return self;
}

@end
