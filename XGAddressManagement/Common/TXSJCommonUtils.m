//
//  TXSJCommonUtils.m
//  retail
//
//  Created by wangdf on 2017/8/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJCommonUtils.h"
//#import <UICKeyChainStore/UICKeyChainStore.h>
#import <XGTCCommonUtils.h>

@implementation TXSJCommonUtils

///获取单例
+ (instancetype)shareInstance {
    static TXSJCommonUtils *_sharedEngine = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedEngine = [[self alloc] init];
    });
    
    return _sharedEngine;
}

//+ (NSString *)udid {
//    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.tuchao.txsj"];
//    NSString *udid = keychain[@"XGTCSJ_UDID"];
//    if (!udid) {
//        udid = [XGTCCommonUtils getIDFA];
//        keychain[@"XGTCSJ_UDID"] = udid;
//    }
//    return udid;
//}


+ (NSString *)currentVersion {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:bundlePath];
    NSString *bundleVersion = [dict objectForKey:@"CFBundleShortVersionString"];
    return [NSString stringWithString:bundleVersion];
}

+ (NSString *)appName {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:bundlePath];
    NSString *appName = [dict objectForKey:@"CFBundleDisplayName"];
    return appName;
}

+ (NSString *)shortCurrentVersion {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:bundlePath];
    NSString *bundleVersion = [dict objectForKey:@"CFBundleVersion"];
    return bundleVersion;
}



+ (UIViewController *)getCurrentVC {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
}

///回到最底层的nav
+ (void)popToRootNavViewController {
    UIViewController *currentVC = [self getCurrentVC];
    [self popToRootNavViewController:currentVC];
}

+ (void)popToRootNavViewController:(UIViewController *)currentVC {
    UINavigationController *rootNav = nil;
    UIViewController *vc = kKeyWindow.rootViewController;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        rootNav = (UINavigationController *)vc;
    }else if([vc isKindOfClass:[UITabBarController class]]) {
        rootNav = ((UITabBarController *)vc).selectedViewController;
    } else {
        rootNav = vc.navigationController;
    }

    if ([currentVC.navigationController isEqual:rootNav]) {
        currentVC.tabBarController.selectedIndex = 0;
        [currentVC.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:TXSJNotificationMainHomeToFirstIndex object:nil];
    }else {
        [currentVC dismissViewControllerAnimated:YES completion:^{
            ///如果还有present的就再做
            [self popToRootNavViewController];
        }];
    }
}


///是否iphoneX
+ (BOOL)deviceIsiPhoneX {
    BOOL isX = NO;
    if (@available(iOS 11.0, *)) {
        isX = kKeyWindow.safeAreaInsets.top > 0;
    }

    return isX;
}

///计算文字宽度
+ (CGSize)textSizeWithText:(NSString *)text fontSize:(UIFont *)font {
    return [self textSizeWithText:text font:font];
}

+ (CGSize)textSizeWithText:(NSString *)text font:(UIFont *)font {
    if (!text.length) {
        return CGSizeZero;
    }
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    size.height = ceilf(size.height);
    return size;
}


+ (CGSize)multilineTextSizeWithText:(NSString *)text fontSize:(CGFloat)fontSize maxSize:(CGSize)maxSize {
    return [self multilineTextSizeWithText:text font:[UIFont systemFontOfSize:fontSize] maxSize:maxSize];
}

+ (CGSize)multilineTextSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    if (!text.length) {
        return CGSizeZero;
    }
    CGSize size = [text boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil].size;
    size.height = ceilf(size.height);
    return size;
}


///隐藏tableview的空分割线
+ (void)fixTableViewEmptySeparator:(UITableView *)tableView {
    if (!tableView || tableView.tableFooterView) {
        return;
    }
    tableView.tableFooterView = [[UIView alloc] init];
}

/**
 *  生成条形码
 */
+ (UIImage *) generateBarCode:(NSString *)codeStr withSize:(CGSize)needSize{
    CIImage *ciImage = [self generateBarCodeImage:codeStr];
    UIImage *image = [self resizeCodeImage:ciImage withSize:needSize];
    return image;
}
/**
 *  生成条形码
 *
 *
 *  @return 生成条形码的CIImage对象
 */
+ (CIImage *) generateBarCodeImage:(NSString *)source
{
    // iOS 8.0以上的系统才支持条形码的生成，iOS8.0以下使用第三方控件生成
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 注意生成条形码的编码方式
        NSData *data = [source dataUsingEncoding: NSASCIIStringEncoding];
        CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
        [filter setValue:data forKey:@"inputMessage"];
        // 设置生成的条形码的上，下，左，右的margins的值
        [filter setValue:[NSNumber numberWithInteger:0] forKey:@"inputQuietSpace"];
        return filter.outputImage;
    }else{
        return nil;
    }
}

/**
 *  调整生成的图片的大小
 *
 *  @param image CIImage对象
 *  @param size  需要的UIImage的大小
 *
 *  @return size大小的UIImage对象
 */
+ (UIImage *) resizeCodeImage:(CIImage *)image withSize:(CGSize)size {
    if (image) {
        CGRect extent = CGRectIntegral(image.extent);
        CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
        CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
        size_t width = CGRectGetWidth(extent) * scaleWidth;
        size_t height = CGRectGetHeight(extent) * scaleHeight;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
        CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
        CGColorSpaceRelease(colorSpaceRef);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef imageRef = [context createCGImage:image fromRect:extent];
        CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
        CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
        CGContextDrawImage(contentRef, extent, imageRef);
        CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
        CGContextRelease(contentRef);
        CGImageRelease(imageRef);
        UIImage *newImage = [UIImage imageWithCGImage:imageRefResized];
        CGImageRelease(imageRefResized);
        return newImage;
    }else{
        return nil;
  }
}

//正则表达式判断手机号
+ (BOOL)moblieText:(NSString *)moblie {
    moblie = [moblie stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (moblie.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:moblie];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:moblie];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:moblie];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}
//转化为json字符串
+ (NSString*)ObjectTojsonString:(id)object

{
    
    NSString *jsonString = [[NSString
                             
                             alloc]init];
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization
                        
                        dataWithJSONObject:object
                        
                        options:NSJSONWritingPrettyPrinted
                        
                        error:&error];
    
    if (! jsonData) {
        
        NSLog(@"error: %@", error);
        
    } else {
        
        jsonString = [[NSString
                       
                       alloc] initWithData:jsonData
                      
                      encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString
                               
                               stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    [mutStr replaceOccurrencesOfString:@" "
     
                            withString:@""
     
                               options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    [mutStr replaceOccurrencesOfString:@"\n"
     
                            withString:@""
     
                               options:NSLiteralSearch range:range2];
    NSRange range3 = {0, mutStr.length};
    NSString * str = @"\\";
    [mutStr replaceOccurrencesOfString:str withString:@"" options:NSLiteralSearch range:range3];
    
    return mutStr;
    
}


///生成带间距的attrbuteString
+ (NSAttributedString *)generateAttributeTextWithText:(NSString *)text withFontSize:(CGFloat)fontSize withSpace:(CGFloat)lineSpacing {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return [self generateAttributeTextWithText:text withFont:font withSpace:lineSpacing];
}


////字休会默认成.SFUIText后，中文单行下面会有行间距，把字体改成pingfang就好了
+ (NSAttributedString *)generateAttributeTextWithText:(NSString *)text withFont:(UIFont *)font withSpace:(CGFloat)lineSpacing {
    if (text.length <= 0) {
        return nil;
    }

    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paraStyle.alignment = NSTextAlignmentLeft;
    //设置行间距
    paraStyle.lineSpacing = lineSpacing;
//    paraStyle.hyphenationFactor = 1.0;
//    paraStyle.firstLineHeadIndent = 0.0;
//    paraStyle.paragraphSpacingBefore = 0.0;
//    paraStyle.headIndent = 0;
//    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:[font.fontName isEqualToString:@".SFUIText"] ? Font_Name_Size(@"PingFangSC-Regular", font.pointSize) : font, NSParagraphStyleAttributeName:paraStyle};

    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];
    return attributeStr;
}
@end
