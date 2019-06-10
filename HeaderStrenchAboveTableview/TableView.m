//
//  TableView.m
//  HeaderStrenchAboveTableview
//
//  Created by zw on 2019/6/9.
//  Copyright © 2019 zw. All rights reserved.
//

#import "TableView.h"
#import "ViewController.h"
@implementation TableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:self.tableView];
        //刷新
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(more)];
//        [self.tableView.mj_header beginRefreshing];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    cell.textLabel.text = @"cell";
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController *vc = [[ViewController alloc] init];
    [self.naviController pushViewController:vc animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}
//下拉刷新
-(void)refresh{
    //获取数据根据self.segmentNum
    NSLog(@"%ld++++++++++++++++++++",(long)self.segmentNum);
    [self.tableView.mj_header endRefreshing];
    
}
//上拉加载
- (void)more{
    //获取数据
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listDidAppear {
    NSLog(@"listDidAppear");
    //每次点击segment都刷新
    [self.tableView.mj_header beginRefreshing];
}

- (void)listDidDisappear {
    NSLog(@"listDidDisappear");
}




@end

