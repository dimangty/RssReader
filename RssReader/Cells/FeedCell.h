//
//  FeedCell.h
//  RssReader
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *feedNameLab;
@property (strong, nonatomic) IBOutlet UILabel *newsCountLab;

@end
