//
//  DetailViewController.m
//  RssReader
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property(strong, nonatomic) IBOutlet UILabel *titleLab;
@property(strong, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;
@property(strong, nonatomic) IBOutlet UILabel *descriptionLab;
@end

@implementation DetailViewController
#pragma mark init
- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLab.text = _detail.title;
    _descriptionLab.text = _detail.descriptionText;
    _descriptionHeightConstraint.constant =
    [self calculateStringHeight:_detail.descriptionText
                           font:_descriptionLab.font
                      maxHeight:self.view.frame.size.height * 0.6];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions
- (IBAction)openLink:(id)sender {
    NSURL *url = [NSURL URLWithString:_detail.link];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark Private
- (float)calculateStringHeight:(NSString *)text
                          font:(UIFont *)font
                     maxHeight:(CGFloat)maxHeight {
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraph
                                 };
    
    CGRect box = [text
              boundingRectWithSize:CGSizeMake(_descriptionLab.frame.size.width, CGFLOAT_MAX)
                  options:(NSStringDrawingUsesLineFragmentOrigin)
                  attributes:attributes
                  context:nil];
    
    float height = box.size.height + 10;
    
    if (height > maxHeight) {
        height = maxHeight;
    }
    
    return height;
}






/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little
 preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
