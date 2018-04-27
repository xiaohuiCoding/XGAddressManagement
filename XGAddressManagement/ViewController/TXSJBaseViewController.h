//
//  TXSJBaseViewController.h
//  retail
//
//  Created by apple on 2017/7/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <XGTCBaseViewController.h>
#import "TXSJViewModel.h"
#import "TXSJUrlLocator.h"

@interface TXSJBaseViewController : XGTCBaseViewController <TXSJUrlLocator>
/// The `viewModel` parameter in `-initWithViewModel:` method.
@property (nonatomic, strong, readonly) TXSJViewModel *viewModel;

@property (nonatomic ,strong) UIButton *defaultBtn;// 无数据时候的 按钮

@property (nonatomic,strong) UIView *defaultView; //无数据时候的默认布局

///返回顶端按键
@property (nonatomic, strong) UIButton *backToTopButton;

///购物车按钮
@property (nonatomic, strong) UIButton *shoppingCartButton;
//购物车红点
@property (nonatomic,strong) UILabel *badgeLable;
///分享按钮
@property (nonatomic, strong) UIButton *shareButton;

///是否显示分享按钮（默认是不显示的，webview的话要显示分享的按钮会通过jsbrige来回调显示）
@property (nonatomic, assign) BOOL showShareButton;

///响应分享事件
- (void)showShareViewAction:(id)sender;
///刷新右侧按钮
- (void)reloadRightBarButtons;

///返回到顶端，子类重写把想回到顶端的scrollview滑到顶端
- (void)backToTopAction;

/// Initialization method. This is the preferred way to create a new view.
///
/// viewModel - corresponding view model
///
/// Returns a new view.
- (instancetype)initWithViewModel:(TXSJViewModel *)viewModel;

/// Binds the corresponding view model to the view.
- (void)bindViewModel;
//配置tableview cell 的 ViewModel的 执行操作～～  比如我的主页那  订单cell的 取消订单操作 然后主页刷新数据
- (void)configureCell:(UITableView *)tableView viewModelActionAtIndexPath:(NSIndexPath *)indexPath;

- (void)toastMessageTitle:(NSString *)title;
- (void)toastMessageTitle:(NSString *)title toastImageStr:(NSString *)str;

///setupSubviews;
- (void)setUpSubviews;

///是否显示NavBar，默认显示
-  (BOOL)needNavigationBarHidden;

///默认所有二级页面都显示，如果有二给页面不显示，那么就重写此方法
- (BOOL)showShoppintCartButton;

//无数据时候的 默认图片 布局
-(void)showNodataInView:(UIView *)parentView isShow:(BOOL)isShow;

-(void)setDefaultImg:(UIImage *)defaultImg defaultTitle:(NSString *)defaultTitle defaultBtnTitle:(NSString *)defaultBtnTitle;

-(UIView *)getDefaultView:(UIView *)parentView;

//loading动画
-(void)showLoading;
-(void)hiddenLoading;

///navBar的高度
- (CGFloat)navBarHeight;
@end
