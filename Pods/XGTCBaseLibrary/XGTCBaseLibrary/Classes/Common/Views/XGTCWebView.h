//
//  XGTCWebView.h
//  XGTCBaseLibrary
//
//  Created by 王定方 on 2017/11/27.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol XGJSBWKWebViewNativeFunctionDelegate;
@protocol XGTCWebviewDelegate <NSObject>
@required
///一定要有UA,要不然h5不认识是不是客户端打开的 , 如果想用默认格式，调generateCustomUserAgent：：：方法生成即可
- (NSString *)xgtc_userAgent;

///webview所在的conctroller
- (UIViewController *)xgtc_containerViewController;

///返回事件
- (void)xgtc_backAction;

@optional

///识别网页中的二维码,功能默认就有，只有实现这个方法了才给显示选择条目，要不然点了没事做
- (void)xgtc_recognizerQRCodeMessage:(NSString *)messgae;

///设置完webview后操作，底层不会对webview进行设置下拉刷新上拉加载的操作，所以需要业务方自己去设置
- (void)xgtc_afterSetUpWebView;

///通过获取html中的title去改变navgaition的title(如果jsbridge有设置会有期相关的方法)
- (void)xgtc_updateNavgitionTitle:(NSString *)title;

///返回按钮图片
- (NSString *)xgtc_backButtonImageName;
///关闭按钮图片
- (NSString *)xgtc_closeButtonImageName;

@end

@interface XGTCWebView : UIView

- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithSuperView:(UIView *)superView delegate:(id<XGTCWebviewDelegate, XGJSBWKWebViewNativeFunctionDelegate, WKUIDelegate, WKNavigationDelegate>)delegate NS_DESIGNATED_INITIALIZER;

////设置url
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, copy) NSString * urlStr;

///真实webview
@property (nonatomic, strong, readonly) WKWebView * webView;

///scrollview
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

///是否第一次加载
@property (nonatomic, assign) BOOL firstTime;

///生成默认的Custom-User-Agent
- (NSString *)generateCustomUserAgent:(NSString *)appScheme userId:(NSString *)userId userToken:(NSString *)userToken udid:(NSString *)udid;

///加载数据
- (void)loadData;

///下拉刷新时防止url是静态改变的要先检查一下url是否一致（不能直接写loadData里，要不然webview有url后通过setUrl去更新url的话会不起作用了）
- (void)checkAndUpdateUrl;

///在container容器销毁时，或者pop时记得调一下，免得容器销毁了有js的调用会crash
- (void)preDealloc;

///------下面的是containerVC的navBar相关按钮
///左边的closeButton
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIButton * shareButton;
@end
