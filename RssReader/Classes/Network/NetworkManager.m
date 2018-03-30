//
//  NetworkManager.m
//  RssReader
//
//  Created by dima on 15.03.18.
//  Copyright © 2018 dima. All rights reserved.
//

#import "NetworkManager.h"
@interface NetworkManager()
@property(strong, nonatomic) WaitCompletion block;
@end

@implementation NetworkManager
static NetworkManager* defaultNetworkManager = nil;

+(NetworkManager*) defaultNetworkManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultNetworkManager = [[self class] new];
        [defaultNetworkManager initReachability];
        [defaultNetworkManager initNoInternetAlertView];
    });
    return defaultNetworkManager;
}

#pragma mark
#pragma mark Reachability Init And Methods
-(void)initReachability{
    _hostReachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [_hostReachability startNotifier];
    [self updateInterfaceWithReachability: _hostReachability];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

- (void)updateInterfaceWithReachability: (Reachability*) currentReachability{
    NSLog(@"call updateInterfaceWithReachability");
    self.networkStatus = [currentReachability currentReachabilityStatus];
    
    if(self.networkStatus && _block != nil) {
        _block(self.networkStatus);
        _block = nil;
    }
}

- (void) reachabilityChanged: (NSNotification* )note {
    NSLog(@"call reachabilityChanged");
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
    
    
}

- (void)waitAvaible:(WaitCompletion)avaible
{
    _block = avaible;
    
}

#pragma mark
#pragma mark No Internrt Alert
-(void) initNoInternetAlertView{
    _noInternetAlertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"No_Connection"]];
    [image setContentMode:UIViewContentModeScaleAspectFit];
    
    UIViewController *contentController = [[UIViewController alloc] init];
    contentController.view.frame = CGRectMake(0, 150, 300, 300);
    [contentController.view addSubview:image];
    
    [_noInternetAlertView setValue:contentController forKey:@"contentViewController"];
    
    [_noInternetAlertView.view addConstraint:[NSLayoutConstraint constraintWithItem:contentController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1. constant:image.frame.size.width]];
    
    [_noInternetAlertView.view addConstraint:[NSLayoutConstraint constraintWithItem:contentController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1. constant:150.]];
    
    image.frame = CGRectMake(image.frame.origin.x, (150 - image.frame.size.height) / 2, image.frame.size.width, image.frame.size.height);
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [_noInternetAlertView addAction:defaultAction];
}

-(void) showNoInternetAlertView{
    [[[[UIApplication sharedApplication] delegate] window].rootViewController presentViewController:_noInternetAlertView animated:YES completion:^{
        
    }];
}
@end
