//
//  NetworkManager.m
//  SAS
//
//  Created by Xes on 19/2/17.
//  Copyright © 2017 Xes. All rights reserved.
//

#import "NetworkManager.h"


#define ROOT_URL  @"http://203.127.83.160/corp/staff-back"
#define LOGINURL  @"/public/api/org/1/attendance/time"

#define TOKEN     @"bced93b63e1a4373b3313096b0da77d9"

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

- (void)loginWithBlock:(void(^)(NSString* staffID))block{
    NSString* URL_Login = [NSString stringWithFormat:@"%@%@",ROOT_URL,LOGINURL];
    NSURL * url = [NSURL URLWithString:URL_Login];
    NSMutableURLRequest *request  = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString* token = [NSString stringWithFormat:@"bearer %@",TOKEN];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
   
    NSString* content = [NSString stringWithFormat:@"domain_id=%@",self.domainID];
    NSData*   data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary* resultDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if (block) {
            block(@"aa");
        }
        
    }];
    
    [task resume];
    
    
    
    
}



@end
