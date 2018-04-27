//
//  TXSJRefreshFooter.m
//  retail
//
//  Created by wangdf on 2017/9/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJRefreshFooter.h"

@implementation TXSJRefreshFooter
- (void)prepare {
    [super prepare];
    self.mj_h = UIScale(60);
}

- (void)placeSubviews {
    [super placeSubviews];

    [self setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    CGSize size = [TXSJCommonUtils multilineTextSizeWithText:@"正在加载" font:FONT_13 maxSize: CGSizeMake(kScreenWidth, MAXFLOAT)];

    self.stateLabel.hidden = self.state == MJRefreshStateRefreshing ? NO : YES;
    //    self.indicatorView.centerX = SCREEN_WIDTH / 2;
    self.indicatorView.left = (kScreenWidth - self.indicatorView.width - size.width - 10) / 2.f;
    self.indicatorView.top = 4;

    //设置Label位置
    self.stateLabel.size = size;
    [self.stateLabel setFont:FONT_13];
    self.stateLabel.centerY = self.indicatorView.centerY;
    self.stateLabel.left = self.indicatorView.right + 10;
}

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
        self.indicatorView = (UIActivityIndicatorView *)view;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
