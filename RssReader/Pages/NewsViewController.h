//
//  NewsViewController.h
//  RssReader
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RssFeed.h"

@interface NewsViewController : UIViewController
@property(nonatomic, strong) RssFeed *currentFeed;
@end
