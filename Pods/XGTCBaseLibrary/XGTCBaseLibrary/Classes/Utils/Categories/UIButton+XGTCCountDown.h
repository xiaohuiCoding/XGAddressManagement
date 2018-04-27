//
//  UIButton+XGTCcountDown.h
//  XGOA
//
//  Created by 何泽轩 on 2017/4/14.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XGTCCountDown)

///timer
@property (nonatomic, strong) dispatch_source_t timer;

///取消timer
- (void)xgtc_cancleTimer;

/**
 *  倒计时按钮
 *
 *  @param timeLine 倒计时总时间
 *  @param title    还没倒计时的title
 *  @param subTitle 倒计时中的子名字，如时、分
 *  @param mColor   还没倒计时的颜色
 *  @param color    倒计时中的颜色
    @param mainTitleColor 字体颜色
 */
- (void)xg_startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color mainTitleColor:(UIColor *)mainTitleColor countTitleColor:(UIColor *)countTitleColor borderColor:(UIColor *)borderColor hasBorder:(BOOL)hasBorder;
@end
