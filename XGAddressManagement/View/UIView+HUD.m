//
//  UIView+HUD.m
//  Laiwang
//
//  Created by Lings on 14-3-10.
//  Copyright (c) 2014年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import "UIView+HUD.h"
#import <MBProgressHUD.h>
#import <objc/runtime.h>


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#define TIP_SHOWING_TIME       0.5
#define NORMAL_SHOWING_TIME    1.
#define ERROR_SHOWING_TIME     1.5
#define LOADING_SHOWING_TIME   30

static char kHUDKey;
static NSMutableDictionary * g_typeIconsDict = nil;


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation UIView (HUD)

+ (void)setIcon:(UIImage *)iconImg forType:(HUDIconType)type
{
    if (!g_typeIconsDict) {
        g_typeIconsDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    
    if (!iconImg) {
        [g_typeIconsDict removeObjectForKey:[NSNumber numberWithInt:type]];
    } else {
        [g_typeIconsDict setObject:iconImg forKey:[NSNumber numberWithInt:type]];
    }
}

+ (UIImage *)getIconforType:(HUDIconType)type
{
    if (!g_typeIconsDict) {
        return nil;
    }
    
    return [g_typeIconsDict objectForKey:[NSNumber numberWithInt:type]];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (MBProgressHUD *)HUD
{
    if (!g_typeIconsDict)
    {
//        LWLogWarn(@"请为HUD配置不同类型的icon");
    }
    
    MBProgressHUD * hud = [self getExistHUD];
    if (!hud)
    {
        hud = [[MBProgressHUD alloc] initWithView:self];
        hud.animationType = MBProgressHUDAnimationFade;
        hud.removeFromSuperViewOnHide = NO;
        
        objc_setAssociatedObject(self, &kHUDKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [self addSubview:hud];
    [self bringSubviewToFront:hud];
    
    return hud;
}

- (MBProgressHUD *)getExistHUD
{
    MBProgressHUD * hud = objc_getAssociatedObject(self, &kHUDKey);
    
    if (hud && ![hud isKindOfClass:[MBProgressHUD class]]) {
        [hud removeFromSuperview];
        hud = nil;
    }
    
    return hud;
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (void)hudPostTip:(NSString *)message
{
    return [self hudPostMessage:message delay:TIP_SHOWING_TIME];
}

- (void)hudPostMessage:(NSString *)message
{
    if ([message containsString:@"服务器"]) {
        return;
    }
    return [self hudPostMessage:message delay:NORMAL_SHOWING_TIME];
}

- (void)hudPostMessage:(NSString *)message delay:(NSTimeInterval)delay
{
    if ([message length] == 0)
    {
        [self hudCleanUp:YES];
        return;
    }
    
    MBProgressHUD * HUD = self.HUD;
    
	UIImage * msgImg = [UIView getIconforType:HUDIconMessage];
    UIImageView * msgImageview = [[UIImageView alloc] initWithImage:msgImg];
	HUD.customView = msgImageview;
	HUD.mode = MBProgressHUDModeCustomView;
    if (message.length > 10 || [message containsString:@"\n"]) {
        HUD.label.text  = nil;
        HUD.detailsLabel.text = message;
    } else {
        HUD.label.text = message;
        HUD.detailsLabel.text = nil;
    }
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:delay];
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (void)hudPostError:(NSString *)message
{
    return [self hudPostError:message delay:ERROR_SHOWING_TIME];
}

- (void)hudPostError:(NSString *)message delay:(NSTimeInterval)delay
{
    if ([message length] == 0)
    {
        [self hudCleanUp:YES];
        return;
    }
    
    MBProgressHUD * HUD = self.HUD;
    
	UIImage * msgImg = [UIView getIconforType:HUDIconError];
    UIImageView * msgImageview = [[UIImageView alloc] initWithImage:msgImg];
	HUD.customView = msgImageview;
	HUD.mode = MBProgressHUDModeCustomView;
    if (message.length > 10 || [message containsString:@"\n"]) {
        HUD.label.text  = nil;
        HUD.detailsLabel.text = message;
    } else {
        HUD.label.text = message;
        HUD.detailsLabel.text = nil;
    }
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:delay];
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (void)hudPostSuccess:(NSString *)message
{
    return [self hudPostSuccess:message delay:NORMAL_SHOWING_TIME];
}

- (void)hudPostSuccess:(NSString *)message delay:(NSTimeInterval)delay
{
    MBProgressHUD * HUD = self.HUD;
    
	UIImage * msgImg = [UIView getIconforType:HUDIconSuccess];
    UIImageView * msgImageview = [[UIImageView alloc] initWithImage:msgImg];
	HUD.customView = msgImageview;
	HUD.mode = MBProgressHUDModeCustomView;
    if (message.length > 10 || [message containsString:@"\n"]) {
        HUD.label.text  = nil;
        HUD.detailsLabel.text = message;
    } else {
        HUD.label.text = message;
        HUD.detailsLabel.text = nil;
    }
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:delay];
}

- (void)hudHongbao:(BOOL)success
{
    MBProgressHUD * hud = self.HUD;
    if (success) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hongbao_exchange_success"]];
        hud.label.text = @"领取成功";
    } else {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hongbao_exchange_fail"]];
        hud.label.text = @"领取失败";
    }

    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.color = [UIColor colorWithHexString:@"00000080"];
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = FONT_14;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:2];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (void)hudPostLoading:(NSString *)message
{
    MBProgressHUD * HUD = self.HUD;
    
    HUD.customView = nil;
	HUD.mode = MBProgressHUDModeIndeterminate;
    if (message.length > 10 || [message containsString:@"\n"]) {
        HUD.label.text  = nil;
        HUD.detailsLabel.text = message;
    } else {
        HUD.label.text = message;
        HUD.detailsLabel.text = nil;
    }
    [HUD showAnimated:YES];
//    [HUD hideAnimated:YES afterDelay:LOADING_SHOWING_TIME];
}

////////////////////////TXSJ loading
- (void)txsjLoading {
    [self txsjLoading:nil];
}
- (void)txsjLoading:(NSString *)message {
    MBProgressHUD *hud = self.HUD;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = NO;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    UIImageView * firstImg = [[UIImageView alloc] initWithImage:ImageNamed(@"动画_00000")];
    NSMutableArray *imgsArr = [NSMutableArray array];
    for (int i=0; i<=56; i++) {
        UIImage *img =  [UIImage imageNamed:[NSString stringWithFormat:@"动画_000%02d",i]];
        [imgsArr addObject:img];
    }
    firstImg.animationImages = imgsArr;
    [firstImg startAnimating];
    hud.customView = firstImg;
    if (message.length > 10 || [message containsString:@"\n"]) {
        hud.label.text  = nil;
        hud.detailsLabel.text = message;
    } else {
        hud.label.text = message;
        hud.detailsLabel.text = nil;
    }
    [hud showAnimated:YES];
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (void)hudCleanUp:(BOOL)animated
{
    MBProgressHUD * HUD = [self getExistHUD];
    if (!HUD) {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:HUD];
    
    if ((fabs(HUD.alpha-0.0f) < FLT_EPSILON) || HUD.hidden) {
        return;
    }
    
    [HUD removeFromSuperview];
    [HUD sendSubviewToBack:self];
}


@end
