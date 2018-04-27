//
//  TXSJPopupView.h
//  retail
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXSJPopupView : UIView
@property (nonatomic,strong) UILabel *labTitle;
@property (nonatomic,strong) UIImageView *imageTop;
@property (nonatomic,strong) NSString *imageString;
- (void)titleStr:(NSString *)title;

@end

@interface UIView (TXSJPopupView)
@property (nonatomic, retain, readonly) TXSJPopupView * popView;

///显示toast
- (void)toastMessageTitle:(NSString *)title;
///显示toast
- (void)toastMessageTitle:(NSString *)title toastImageStr:(NSString *)str;

///隐藏toast
- (void)hideToast;
@end
