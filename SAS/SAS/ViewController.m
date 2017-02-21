//
//  ViewController.m
//  SAS
//
//  Created by Xes on 19/2/17.
//  Copyright © 2017 Xes. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString* name = NSFullUserName() ;
    NSLog(@"current user %@",name);
    
    [[NetworkManager sharedInstance] loginWithBlock:^(NSString *staffID) {
         
    }];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
