//
//  ViewController.m
//  HeaderStrenchAboveTableview
//
//  Created by zw on 2019/6/6.
//  Copyright © 2019 zw. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<JXCategoryViewDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 50)];
    self.categoryView.titles = @[@"螃蟹", @"麻辣小龙虾", @"苹果",@"螃蟹1", @"麻辣小龙虾1", @"苹果1",@"螃蟹2", @"麻辣小龙虾2", @"苹果2"];
    self.categoryView.titleSelectedColor = [UIColor blueColor];
    
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = [UIColor greenColor];
    lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
    self.categoryView.indicators = @[lineView];
    
}

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index;{
    NSLog(@"%ld+++++++",(long)index);
}


@end
