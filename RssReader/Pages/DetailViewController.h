//
//  DetailViewController.h
//  RssReader
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import "RSSItem.h"
#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property(nonatomic, strong) RSSItem *detail;
@end
