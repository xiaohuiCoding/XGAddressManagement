//
//  XGTCBaseViewController
//  XGOA
//
//  Created by wangdf on 2017/4/7.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XGTCBaseImageNavBarWidth 44

@interface XGTCBaseViewController : UIViewController

///右侧按钮（默认只有1个），如果有多个那就自己在定义吧，这里只写通胜情况
@property (strong, nonatomic) UIButton                  *rightButton;
///默认是返回按钮,如果需要可以设置backImage
@property (strong, nonatomic) UIImage                   *backImage;
///左侧的自定义按钮，一般用于dismiss视图，默认样式为x
@property(nonatomic, strong) UIButton                   *leftCustomButton;

///返回button
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
///右侧button，目前不会用到。先不放放开
//@property (nonatomic, readonly) UIBarButtonItem *rightBarButtonItem;

///禁用左滑返回
- (void)cancelPopGesture;
///打开左滑手势返回
- (void)usePopGesture;


///topviewcontroller 主要是presen新viewCotroller的时候要检查是不是最上面的一个
- (UIViewController *)XGOATopViewController;

///显示错误
- (void)showToastMessage:(NSString *)message;
- (void)showToastMessage:(NSString *)message position:(id)position;
- (void)showToastMessage:(NSString *)message duration:(NSTimeInterval)duration position:(id)position;


#pragma --mark Actions
- (IBAction)backAction:(id)sender;
- (void)rightButtonClicked:(id)sender;
- (void)leftButtonClicked:(id)sender;

#pragma --mark mask view
/* 是否显示蒙层 */
-(BOOL)showMaskImg;
/* 是否需要自己控制 关闭显示 */
-(BOOL)isNeedUserClosed;
///子页面有蒙层引导时,宽高最好用window的宽高, 界面的引导蒙层就在重写这个方法，并返回一个view
-(UIView *) maskViewWithSonClass:(CGSize) windowSize;
///蒙层key,用来判断是否已经显示过提醒了
- (NSString *)maskShowKey;
///对于不是在didload加引导的就在该显示引导的地方调此方法（怕以后有蛋疼的需求，先开放出来）
- (void)checkShowMaskView;
///引导背景颜色(如果引导页设计需要不能用整张背景图时需要自定义的时候，这个函数就返回clearColor)
- (UIColor *)maskBackGroupColor;
///是否还有下一个引导(一个页面多次提醒也是通过不同的key,自己重写这个方法判断显示顺序的key)
-(BOOL)hasNextMask;
///关闭引导，如果子类要改变关闭方法的话，只要重写这个方法就好了，不用再新把添加mask的代码copy一份
- (void)close:(id)sender;
///蒙层关闭后事件
- (void)afterCloseMaskView;
///当前是否有蒙层引导页显示着
- (BOOL)hasMaskViewShowing;




// 适配ios7横屏
- (CGFloat)cellContentViewWith;

@end
