//
//  NetworkManager.h
//  RssReader
//
//  Created by dima on 15.03.18.
//  Copyright © 2018 dima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

typedef void (^WaitCompletion)(NetworkStatus networkStatus);
@interface NetworkManager : NSObject
@property(strong, nonatomic) UIAlertController *noInternetAlertView;
@property(assign, nonatomic) NetworkStatus networkStatus;
@property(strong, nonatomic) Reachability *hostReachability;

+ (NetworkManager *)defaultNetworkManager;
- (void)showNoInternetAlertView;
- (void)waitAvaible:(WaitCompletion)avaible;
@end
