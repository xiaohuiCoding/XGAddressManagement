//
//  UIButton+XGTCcountDown.m
//  XGOA
//
//  Created by 何泽轩 on 2017/4/14.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#import "UIButton+XGTCCountDown.h"
#import <objc/runtime.h>

static char kUIButtonTimerKey;
@implementation UIButton (XGTCCountDown)

- (void)xg_startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color mainTitleColor:(UIColor *)mainTitleColor countTitleColor:(UIColor *)countTitleColor borderColor:(UIColor *)borderColor hasBorder:(BOOL)hasBorder {
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    __weak typeof(self) weakSelf = self;
    dispatch_block_t handler = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.selected) {
                timeOut = 0;
            }
            //倒计时结束，关闭
            if (timeOut <= 0) {
                [weakSelf xgtc_cancleTimer];
                weakSelf.backgroundColor = mColor;
                [weakSelf setTitle:title forState:UIControlStateNormal];

                [weakSelf setTitleColor:mainTitleColor forState:UIControlStateNormal];
                if (hasBorder) {
                    weakSelf.layer.borderWidth = 1;
                    weakSelf.layer.borderColor = mainTitleColor.CGColor;
                    weakSelf.layer.masksToBounds = YES;
                }

                weakSelf.enabled = YES;
            } else {
                NSInteger seconds = timeOut % 60;
                if (timeOut == 60) {
                    seconds = timeOut;
                }
                NSString *timeStr = [NSString stringWithFormat:@"%02ld", (long)seconds];

                weakSelf.backgroundColor = color;
                [weakSelf setTitle:[NSString stringWithFormat:@"%@(%@s)",subTitle,timeStr] forState:UIControlStateNormal];
                [weakSelf setTitleColor:countTitleColor forState:UIControlStateNormal];
                if(hasBorder){
                    weakSelf.layer.masksToBounds = YES;
                    weakSelf.layer.borderWidth = 1;
                    weakSelf.layer.borderColor = borderColor.CGColor;
                }

                weakSelf.enabled = NO;
                timeOut--;
            }
        });
    };

    ///保证timer
    [self createNewTimerWithHandler:handler];
}

- (void)xgtc_cancleTimer {
    dispatch_source_t timer = self.timer;
    if (timer) {
        dispatch_source_cancel(timer);
        self.timer = nil;
    }
}

- (dispatch_source_t)createNewTimerWithHandler:(dispatch_block_t)handler {
    ///如果有timer 就先取消
    dispatch_source_t timer = self.timer;
    if (timer) {
        [self xgtc_cancleTimer];
    }

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer,handler);
    dispatch_resume(timer);
    self.timer = timer;

    return timer;
}

- (void)setTimer:(dispatch_source_t)timer {
    objc_setAssociatedObject(self, &kUIButtonTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_source_t)timer {
    dispatch_source_t timer = objc_getAssociatedObject(self, &kUIButtonTimerKey);
    return timer;
}

- (void)dealloc {
    [self xgtc_cancleTimer];
}
@end

