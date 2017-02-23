//
//  NetworkManager.m
//  SAS
//
//  Created by Xes on 19/2/17.
//  Copyright © 2017 Xes. All rights reserved.
//

#import "NetworkManager.h"


#define ROOT_URL          @"http://203.127.83.160/corp/staff-back"
#define LOGIN_URL         @"/public/api/org/1/attendance/time"
#define FETCH_LIST_URL    @"/public/api/attendances/{staff_id}/late?org_id=1"
#define REASON_TYPE_URL   @"/public/api/org/1/conf/attendance/reason"
#define REASON_TEMP_URL   @"/public/api/org/1/conf/attendance/reason/template"
#define SUBMIT_URL        @"/public/api/org/1/attendance/{attendenc_id}/reason"


#define TOKEN     @"bced93b6-3e1a-4373-b331-3096b0da77d9"

static NetworkManager* sharedManager;

@interface NetworkManager()
@property (nonatomic) NSString* domainID;
@end

@implementation NetworkManager

+ (instancetype)sharedInstance{
  static  dispatch_once_t tokenOnce;
  dispatch_once(&tokenOnce, ^{
      sharedManager = [[NetworkManager alloc] init];
  });
    return sharedManager;
}

- (NSString*)domainID{
    return @"piconew";
}

- (void)loginWithBlock:(void(^)(NSString* result))block{
    NSString* URL_Login = [NSString stringWithFormat:@"%@%@",ROOT_URL,LOGIN_URL];
    NSString* content = [NSString stringWithFormat:@"domain_id=%@",self.domainID];
    [self postRequestWithURL:URL_Login content:content Block:block];
}

- (void)fetchAttencyListWithStaffID:(NSString*)staffID
                              Block:(void(^)(NSArray* attenArray))block{
    NSString* strUrl = [NSString stringWithFormat:@"%@%@",ROOT_URL,FETCH_LIST_URL];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"{staff_id}" withString:staffID];
    [self getRequestWithURL:strUrl Block:block];
}




- (void)fetchReasonTypeWithBlock:(void(^)(NSArray* attenArray))block{
    NSString* strUrl = [NSString stringWithFormat:@"%@%@",ROOT_URL,REASON_TYPE_URL];
    [self getRequestWithURL:strUrl Block:block];
}

- (void)fetchReasonTempWithBlock:(void(^)(NSArray* attenArray))block{
    NSString* strUrl = [NSString stringWithFormat:@"%@%@",ROOT_URL,REASON_TEMP_URL];
    [self getRequestWithURL:strUrl
                      Block:block];
}


- (void)submitReasonType:(NSString*)reason
                  Detail:(NSString*)detail
                 AttendencID:(NSString*)attendenc_ID
                   Block:(void(^)(NSString* result))block{
    NSString* strUrl = [NSString stringWithFormat:@"%@%@",ROOT_URL,SUBMIT_URL];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"{attendenc_id}" withString:attendenc_ID];
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setValue:reason forKey:@"reason_type"];
    [dict setValue:detail forKey:@"reason_detail"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString* content = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    content = [NSString stringWithFormat:@"reason_type=Late&reason_detail=raining"];
    [self postRequestWithURL:strUrl content:content Block:block];
}

#pragma mark - GET

- (void)getRequestWithURL:(NSString*)strUrl
                    Block:(void(^)(NSArray* attenArray))block{
    NSURL * url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request  = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    [request setValue:TOKEN forHTTPHeaderField:@"X-ApiKey"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        if (block) {
            block(array);
        }
    }];
    [task resume];
}

#pragma mark - POST
- (void)postRequestWithURL:(NSString*)strUrl
                   content:(NSString*)content
                     Block:(void(^)(NSString * result))block{
    NSURL * url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request  = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    [request setValue:TOKEN forHTTPHeaderField:@"X-ApiKey"];
    NSData*   data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
        if (block) {
            block(result);
        }
    }];
    [task resume];
}
@end
