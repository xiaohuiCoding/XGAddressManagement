//
//  TXSJCommonUtils.h
//  retail
//
//  Created by wangdf on 2017/8/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXSJCommonUtils : NSObject

//@property (nonatomic,assign) AFNetworkReachabilityStatus AFNetStatus;//网络状态保存
///获取单例
+ (instancetype)shareInstance;

////获取到idfa后存keychain中，就算删除app重装也是能取到的
+ (NSString *)udid;

+ (NSString *)currentVersion;

+ (NSString *)appName;

+ (NSString *)shortCurrentVersion;

//当前VC
+ (UIViewController *)getCurrentVC;

///回到最底层的nav
+ (void)popToRootNavViewController;

+ (void)popToRootNavViewController:(UIViewController *)currentVC;

///是否iphoneX
+ (BOOL)deviceIsiPhoneX;

///计算文字宽度
+ (CGSize)textSizeWithText:(NSString *)text fontSize:(UIFont *)font;
+ (CGSize)textSizeWithText:(NSString *)text font:(UIFont *)font;
+ (CGSize)multilineTextSizeWithText:(NSString *)text fontSize:(CGFloat)fontSize maxSize:(CGSize)maxSize;
+ (CGSize)multilineTextSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
///隐藏tableview的空分割线
+ (void)fixTableViewEmptySeparator:(UITableView *)tableView;

/**
 *  生成条形码
 */
+ (UIImage *) generateBarCode:(NSString *)codeStr withSize:(CGSize)needSize;
//正则表达式判断手机号
+ (BOOL)moblieText:(NSString *)moblie;
//转化为json字符串
+ (NSString*)ObjectTojsonString:(id)object;

///生成带间距的attrbuteString
+ (NSAttributedString *)generateAttributeTextWithText:(NSString *)text withFontSize:(CGFloat)fontSize withSpace:(CGFloat)lineSpacing;
+ (NSAttributedString *)generateAttributeTextWithText:(NSString *)text withFont:(UIFont *)font withSpace:(CGFloat)lineSpacing;
@end
