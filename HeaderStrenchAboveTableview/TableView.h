//
//  TableView.h
//  HeaderStrenchAboveTableview
//
//  Created by zw on 2019/6/9.
//  Copyright © 2019 zw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "MJRefresh.h"
NS_ASSUME_NONNULL_BEGIN

@interface TableView : UIView<JXPagerViewListViewDelegate,UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UINavigationController *naviController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic,assign)NSInteger segmentNum;
@end

NS_ASSUME_NONNULL_END
