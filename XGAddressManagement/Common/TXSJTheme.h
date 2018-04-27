//
//  ADJConfigModel.h
//  aidaojia
//
//  Created by yufan on 16/9/12.
//  Copyright © 2016年 Yi Dao. All rights reserved.
//

#import <XGTCBaseModel.h>

@protocol TXSJThemeColor;

@interface TXSJThemeColor : XGTCBaseModel

@property (nonatomic, copy) NSString *kBarColor;// "0xffc800"
@property (nonatomic, copy) NSString *kSegSelectedColor;// "0xff0000"
@property (nonatomic, copy) NSString *kDarkYellowColor;
@property (nonatomic, copy) NSString *kBgColor;

@end

@protocol TXSJThemeConfig;

@interface TXSJThemeConfig : XGTCBaseModel

@property (nonatomic, copy) NSString *XGTCSJJPushKey;
@property (nonatomic, copy) NSString *XGTCSJUMChannelId;
@property (nonatomic, copy) NSString *AMapApiKey;
@property (nonatomic, copy) NSString *WeChatAppKey;
@property (nonatomic, copy) NSString *WeChatAppSecretString;

///友盟app key
@property (nonatomic, copy) NSString *XGTCSJUMengAPPKey;
///QQ appkey
@property (nonatomic, copy) NSString *QQAppkey;
///QQ appsecret
@property (nonatomic, copy) NSString *QQAppSecretString;
///Weibo appkey
@property (nonatomic, copy) NSString *WeiBoAppkey;
///Weibo appsecret
@property (nonatomic, copy) NSString *WeiboAppSecretString;

///百度统计
@property (nonatomic, copy) NSString *BaiduMobStatKey;

@end


@interface TXSJTheme : XGTCBaseModel

@property (nonatomic, strong) TXSJThemeColor *color;
@property (nonatomic, strong) TXSJThemeConfig *config;

///是否在我的界面显示切换服务器条目
@property (nonatomic, assign) BOOL XGTCDebugModel;

+ (instancetype)sharedInstance;


@end
