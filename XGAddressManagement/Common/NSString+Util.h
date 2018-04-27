//
//  NSString+Util.h
//  vstore_iphone
//
//  Created by shinn on 14-8-29.
//  Copyright (c) 2014年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Util)
- (NSString *)unicodeDecode;
- (NSURL *)escapedURL;
- (NSData*)hexToBytes;
- (NSComparisonResult)compareToVersion:(NSString *)version;
- (BOOL)isEmptyString;
//判断字符串的字符个数
+ (int)getCharacterFormStr:(NSString *)tempStr;
//只有 数字 字母 汉字 才匹配
- (BOOL)predicateSearchText;
- (NSInteger)byteLength;

- (NSString *)md5;
- (NSUInteger)hexValue;
-(long long)decimal;
//是否是网络图片
-(BOOL)isHttpUrl;
///3位数字添加一个逗号
- (NSString *)numberWithComma;
///特定长度插入特定字符
- (NSString *)insertSeperate:(NSString *)seperate withLength:(NSUInteger)length;
///特定长度插入特定字符,最前面不能插入时是否跟其后的合并，=YES时类型银行卡号第一个分组是6位一样
- (NSString *)insertSeperate:(NSString *)seperate withLength:(NSUInteger)length ignoreMore:(BOOL)ignore;
@end


@interface NSString (HmacSha1)

// Hmac SHA1 加密（结果已进行 base64 加密）
- (NSString *)hmacSha1WithKey:(NSString *)key;



@end
