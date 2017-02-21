//
//  NetworkManager.h
//  SAS
//
//  Created by Xes on 19/2/17.
//  Copyright © 2017 Xes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject
+ (instancetype)sharedInstance;
- (void)loginWithBlock:(void(^)(NSString* staffID))block;
@end
