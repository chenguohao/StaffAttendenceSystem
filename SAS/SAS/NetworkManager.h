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
- (void)fetchAttencyListWithStaffID:(NSString*)staffID
                              Block:(void(^)(NSArray* attenArray))block;

- (void)fetchReasonTypeWithBlock:(void(^)(NSArray* attenArray))block;
- (void)fetchReasonTempWithBlock:(void(^)(NSArray* attenArray))block;

- (void)submitReasonType:(NSString*)reason
                  Detail:(NSString*)detail
                 AttendencID:(NSString*)staffID
                   Block:(void(^)(NSString* result))block;
@end
