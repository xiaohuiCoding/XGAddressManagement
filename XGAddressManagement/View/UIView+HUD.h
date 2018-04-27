//
//  UIView+HUD.h
//  Laiwang
//
//  Created by Lings on 14-3-10.
//  Copyright (c) 2014年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HUDIconMessage,
    HUDIconSuccess,
    HUDIconError,
} HUDIconType;


typedef NS_ENUM(NSUInteger, XGTCDoorState) {
    XGTCDoorStateSuccess,
    XGTCDoorStateOpening,
    XGTCDoorStateFail
};

@class MBProgressHUD;

/**
 *  在UIView中展示HUD
 */
@interface UIView (HUD)

@property (nonatomic, retain, readonly) MBProgressHUD * HUD;


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/**
 *  为不同的HUD类型配置不同的icon，程序启动时调用
 *
 *  @param iconImg 图片icon
 *  @param type    HUD类型
 */
+ (void)setIcon:(UIImage *)iconImg forType:(HUDIconType)type;

+ (UIImage *)getIconforType:(HUDIconType)type;


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/**
 *  展示一个普通的HUD提示
 *
 *  @param message 提示的内容
 */
- (void)hudPostTip:(NSString *)message;
- (void)hudPostMessage:(NSString *)message;
- (void)hudPostMessage:(NSString *)message delay:(NSTimeInterval)delay;

/**
 *  展示一个错误icon的HUD提示
 *
 *  @param message 提示的内容
 */
- (void)hudPostError:(NSString *)message;
- (void)hudPostError:(NSString *)message delay:(NSTimeInterval)delay;

/**
 *  展示一个对勾icon的HUD提示
 *
 *  @param message 提示的内容
 */
- (void)hudPostSuccess:(NSString *)message;
- (void)hudPostSuccess:(NSString *)message delay:(NSTimeInterval)delay;

/**
 *  展示领取红包的效果
 *
 *  @param success <#success description#>
 */
- (void)hudHongbao:(BOOL)success;

/**
 *  展示一个HUD式的loading
 *
 *  @param message 提示的内容
 */
- (void)hudPostLoading:(NSString *)message;


///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
- (void)txsjLoading;
- (void)txsjLoading:(NSString *)message;

/**
 *  清除HUD的展示
 *
 *  @param animated 是否带动画
 */
- (void)hudCleanUp:(BOOL)animated;



@end
