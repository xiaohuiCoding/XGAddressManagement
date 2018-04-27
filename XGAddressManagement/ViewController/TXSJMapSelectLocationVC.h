//
//  TXSJMapSelectLocationVC.h
//  retail
//
//  Created by 虞振兴 on 2017/8/11.
//  Copyright © 2017年 apple. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TXSJBaseViewController.h"
#import "TXSJMapLocationVM.h"

@protocol TXSJMapSelectLocationVCDelegate <NSObject>
@optional
//获取地理位置信息
- (void)getLocationItemData:(TXSJCommonModel *)model;
@end

@interface TXSJMapSelectLocationVC : TXSJBaseViewController
//@interface TXSJMapSelectLocationVC : UIViewController
@property (nonatomic,weak) id<TXSJMapSelectLocationVCDelegate> delegate;

@end
