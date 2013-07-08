//
//  PostCellActionDelegate.h
//  reeder-ios
//
//  Created by Patrick Hanlon on 7/8/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PostCellActionDelegate <NSObject>

@required
- (void)markCellAsRead:(UITableViewCell *)cell;

@end
