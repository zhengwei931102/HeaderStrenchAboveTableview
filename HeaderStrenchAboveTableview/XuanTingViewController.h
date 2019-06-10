//
//  XuanTingViewController.h
//  HeaderStrenchAboveTableview
//
//  Created by zw on 2019/6/9.
//  Copyright © 2019 zw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "JXCategoryView.h"
NS_ASSUME_NONNULL_BEGIN

@interface XuanTingViewController : UIViewController<JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>
@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) UIView *userHeaderView;
@property (nonatomic, strong, readonly) JXCategoryTitleView *categoryView;

@end

NS_ASSUME_NONNULL_END
