//
//  User.m
//  reeder-ios
//
//  Created by Patrick Hanlon on 6/23/13.
//  Copyright (c) 2013 pkh. All rights reserved.
//

#import "User.h"
#import "LoginViewController.h"



#define kFileName @"User.dat"



@implementation User


static User *currentUser = nil;

+ (User *)currentUser
{
    
    @synchronized(self) {
        if (currentUser == nil) {
            currentUser = [User restore];
        }
    }
    return currentUser;
    
    /*
    //Alternate Method: Using dispatch_once...
    static User *__currentUser;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __currentUser = [User restore];
    });

    return __currentUser;
    */
}


#pragma mark - RK Object Mapping

+ (RKObjectMapping *)objectMapping
{
    // the "key" (on the left) is the JSON field name
    // the "value" (on the right) is the local Cocoa property
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[User class]];
    
    NSDictionary *keyPathsAndAttributes = @{@"id": @"userID",
                                            @"name" : @"name",
                                            @"email" : @"email",
                                            @"api_token" : @"apiToken",
                                            @"created_at" : @"createdDate"};
    
    [mapping addAttributeMappingsFromDictionary:keyPathsAndAttributes];
    
    return mapping;
    
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder
{
    self = [[User alloc] init];
    
    if (self) {
        self.userID = [coder decodeObjectForKey:@"userID"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.email = [coder decodeObjectForKey:@"email"];
        self.apiToken = [coder decodeObjectForKey:@"apiToken"];
        self.createdDate = [coder decodeObjectForKey:@"createdDate"];
    
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.userID forKey:@"userID"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeObject:self.apiToken forKey:@"apiToken"];
    [coder encodeObject:self.createdDate forKey:@"createdDate"];
    
}


#pragma mark - Login/Update/Authenticate User

+ (void)createNewUserWithName:(NSString *)name emailAddress:(NSString *)email password:(NSString *)password andDelegate:(id)delegate {
    
    RKObjectMapping *newUserMapping = [User objectMapping];
    RKObjectMapping *authMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [authMapping addAttributeMappingsFromDictionary:@{@"name" : name,
                                                      @"email" : email,
                                                      @"password" : password}];
    
    
    NSString *fullPathPattern = [NSString stringWithFormat:@"users"];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:authMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:newUserMapping pathPattern:nil keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [responseDescriptor setBaseURL:[RKObjectManager sharedManager].baseURL];
    
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    // clear out any existing descriptors before adding the new ones
    for (RKRequestDescriptor *rd in [manager requestDescriptors]) {
        [manager removeRequestDescriptor:rd];
    }
    for (RKResponseDescriptor *rd in [manager responseDescriptors]) {
        [manager removeResponseDescriptor:rd];
    }
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    
    NSDictionary *params = @{@"[user][email]" : email,
                             @"[user][name]" : name,
                             @"[user][password]" : password};
    
    [manager postObject:nil path:fullPathPattern parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"SUCCESS");
        NSLog(@"%@",[result array]);
        
        User *newUser = (User *)[[result array] objectAtIndex:0];
        User *user = newUser;
        [user save];
        
        
        if ([delegate respondsToSelector:@selector(createNewUserSuccessful)]) {
            [delegate createNewUserSuccessful];
        }
        

    } failure:^ (RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE");
        NSLog(@"---------");
        NSLog(@"%@",[error localizedFailureReason]);
        
        if ([delegate respondsToSelector:@selector(createNewUserFailedWithError:)]) {
            [delegate createNewUserFailedWithError:error];
        }
        
    }];
    
}


+ (void)authenticateWithEmail:(NSString *)email andPassword:(NSString *)password withDelegate:(id)delegate {
    
    RKObjectMapping *newUserMapping = [User objectMapping];
    RKObjectMapping *authMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [authMapping addAttributeMappingsFromDictionary:@{@"email" : email, @"password" : password}];
    
    
    NSString *fullPathPattern = [NSString stringWithFormat:@"authenticate"];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:authMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:newUserMapping pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [responseDescriptor setBaseURL:[RKObjectManager sharedManager].baseURL];
    
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    // clear out any existing descriptors before adding the new ones
    for (RKRequestDescriptor *rd in [manager requestDescriptors]) {
        [manager removeRequestDescriptor:rd];
    }
    for (RKResponseDescriptor *rd in [manager responseDescriptors]) {
        [manager removeResponseDescriptor:rd];
    }
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    
    NSDictionary *params = @{@"email" : email,
                             @"password" : password};
    
    [manager postObject:nil path:fullPathPattern parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"SUCCESS");
        NSLog(@"%@",[result array]);
        
        User *newUser = (User *)[[result array] objectAtIndex:0];
        
        User *user = newUser;
        [user save];
        
        
        
        if ([delegate respondsToSelector:@selector(successfullyLoggedIn)]) {
            [delegate successfullyLoggedIn];
        }
        
        
    } failure:^ (RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE");
        NSLog(@"---------");
        NSLog(@"%@",[error localizedFailureReason]);
        
        if ([delegate respondsToSelector:@selector(loginFailedWithError:)]) {
            [delegate loginFailedWithError:error];
        }
        
    }];
    
    
}

- (BOOL)isLoggedIn {
    if ([self userID] && [self email] && [self apiToken]) {
        return YES;
    } else {
        return NO;
    }
}





#pragma mark - Load/Save/Delete/Restore

- (void)save {
    NSLog(@"user--save");
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *fullFileName = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], kFileName];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:fullFileName error:NULL];
	
	[NSKeyedArchiver archiveRootObject:self toFile:fullFileName];
}

- (void)drop {
    NSLog(@"user--drop");
    
	//currentUser = nil;
	//NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	//NSString *fullFileName = [NSString stringWithFormat:@"%@/user.dat", [paths objectAtIndex:0]];
	
    currentUser = nil;
    
    NSString *fullFileName = [self getUserDataFilePath];
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:fullFileName error:NULL];
    
}

+ (User *)restore {
    NSLog(@"user--restore");
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *fullFileName = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], kFileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullFileName]) return nil;
    
	return [NSKeyedUnarchiver unarchiveObjectWithFile:fullFileName];
}



#pragma mark - File Access

- (NSString *)getUserDataFilePath {
    return [NSString stringWithFormat:@"%@/%@",[self getDocumentsPath], kFileName];
}

- (NSString *)getDocumentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

@end
