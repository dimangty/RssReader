//
//  RssCell.h
//  RssReader
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RssCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLab;
@property (strong, nonatomic) IBOutlet UILabel *dateLab;
@end
