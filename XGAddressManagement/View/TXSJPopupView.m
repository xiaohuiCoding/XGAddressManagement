//
//  TXSJPopupView.m
//  retail
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJPopupView.h"

@interface TXSJPopupView ()

@property (nonatomic, weak) NSTimer *hideDelayTimer;

@end

@implementation TXSJPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
        [self layout];
    }
    return self;
}
- (void)titleStr:(NSString *)title {
    _labTitle.text = title;
}
- (void)setImageString:(NSString *)imageString {

    if (imageString.length != 0) {
        self.imageTop.hidden = NO;
        self.imageTop.image = [UIImage imageNamed:imageString];
        self.labTitle.sd_layout.leftSpaceToView(self, UIScale(32)).topSpaceToView(self.imageTop, UIScale(8)).autoHeightRatio(0).maxWidthIs(kScreenWidth - UIScale(130));
    }else {
        self.imageTop.hidden = YES;
        return;
    }
}
- (void)layout {
    [self addSubview:self.labTitle];
    [self addSubview:self.imageTop];
    self.imageTop.sd_layout.centerXEqualToView(self).topSpaceToView(self, UIScale(16)).heightIs(UIScale(26)).widthIs(UIScale(26));
    self.imageTop.hidden = YES;
    self.labTitle.sd_layout.leftSpaceToView(self, UIScale(16)).topSpaceToView(self, UIScale(16)).autoHeightRatio(0).maxWidthIs(kScreenWidth - UIScale(130));
    [_labTitle setSingleLineAutoResizeWithMaxWidth:UIScale(kScreenWidth - UIScale(162))];
    [self setupAutoWidthWithRightView:self.labTitle rightMargin:UIScale(16)];
    [self setupAutoHeightWithBottomView:_labTitle bottomMargin:UIScale(16)];
    
}
- (UIImageView *)imageTop {
    if (!_imageTop) {
        _imageTop = [[UIImageView alloc]init];
    }
    return _imageTop;
}
- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc]init];
        _labTitle.font = FONT_15;
        _labTitle.textColor = [UIColor whiteColor];
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.numberOfLines = 0;
    }
    return _labTitle;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    NSTimer *timer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(handleHideTimer:) userInfo:@(animated) repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.hideDelayTimer = timer;
}

- (void)handleHideTimer:(NSTimer *)timer {
    if ([timer.userInfo boolValue]) {
        [UIView animateWithDuration:.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.hideDelayTimer invalidate];
        }];
    }else {
        [self removeFromSuperview];
        [self.hideDelayTimer invalidate];
    }
}

-(void)dealloc {
    NSLog(@"popview dealloc");
}

@end


static char kPopViewKey;
@implementation UIView (TXSJPopupView)

#pragma --mark popView
- (TXSJPopupView *)popView {
    TXSJPopupView * popView = [self getExistPopView];
    if (!popView)
    {
        popView = [[TXSJPopupView alloc]init];
        popView.layer.cornerRadius = 2;
        objc_setAssociatedObject(self, &kPopViewKey, popView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return popView;
}

- (TXSJPopupView *)getExistPopView {
    TXSJPopupView * popView = objc_getAssociatedObject(self, &kPopViewKey);

    if (popView && ![popView isKindOfClass:[TXSJPopupView class]]) {
        [popView removeFromSuperview];
        popView = nil;
    }

    return popView;
}

#pragma --mark Actions
///显示toast
- (void)toastMessageTitle:(NSString *)title {
    [self toastMessageTitle:title toastImageStr:nil];
}
///显示toast
- (void)toastMessageTitle:(NSString *)title toastImageStr:(NSString *)str{
    if (!title || title.length==0) {
        return;
    }

    ///隐藏前一个，显示后面的
    [self hideToast];

    TXSJPopupView *popView = self.popView;
    popView.alpha = 1;
    popView.imageString = str;
    [popView titleStr:title];

    [self addSubview:popView];
    popView.sd_layout.centerXEqualToView(self).centerYEqualToView(self);
    [self bringSubviewToFront:popView];

    [popView hideAnimated:YES afterDelay:2];
}


///隐藏toast
- (void)hideToast {
    TXSJPopupView *popView = self.popView;
    if (!popView) {
        return;
    }

    [NSObject cancelPreviousPerformRequestsWithTarget:popView];

//    if ((fabs(popView.alpha-0.0f) < FLT_EPSILON) || popView.hidden) {
//        return;
//    }

    [popView removeFromSuperview];
    [popView sendSubviewToBack:self];
}
@end
