//
//  NSString+Util.m
//  vstore_iphone
//
//  Created by shinn on 14-8-29.
//  Copyright (c) 2014年 Netease. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (Util)

- (NSString *)unicodeDecode {
    NSData *data = [self dataUsingEncoding:NSUnicodeStringEncoding];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUnicodeStringEncoding];
    return string;
}

- (NSURL *)escapedURL {

    return [NSURL URLWithString:[self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet whitespaceCharacterSet]]];
//    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (str.length == 0)
//    {
//        return nil;
//    }
//    
//    return [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSData*)hexToBytes {
    __autoreleasing NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

- (NSComparisonResult)compareToVersion:(NSString *)version {
    if (self == nil || version == nil) {
        NSLog(@"compare version error: self %@ to %@ ",self, version);
        return NSOrderedSame;
    }
    /**
     string 取 intValue，几种情况
     43a,3a  分别返回43、3
     a3，00a0001  返回0
     */
    
    NSArray *components = [self componentsSeparatedByString:@"."];
    NSArray *componentsSecond = [version componentsSeparatedByString:@"."];
    
    int limit = (int)MIN(components.count, componentsSecond.count);
    int i = 0;
    
    for (; i < limit; i++) {
        
        int first = [components[i] intValue];
        int second = [componentsSecond[i] intValue];
        if ( first > second) {
            return NSOrderedDescending;
        }
        else if (first < second)
        {
            return NSOrderedAscending;
        }
    }
    
    if (components.count == componentsSecond.count) {
        return NSOrderedSame;
    }
    
    NSComparisonResult result = NSOrderedSame;
    // 比剩下的字符串
    NSArray *theLongerString = componentsSecond.count > components.count ? componentsSecond:components;
    NSArray *subarray = [theLongerString subarrayWithRange:NSMakeRange(i, componentsSecond.count -i)];
    
    NSString *theLeftString = [subarray componentsJoinedByString:@""];
    int iValue = [theLeftString intValue];
    if (iValue == 0) {
        result = NSOrderedSame;
    }
    else if (iValue > 0)
    {
        result = componentsSecond.count > components.count ? NSOrderedAscending : NSOrderedDescending;
    }
    else{
        NSLog(@"compare version self %@ to %@",self ,version);
    }
    
    return result;
}

- (BOOL)isEmptyString {
    return [self isEqualToString:@""];
}

//是否是网络图片
-(BOOL)isHttpUrl {
    if (self && ([self containsString:@"http:"] || [self containsString:@"https:"])) {
        return YES;
    }
    return NO;
}

//注：第一个方法 emoji也按2个字符算， 第二个方法用Unicode编码后是按4个字符算的

#pragma mark - func one
- (NSInteger)byteLength {
    //拿到所有str的length长度（包括中文英文..都算为1个字符）
    NSUInteger len = self.length;
    //汉字字符集
    NSString* pattern = @"[\u4e00-\u9fa5]";
    //正则表达式筛选条件
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    //计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    //len已经把中文算进去了，中文少的一个字符通过numMatch个数来补充，效果就是中文2个字符，英文1个字符
    return len + numMatch;
}

#pragma mark - func two
//判断字符串的字符个数
+ (int)getCharacterFormStr:(NSString *)tempStr {
    int strlength = 0;
    char* p = (char*)[tempStr cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[tempStr lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

 //只有 数字 字母 汉字 才匹配
- (BOOL)predicateSearchText {
    ///wdf add *#
   // NSString *regex = @"^[\u4e00-\u9fa5_a-zA-Z0-9*#]+$";
    NSString *regex = @"^[\u4e00-\u9fa5_a-zA-Z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:self];
    // 这里是后期补充的内容:九宫格判断
    if (!isValid) {
        NSString *other = @"➋➌➍➎➏➐➑➒";
        unsigned long len=self.length;
        for(int i=0;i<len;i++)
        {
            unichar a=[self characterAtIndex:i];
            if(!((isalpha(a))
                 ||(isalnum(a))
                 ||((a=='_') || (a == '-'))
                 ||((a >= 0x4e00 && a <= 0x9fa6))
                 ||([other rangeOfString:self].location != NSNotFound)
                 ))
                return NO;
        }
        return YES;
    }
    return isValid;
}

- (NSString *)md5{
    //YYKit里的md5好像不一样
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5(data.bytes, (uint32_t)data.length, digest);
    NSMutableString *ms = [NSMutableString string];
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    return [ms copy];
}


//HEX
- (NSUInteger)hexValue {
    unsigned int result = 0;
    sscanf([self UTF8String], "%x", &result);
    return result;
}

-(long long)decimal
{
    NSInteger length = self.length;
    if (length % 2 != 0) {
        return 0;
    }
    NSMutableString *decimalString= [NSMutableString string];
    for (NSInteger idx = 0; idx<length; idx+=2) {
        NSInteger high = [[self substringWithRange:NSMakeRange(idx, 1)] integerValue];
        NSInteger low = [[self substringWithRange:NSMakeRange(idx+1, 1)] integerValue];
        NSInteger decimal = high*16+low-48;
        [decimalString appendFormat:@"%ld",(long)decimal];
    }
    return [decimalString longLongValue];
}

///3位数字添加一个逗号
- (NSString *)numberWithComma {
    NSInteger intValue = self.integerValue;
    if (intValue <= 1000) {
        return self;
    }

    ///先取出小数点后面的
    NSString *floatString = nil;
    NSString *intString  = self;
    if ([self containsString:@"."]) {
        NSRange range = [self rangeOfString:@"."];
        floatString = [self substringFromIndex:range.location];
        intString = [self substringToIndex:range.location];
    }

    NSMutableString *newstring = [[intString insertSeperate:@"," withLength:3] mutableCopy];

    ///加上小数部分
    if (floatString.length > 0) {
        [newstring appendString:floatString];
    }
    return newstring;
}

- (NSString *)insertSeperate:(NSString *)seperate withLength:(NSUInteger)length {
    return [self insertSeperate:seperate withLength:length ignoreMore:NO];
}
///特定长度插入特定字符,最前面不能插入时是否跟其后的合并，=YES时类型银行卡号第一个分组是6位一样
- (NSString *)insertSeperate:(NSString *)seperate withLength:(NSUInteger)length ignoreMore:(BOOL)ignore {
    if (length >= self.length || length <= 1) {
        return self;
    }

    ///最前面的一串最长可能是 2*length - 1位
    NSInteger count = self.length / length;
    if (ignore || self.length % length == 0) {
        count--;
    }
    
    NSMutableString *oldString = [NSMutableString stringWithString:self];
    NSMutableString *newstring = [NSMutableString string];
    for (NSInteger i = 0; i < count; i++) {
        ///默认是只要到length了都插入
        NSRange range = NSMakeRange(oldString.length - length, length);
        NSString *subString = [oldString substringWithRange:range];
        [newstring insertString:subString atIndex:0];
        [newstring insertString:seperate atIndex:0];
        [oldString deleteCharactersInRange:range];
    }

    ///还有剩下的时
    if (oldString.length > 0) {
        [newstring insertString:oldString atIndex:0];
    }

    return newstring;
}

@end


@implementation NSString (HmacSha1)

- (NSString *)hmacSha1WithKey:(NSString *)key {
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [self cStringUsingEncoding:NSUTF8StringEncoding];

    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];

    NSString *hash = [HMAC base64EncodedStringWithOptions:0];
    return  hash;
}

@end
