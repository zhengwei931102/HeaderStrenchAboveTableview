//
//  XuanTingViewController.m
//  HeaderStrenchAboveTableview
//
//  Created by zw on 2019/6/9.
//  Copyright © 2019 zw. All rights reserved.
//

#import "XuanTingViewController.h"
#import "JXPagerListRefreshView.h"
#import "TableView.h"

@interface XuanTingViewController ()<JXCategoryViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) UIView *naviBGView;//44或者20，悬停时的上部view
@end

@implementation XuanTingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    _titles = @[@"能力", @"爱好", @"队友"];
    _userHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    _userHeaderView.backgroundColor = [UIColor orangeColor];
    
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    self.categoryView.titles = self.titles;
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
    self.categoryView.titleColor = [UIColor blackColor];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.titleLabelZoomScale = 1.2;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
    lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
    self.categoryView.indicators = @[lineView];
    
    _pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    self.pagerView.mainTableView.gestureDelegate = self;
    self.pagerView.pinSectionHeaderVerticalOffset = 44;
    [self.view addSubview:self.pagerView];
    
    self.categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
    
    //悬停的上部空白view
    self.naviBGView = [[UIView alloc] init];
    self.naviBGView.alpha = 0;
    self.naviBGView.backgroundColor = [UIColor whiteColor];
    self.naviBGView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    [self.view addSubview:self.naviBGView];
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.pagerView.frame = self.view.bounds;
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.userHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return 200;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 50;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    TableView *table = [[TableView alloc] init];
    table.naviController = self.navigationController;
    table.segmentNum = index;
    return table;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    NSLog(@"%ld=====点击或滑动",(long)index);
    
    
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickedItemContentScrollViewTransitionToIndex:(NSInteger)index {
    //请务必实现该方法
    //因为底层触发列表加载是在代理方法：`- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath`回调里面
    //所以，如果当前有5个item，当前在第1个，用于点击了第5个。categoryView默认是通过设置contentOffset.x滚动到指定的位置，这个时候有个问题，就会触发中间2、3、4的cellForItemAtIndexPath方法。
    //如此一来就丧失了延迟加载的功能
    //所以，如果你想规避这样的情况发生，那么务必按照这里的方法处理滚动。
    [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    //如果你想相邻的两个item切换时，通过有动画滚动实现。未相邻的两个item直接切换，可以用下面这段代码
    /*
     NSInteger diffIndex = labs(categoryView.selectedIndex - index);
     if (diffIndex > 1) {
     [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
     }else {
     [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
     }
     */
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}


- (void)mainTableViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y<=0){
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    CGFloat thresholdDistance = 200-44;
    CGFloat percent = scrollView.contentOffset.y/thresholdDistance;
    percent = MAX(0, MIN(1, percent));
    self.naviBGView.alpha = percent;
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
