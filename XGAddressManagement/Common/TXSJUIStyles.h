//
//  TXSJUIStyles.h
//  retail
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef TXSJUIStyles_h
#define TXSJUIStyles_h

/** scheme */
#define TXSJAppScheme @"sjyx"

///内跳的path地址，发现是这个path的时候解析一下，看是否有相应的内跳，有就跳没有就用h5去打开
#define TXSJ_JUMP_APP_PATH @"/app/viewpage"

///itunes link
#define iTunesLink  @"https://itunes.apple.com/cn/app/apple-store/id1281455347?mt=8"

///分页每页默认个数
#define Per_Page_Size  20

#define WEAK(weakObj, obj)  __weak __typeof(&*obj)weakObj = obj;
#define WEAKSELF(weakSelf)  WEAK(weakSelf, self);
///在使用weak对象前最好转成strong,这样做的目的是防止weak对象多次加入autoreleasepool中，造成autoreleasepool一个对象多次加入
#define STRONGSELF(strongSelf)  __strong __typeof(&*weakSelf)strongSelf = weakSelf;
#define STRONG(strongObj)  __strong __typeof(&*weakObj)strongObj = weakObj;

//#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__] // String format


/**    Font    **/
// 系统字体
#define FONT_9              FontR(9)
#define FONT_10             FontR(10)
#define FONT_11             FontR(11)
#define FONT_12             FontR(12)
#define FONT_13             FontR(13)
#define FONT_14             FontR(14)
#define FONT_15             FontR(15)
#define FONT_16             FontR(16)
#define FONT_17             FontR(17)
#define FONT_18             FontR(18)
#define FONT_19             FontR(19)
#define FONT_20             FontR(20)
#define FONT_21             FontR(21)
#define FONT_22             FontR(22)
#define FONT_23             FontR(23)
#define FONT_24             FontR(24)
#define FONT_25             FontR(25)
#define FONT_26             FontR(26)
#define FONT_28             FontR(28)
#define FONT_30             FontR(30)
#define FONT_40             FontR(40)
#define FONT_42             FontR(42)

// -----------------font-----------------
//FZLTXHK--GBK1-0

//HYQiHei-GZS

// DZS 40
// DES 45
// HYQiHei-EZS 50
//FZLTXHK--GBK1-0 //lanren
//FZLTXHK //lxf
#define Font_HYQH(x)         [UIFont fontWithName:@"HYQiHei-DZS" size:x]
#define Font_HYQH_Bold(x)    [UIFont fontWithName:@"HYQiHei-DZS" size:x]

//字体 缩放size
#define Font_Name_Size(name, x)    Font_Name_FixSize(name, ratio2_fontScale*(x))
#define Font_Name_FixSize(name, x)    [UIFont fontWithName:name size:x]

//整个工程都默认用苹方字体
#define Font_Default(x)         Font_Name_FixSize(@"PingFangSC-Regular", x)
#define Font_Default_Bold(x)    Font_Name_FixSize(@"PingFangSC-Semibold", x)

#define ratio2_fontScale (ceilf(ratio2_scale*10)/10) // 省去小数点后第二两位的小数
#define FontBoldR(x)   Font_Default_Bold(ratio2_fontScale*(x))
#define FontR(x)       Font_Default(ratio2_fontScale*(x))

//字体  价格的
#define TXSJPriceFontName @"AppleSDGothicNeo-SemiBold"

//-----------------color----------------------
#define ColorOpacity(x,a) [UIColor colorWithRGB:x alpha:a]
#define Color(x) ColorOpacity(x,1)
//#define ColorClear     [UIColor clearColor]
//#define ColorRed       [UIColor redColor]
//#define ColorWhite     [UIColor whiteColor]
//#define ColorBlack     [UIColor blackColor]
//#define ColorDarkGray  [UIColor darkGrayColor]
#define Theme [TXSJTheme sharedInstance]
#define TXSJBarColor    [UIColor colorWithHexString:Theme.color.kBarColor]
#define TXSJSegSelectedColor [UIColor colorWithHexString:Theme.color.kSegSelectedColor]
#define TXSJDarkYellowColor [UIColor colorWithHexString:Theme.color.kDarkYellowColor]
#define TXSJBgColor [UIColor colorWithHexString:Theme.color.kBgColor]
#define TXSJAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define TXSJCacheManager [TXSJCacheEngine shareInstance]
#define TXSJShoppingCartManager [TXSJShoppingCartEngine shareInstance]
#define BaiduMobStatTracker [BaiduMobStat defaultStat]

#define kTitleColor UIColorHex(0x333333)//黑色字体
#define kTitleColor1 UIColorHex(0xaaaaaa)//黑色字体较浅
#define kLineColor UIColorHex(0xe5e5e5)//分割线
#define kLineColor2 UIColorHex(0xe6e6e6)//分割线
#define kLineColor3 UIColorHex(0xf8f8f8)//分割线
#define kLineColor1 UIColorHex(0xf4f4f4)//填充色
#define kTitleColor3 UIColorHex(0xfafafa)//填充色
#define kTitleColor4 UIColorHex(0xcccccc)//灰背景
#define kTitleColor2 UIColorHex(0xCCAA66)//黑橙色FEDE00
#define kTitleColor13 UIColorHex(0xFD5655)
#define kTitleColor14 UIColorHex(0xFECF00)
#define kTitleColor15 UIColorHex(0xFF8100)
#define kTitleColor16 UIColorHex(0xFFF6CA)
#define kTitleColor17 UIColorHex(0xFED100)
#define kTitleColor18 UIColorHex(0xFEDE00)

#define kTitleColor5 UIColorHex(0x999999)//黑色字体较浅
#define kTitleColor6 UIColorHex(0xFF4800)//红色
#define kContentColor UIColorHex(0x666666)
#define kLowerGrayColor UIColorHex(0x3f3f3f) //淡黑色 淡灰色
#define kTitleColor7 UIColorHex(0xd8d8d8)//黑色字体较浅
#define kTitleColor8 UIColorHex(0xffece5)
#define kTitleColor9 UIColorHex(0xffe123)
#define kTitleColor10 UIColorHex(0x68b217)
#define kTitleColor11 UIColorHex(0x181818)//tabbar背景
#define kTitleColor12 UIColorHex(0xFFFAE4)
#define kContentGrayColor UIColorHex(0x999999)
#define ksubContentColor UIColorHex(0xcccccc)//灰  除标题 普通正文外的  第三文本显示颜色～～应该
#define kPromotePriceColor UIColorHex(0xff4800)//偏红色  特价促销价格的颜色
#define kLitterYellowColor UIColorHex(0xCDAC69) //淡黄色 ～～评价里的 提交  超赞之类的有使用
#define kOrderWaitPayColor UIColorHex(0xFF4800)//订单状态  待支付


//分割线的高度
#define kLineNormalHeight 0.5f //分割线
//行间距的高度
#define TXSJLinePaddingHeight 5.f  
/*----------Margin--------*/
/** 一般的 左右间距  如cell的左右间距*/
#define TXSJCommonPadding UIScale(16.f)
/** 一般的 item间距  如collectioncell的两item间距*/
#define TXSJCommonItemPadding UIScale(15.f)
/** 一般的 上下左右间距  10  短间距*/
#define TXSJShortPadding UIScale(10.f)
/** 一般的 上下左右间距  20  长间距*/
#define TXSJLongPadding UIScale(20.f)

/** 首页 头部视图高度 iphoneX上高度UI给的定值，其它的按屏幕宽高缩放*/
#define HomeShoppingHeaderViewHeight (isiPhoneX ? UIScaleHeight(98) : UIScaleHeight(56))
/** 首页 每行的分类个数*/
#define HomePageClassificationEachRowCount 5
/** 首页 不同类型cell的复用标识符*/
#define TXSJBannerCellIdentifier @"TXSJBannerCellIdentifier"
#define TXSJClassificationCellIdentifier @"TXSJClassificationCellIdentifier"
#define TXSJSinglePictureCellIdentifier @"TXSJSinglePictureCellIdentifier"
#define TXSJNormalChannelCellIdentifier @"TXSJNormalChannelCellIdentifier"
#define TXSJNormalChannelNewCellIdentifier @"TXSJNormalChannelNewCellIdentifier"
#define TXSJCommonTitleCellIdentifier @"TXSJCommonTitleCellIdentifier"
#define TXSJTopicCellIdentifier @"TXSJTopicCellIdentifier"
#define TXSJMoreGoodsCellIdentifier @"TXSJMoreGoodsCellIdentifier"
#define TXSJHomeCellTypeOneRowMaxThreeGoodsIdentifier @"TXSJHomeCellTypeOneRowMaxThreeGoodsIdentifier"
#define TXSJSeperatorLineCellIdentifier @"TXSJSeperatorLineCell"
#define TXSJSeperatorSpaceCellIdentifier @"TXSJSeperatorSpaceCell" 
#define TXSJEveryDayHotSellCellIdentifier @"TXSJEveryDayHotSellCellIdentifier"
#define TXSJSpecialTitleCellIdentifier @"TXSJSpecialTitleCellIdentifier"

///通用footer的高度
#define TXSJFooterViewHeight UIScaleHeight(120.0f)
#define HeightNavBar          44
#define HeightSystemStatus    20
#define HeightTabBar          49
#define HeightOnSaleTabBar    44
#define HeightVCWithTab (kScreenHeight - HeightSystemStatus - HeightNavBar - HeightTabBar)
#define HeightVC (kScreenHeight - HeightSystemStatus - HeightNavBar)

#define ratio2_scale (kScreenWidth/375.f)
#define UIScale(x) ceil((x)*ratio2_scale)

///不按屏幕高度直接来缩放，所有缩放都要按照宽高比来缩放，优先以屏幕宽度来做适配
//#define UIScaleHeight(x) ((x)*kScreenHeight/667.f)
#define UIScaleHeight(x) UIScale(x)


#define ScreenPixel(x) (x/ScreenScale)  // 这里是屏幕上最终的像素值，比如分割线总是1，不管@2x @3x 屏幕

#define ScreenScale                 [UIScreen mainScreen].scale

//#define HeightSeperatorLine ScreenPixel(1)


//------QRCode Scan------
#define QRCodeScanViewHeight 210
#define QRCodeScanViewWidth 311

// -----------------image-----------------
#define ImageNamed(x)       [UIImage imageNamed:x]
#define ImageStretch(name,inset) [ImageNamed(name) resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch]
//默认图片 ～～ 据说还有其他样式
#define Default_IMG_1   ImageNamed(@"default_85_85") 
#define Default_head    ImageNamed(@"my_Avatar") 


//商品标签新品 限购等标签 宽度
#define TXSJGoodSymTypeBtnWidthNormal  UIScale(16)
#define TXSJGoodSymTypeBtnBorder  UIScale(28)
#define TXSJGoodSymTypeBtnBorderV11  UIScale(6)

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define SuppressPerformWdeprecatedDeclarations(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#ifndef dispatch_sync_main_safe
#define dispatch_sync_main_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}
#endif

#ifndef dispatch_async_main_safe
#define dispatch_async_main_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif


//kKeyWindow
#define kKeyWindow [UIApplication sharedApplication].keyWindow
  
// --------------------------------------------
/**
 * iOS SDK Version Check
 */
#define isIOS6      (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
#define isUponIOS7  (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
#define isUponIOS8  (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
#define IOS11 @available(iOS 11.0, *)

///iphone X
#define isiPhoneX  [TXSJCommonUtils deviceIsiPhoneX]

#define iPhoneXBottomDefaultHeight (isiPhoneX ? 34 : 0)


//保存网络状态
#define TXSJAFNetStatus @"AFNetStatus"
//保存版本号
#define currentBundle @"currentBundle"
//开启或者关闭 自动滚动
#define TXSJHomeAutoStatus @"TXSJHomeAutoStatus"

//登录通知
#define TXSJNotificationLogin @"TXSJNotificationLogin"
//登出通知
#define TXSJNotificationLoginOut @"TXSJNotificationLoginOut"
//广告结束 引导页也结束
#define TXSJNotificationADAndGuideEnd @"TXSJNotificationADAndGuideEnd"
//首页 滑动到顶部的 通知～～购物车去逛逛 要返回首页 并且滚动到第一页
#define TXSJNotificationMainHomeToFirstIndex @"TXSJNotificationMainHomeToFirstIndex"
//订单详情刷新通知
#define TXSJNotificationOrderDetailRefresh @"TXSJNotificationOrderDetailRefresh"
#define TXSJNotificationLoginCartRefresh @"TXSJNotificationLoginCartRefresh"
#define TXSJNotificationRefreshMineVC @"TXSJNotificationRefreshMineVC"
//购物车抖动通知
#define TXSJNotificationCartAnimation @"TXSJNotificationCartAnimation"
//版本更新弹框关闭通知
#define TXSJNotificationVersionUpdateDialogClose @"TXSJNotificationVersionUpdateDialogClose"

/** 评价 评级*/
#define TXSJEvaluationLevelOne @"吐槽"
#define TXSJEvaluationLevelTwo @"一般"
#define TXSJEvaluationLevelThird @"满意"
#define TXSJEvaluationLevelFour @"推荐"
#define TXSJEvaluationLevelFive @"力荐"

#define TXSJEvaluationPlaceHolderLevelOne @"再好一点会更好哦！"
#define TXSJEvaluationPlaceHolderLevelTwo @"一般一般，全球第三！"
#define TXSJEvaluationPlaceHolderLevelThird @"终于等到你，还好没放弃！"
#define TXSJEvaluationPlaceHolderLevelFour @"我给99分，还有1分怕你骄傲！"
#define TXSJEvaluationPlaceHolderLevelFive @"这绝对是好货中的战斗机！"
//客服电话
#define TXSJCustomerServicePhone @"400-632-1827"
//5星：力荐  默认文案：这绝对是好货中的战斗机！
//4星：推荐  默认文案：我给99分，还有1分怕你骄傲！
//3星：满意  默认文案：终于等到你，还好没放弃！
//2星：一般  默认文案：一般一般，全球第三！
//1星：吐槽  默认文案：再好一点会更好哦！

#define  TXSJGoodsStateSellOutText @"已售罄"
#define  TXSJGoodsStateDownText @"已下架"

#endif /* TXSJUIStyles_h */
