//
//  DataController.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/26/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "DataController.h"
#import "Feed.h"
#import "User.h"
#import "RootViewController.h"


#define kFileName @"ReederFeedData.dat"


@interface DataController ()

@end


@implementation DataController


- (id)init {
    if (self = [super init]) {
        self.feedsArray = [[NSMutableArray alloc] init];
        [self load];
        
    }
    return self;
}





static DataController *sharedObject = nil;

+ (DataController *)sharedObject {
    
    @synchronized(self) {
        if (sharedObject == nil) {
            sharedObject = [[DataController alloc] init];
        }
    }
    return sharedObject;
    /*
    static DataController *__controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __controller = [DataController loadDataControllerFromDisk];
    });
    
    return __controller;
    */ 
}


#pragma mark - Save/Load/Delete

- (void)save {
    NSLog(@"DataController--save");
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *fullFileName = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], kFileName];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:fullFileName error:NULL];
	
	[NSKeyedArchiver archiveRootObject:self.feedsArray toFile:fullFileName];
}

- (void)load {
    NSLog(@"DataController--load");
    NSArray *archiveFromDisk = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getFeedDataFilePath]];
    int numberOfGames = [archiveFromDisk count];
    for (int x = 0; x < numberOfGames; x++) {
        [self.feedsArray addObject:(Feed *)[archiveFromDisk objectAtIndex:x]];
    }
}

- (void)drop {
    NSLog(@"DataController--drop");
    NSString *fullFileName = [self getFeedDataFilePath];
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:fullFileName error:NULL];
}





#pragma mark -

- (Feed *)feedAtIndex:(NSInteger)idx {
    return [self.feedsArray objectAtIndex:idx];
}



- (NSInteger)numberOfFeeds {
    return [self.feedsArray count];
}

- (NSInteger)numberOfPostsForFeed:(NSNumber *)feedID {
    
}

- (NSInteger)numberOfUnreadPostsForFeed:(NSNumber *)feedID {
    
}

- (NSMutableArray *)postsForFeed:(NSNumber *)feedID {
    
}

- (Feed *)feedWithID:(NSNumber *)feedID {
    
}


#pragma mark - File Access

- (NSString *)getFeedDataFilePath {
    return [NSString stringWithFormat:@"%@/%@",[self getDocumentsPath], kFileName];
}

- (NSString *)getDocumentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}


#pragma mark - Networking Code

- (void)loadFeedsFromServerWithDelegate:(id)delegate {
    
    NSString *fullPathPattern = [NSString stringWithFormat:@"feeds"];
    
    RKObjectMapping *feedMapping = [Feed objectMapping];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:feedMapping pathPattern:fullPathPattern keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [responseDescriptor setBaseURL:[[RKObjectManager sharedManager] baseURL]];
    
    NSDictionary *params = @{@"api_token": [[User currentUser] apiToken]};
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager addResponseDescriptor:responseDescriptor];
    
    __weak __typeof(&*self)weakSelf = self;		// make weak reference
    
    [manager getObject:nil path:fullPathPattern parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;		// make strong ref by reading back in
        
        NSLog(@"loadFeedsFromServerWithDelegate--SUCCESS");
        
        //strongSelf.feedsArray = [NSMutableArray arrayWithArray:[result array]];
        
        @synchronized (strongSelf) {
            [strongSelf drop];
            strongSelf.feedsArray = [NSMutableArray arrayWithArray:[result array]];
            [strongSelf save];
        }
        
        
        if ([delegate respondsToSelector:@selector(feedsReloadedSuccessfully)]) {
            [delegate feedsReloadedSuccessfully];
        }
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"loadFeedsFromServerWithDelegate--FAILURE");
        NSLog(@"%@",[error localizedFailureReason]);
        
        if ([delegate respondsToSelector:@selector(feedReloadFailedWithError:)]) {
            [delegate feedReloadFailedWithError:error];
        }
        
     
    }];
    
}


@end
