//
//  FeedsViewController.m
//  RssReader
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import "FeedsViewController.h"
#import "NewsViewController.h"
#import "FeedCell.h"
#import "StorageManager.h"

@interface FeedsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *feedsTable;

@end

@implementation FeedsViewController
{
    NSMutableArray *feeds;
}

#pragma mark init
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    feeds = [[StorageManager sharedManager] getRssFeeds];
   
}

- (void)viewDidAppear:(BOOL)animated {
    for (RssFeed *rssFeed in feeds) {
        rssFeed.newsCount = [[StorageManager sharedManager] countForFeed:rssFeed.feedID];
    }
    
    [_feedsTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [feeds count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RssFeed *rssFeed = [feeds objectAtIndex:indexPath.row];
    FeedCell *feedCell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
    feedCell.feedNameLab.text = rssFeed.feedName;
    feedCell.newsCountLab.text = [@(rssFeed.newsCount) stringValue];
    
    return feedCell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [_feedsTable indexPathForCell:sender];
    RssFeed *feed = [feeds objectAtIndex:indexPath.row];
    NewsViewController *vc = segue.destinationViewController;
    [vc setCurrentFeed:feed];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
