//
//  XGTCWebView.m
//  XGTCBaseLibrary
//
//  Created by 王定方 on 2017/11/27.
//

#import "XGTCWebView.h"
#import "XGTCWebViewProgressView.h"
#import <objc/runtime.h>
#import "WKWebView+XGJSBridgeTools.h"
#import "UIAlertController+XGTCAlert.h"
#import "UIColor+YYAdd.h"
#import "UIScreen+YYAdd.h"
#import "SDWebImageDownloader.h"
#import "UIView+Toast.h"
#import "XGTCBaseViewController.h"
#import "UINavigationItem+XGTC.h"
#import "View+MASAdditions.h"


@interface XGTCWebView () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIGestureRecognizerDelegate>

///progressView
@property (nonatomic, strong) XGTCWebViewProgressView *progressView;

///delegate, WKNavigationDelegate、WKUIDelegate可以不实现，这个只是把delegate转一下而已
@property (nonatomic, weak) id<XGTCWebviewDelegate, XGJSBWKWebViewNativeFunctionDelegate, WKUIDelegate, WKNavigationDelegate> xgtcDelegate;

@end

@implementation XGTCWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithSuperView:(UIView *)superView delegate:(id<XGTCWebviewDelegate, XGJSBWKWebViewNativeFunctionDelegate, WKUIDelegate, WKNavigationDelegate>)delegate {
    self = [super initWithFrame:superView.frame];
    if (self) {
        self.xgtcDelegate = delegate;

        //初始化subview
        [self setUpSubViews];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_webView xgjsb_removeScriptMessage];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    [self loadData];
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    [self loadData];
}

- (UIScrollView *)scrollView {
    return self.webView.scrollView;
}

- (void)setUpSubViews {
    if (_webView) {
        [_webView xgjsb_removeScriptMessage];
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [_webView removeObserver:self forKeyPath:@"title"];
    }
    self.firstTime = YES;
    //    _webView = [[WKWebView alloc] initWithFrame:self.bounds];

    _webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:[WKWebView xgjsb_createConfigurationWithHandle:self]];

    _webView.backgroundColor = self.backgroundColor;
    _webView.functionDelegate = self.xgtcDelegate;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

    _webView.allowsBackForwardNavigationGestures = YES;

    ///不要iphoneX上的偏移
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }


    //添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
    longPress.delegate = self;
    [_webView addGestureRecognizer:longPress];

    [self addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _progressView = [[XGTCWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2)];
    [_progressView setProgress:0 animated:NO];
    _progressView.progressBarView.backgroundColor = [UIColor colorWithHexString:@"#ff7800"];
    [self addSubview:_progressView];
    [self bringSubviewToFront:_progressView];

    ///webview已经设置完成，回调业务方，看还有什么要设置了(因为setUpSubViews在init里调的，afterSetUp回调可能会用到XGTCWebView的实例，如果直接调用实例还没有返回是nil,会出现再操作不起作用的bug)
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(xgtc_afterSetUpWebView)]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.xgtcDelegate xgtc_afterSetUpWebView];
        });

    }

    ///把全局的都给改了，ios9后设置customUserAgent一样有些网页打不开，例如：https://fresh.jd.com
    //User-Agent
    __weak typeof (self) weakSelf = self;
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *oldAgent = result;
        NSLog(@"###WDF oldAgent = %@", oldAgent);
        if (![oldAgent containsString:@"Custom-User-Agent"]) {
            NSString *ua = nil;
            if (strongSelf.xgtcDelegate && [strongSelf.xgtcDelegate respondsToSelector:@selector(xgtc_userAgent)]) {
                ua = [strongSelf.xgtcDelegate xgtc_userAgent];
            }
            // 给User-Agent添加额外的信息
            NSString *newAgent = [NSString stringWithFormat:@"%@;%@ %@", oldAgent, @"Custom-User-Agent", ua];
            // 设置global User-Agent
            ///1.改全局的  2.直接设置到customUserAgent
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newAgent, @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
            //            NSDictionary *dictionary = @{@"UserAgent": ua, @"User-Agent": ua};
            //            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
            ////2.0
            //            self.webView.customUserAgent = newAgent;

            ///如果第一次加custom ua 只有重新初始化webview后请求才能拿到新的ua,要不然就是拿不到
            [strongSelf setUpSubViews];
            [strongSelf loadData];
        }
    }];

    //方法只能调用一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setWkWebViewShowKeybord];
    });
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

///下拉刷新时防止url是静态改变的要先检查一下url是否一致（不能直接写loadData里，要不然webview有url后通过setUrl去更新url的话会不起作用了）
- (void)checkAndUpdateUrl {
    ///有h5直接改变url，界面不用刷新，这边就监听不到真实的url，下拉刷新会导致出错
    NSURL *realUrl = self.webView.URL;
    if (self.urlStr.length) {
        ///更新成最新的urlStr
        if (realUrl && ![self.urlStr isEqualToString:realUrl.absoluteString]) {
            _urlStr = realUrl.absoluteString;
        }
    }else {
        ///更新成最新的url
        if (realUrl && ![realUrl.absoluteString isEqualToString:self.url.absoluteString]) {
            _url = realUrl;
        }
    }
}

- (void)loadData {
    NSMutableURLRequest *request = nil;
    if (self.urlStr.length) {
        NSURL *url = [NSURL URLWithString:self.urlStr];
        request = [NSMutableURLRequest requestWithURL:url];
    }else {
        request = [NSMutableURLRequest requestWithURL:self.url];
    }

    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    [self.webView loadRequest:request];
}

///在container容器销毁时，或者pop时记得调一下，免得容器销毁了有js的调用会crash
- (void)preDealloc {
    [_webView xgjsb_removeScriptMessage];
}

///用默认格式生成customua
- (NSString *)generateCustomUserAgent:(NSString *)appScheme userId:(NSString *)userId userToken:(NSString *)userToken udid:(NSString *)udid {

    NSString *userAgent = nil;
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    userAgent = [NSString stringWithFormat:@"%@/%@ (token %@; userid %@; joker1 %@; %@; iOS %@; Scale/%0.2f; channel %@)", appScheme ? appScheme : @"", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey],userToken ?:@"",userId ? userId : @"", udid ?:@"", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale], @"default"];

    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
    }

    return userAgent;
}


#pragma mark - 解决H5自动聚焦的问题
static void (*originalIMP)(id self, SEL _cmd, void* arg0, BOOL arg1, BOOL arg2, id arg3) = NULL;
void interceptIMP (id self, SEL _cmd, void* arg0, BOOL arg1, BOOL arg2, id arg3) {
    originalIMP(self, _cmd, arg0, TRUE, arg2, arg3);
}

- (void)setWkWebViewShowKeybord {
    Class cls = NSClassFromString(@"WKContentView");
    SEL originalSelector = NSSelectorFromString(@"_startAssistingNode:userIsInteracting:blurPreviousNode:userObject:");
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    IMP impOvverride = (IMP) interceptIMP;
    originalIMP = (void *)method_getImplementation(originalMethod);
    method_setImplementation(originalMethod, impOvverride);
}

#pragma mark - codeFeature mehods

- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer {
    ///没有告知vc,就不能弹框，后面的操作就不用做了
    if (![self containerViewController] || gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }

    CGPoint touchPoint = [gestureRecognizer locationInView:self.webView];
    // get image url where pressed.
    NSString *tagJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", touchPoint.x, touchPoint.y];

    __weak typeof (self) weakSelf = self;
    [self.webView evaluateJavaScript:tagJS completionHandler:^(id _Nullable tagName, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (![tagName isEqualToString:@"IMG"]) return;

        NSString *imgJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];

        [strongSelf.webView evaluateJavaScript:imgJS completionHandler:^(id _Nullable imageUrl, NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSString *featureMessage = [strongSelf getFeatureMessageWithPressPoint:touchPoint];

            if (!imageUrl) {
                [strongSelf setActionSheetWithFeature:featureMessage image:nil url:nil];
                return;
            } else {
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf setActionSheetWithFeature:featureMessage image:image url:imageUrl];
                    return;
                }];
            }
        }];
    }];
}

- (void)setActionSheetWithFeature:(NSString *)featureMessage image:(UIImage *)image url:(NSString *)url{
    if (!featureMessage.length && !image) {
        return;
    }

    UIAlertController *alert = [UIAlertController xg_initActionSheetWithTitle:nil message:nil actionBlock:^(NSInteger buttonIndex) {

    }];


    if (featureMessage) {
        __weak typeof(self) weakSelf = self;
        UIAlertAction *featureAction = [UIAlertAction actionWithTitle:@"识别图中二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.xgtcDelegate && [strongSelf.xgtcDelegate respondsToSelector:@selector(xgtc_recognizerQRCodeMessage:)]) {
                [strongSelf.xgtcDelegate xgtc_recognizerQRCodeMessage:featureMessage];
            }
        }];

        [alert addAction:featureAction];
    }

    if (image) {
        UIAlertAction *saveImage = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];

        [alert addAction:saveImage];
    }

    if (url) {
        UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"拷贝" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
            [UIPasteboard generalPasteboard].URL = [NSURL URLWithString:url];
        }];

        [alert addAction:copyAction];
    }

    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *  action) {

    }];

    [alert addAction:cancleAction];


    [[self containerViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [self makeToast:@"保存失败" duration:1.5 position:CSToastPositionCenter];
    } else {
        [self makeToast:@"图片已保存至相册" duration:1.5 position:CSToastPositionCenter];
    }
}

- (NSString *)getFeatureMessageWithPressPoint:(CGPoint)point {
    ///如果没有实现识别二维码的方法，直接不做识别
    if (!self.xgtcDelegate || ![self.xgtcDelegate respondsToSelector:@selector(xgtc_recognizerQRCodeMessage:)]) {
        return nil;
    }

    UIImage *image = [self getScreenShot];

    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];

    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];

    if (features.count == 1) {
        //图片中只有一个二维码，直接获取二维码信息
        CIQRCodeFeature *feature = [features firstObject];
        return feature.messageString;
    } else if(features.count > 1) {
        //图片上有两个或以上二维码
        for (CIQRCodeFeature *feature in features) {
            //点击到其中一个二维码，识别点击的二维码
            if (CGRectContainsPoint([self getCustomRectWithFeatureCGRect:feature.bounds], point)) {
                return feature.messageString;
            }
        }
        //没有点击到二维码，默认识别第一个
        CIQRCodeFeature *feature = [features firstObject];
        return feature.messageString;
    } else {
        return nil;
    }
}

- (UIImage *)getScreenShot {
    UIGraphicsBeginImageContextWithOptions(self.webView.bounds.size, NO, [UIScreen screenScale]);
    [self.webView drawViewHierarchyInRect:self.webView.bounds afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

- (CGRect)getCustomRectWithFeatureCGRect:(CGRect)rect {
    CGFloat screenScale = [UIScreen screenScale];
    return CGRectMake(rect.origin.x / screenScale, self.webView.bounds.size.height - CGRectGetMaxY(rect) / screenScale, rect.size.width / screenScale, rect.size.height / screenScale);
}


#pragma mark -- WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(webView:createWebViewWithConfiguration:forNavigationAction:windowFeatures:)]) {
        return [self.xgtcDelegate webView:webView createWebViewWithConfiguration:configuration forNavigationAction:navigationAction windowFeatures:windowFeatures];
    }

    return nil;
}

- (void)webViewDidClose:(WKWebView *)webView {
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(webViewDidClose:)]) {
        if (@available(iOS 9.0, *)) {
            [self.xgtcDelegate webViewDidClose:webView];
        } else {
            // Fallback on earlier versions
        }
        return;
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(webView:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:)]) {
        [self.xgtcDelegate webView:webView runJavaScriptAlertPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
        return;
    }
    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];

    [[self containerViewController] presentViewController:alertController animated:YES completion:^{}];

}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(webView:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:)]) {
        [self.xgtcDelegate webView:webView runJavaScriptConfirmPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
        return;
    }

    //  js 里面的alert实现，如果不实现，网页的alert函数无效  ,
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];

    [[self containerViewController] presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(webView:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:)]) {
        [self.xgtcDelegate webView:webView runJavaScriptTextInputPanelWithPrompt:prompt defaultText:defaultText initiatedByFrame:frame completionHandler:completionHandler];
        return;
    }
}

#pragma mark -- WKScriptMessageHandler
///js 交互的
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"message.body = %@", message.body);

    [self.webView xgjsb_responseWebViewWithReceiveMessage:message];
}

#pragma mark -- WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //如果是跳转一个新页面,直接用这个webview去loadRequest
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }

    ///如果真实业务有重写就按真实业务的来，没有就用默认的
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [self.xgtcDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }else {
        ///默认允许所有
        decisionHandler(WKNavigationActionPolicyAllow);
    }

}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    ///如果真实业务有重写就按真实业务的来，没有就用默认的
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationResponse:decisionHandler:)]) {
        [self.xgtcDelegate webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
    }else {
        ///默认允许所有
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}


- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(webView:didReceiveServerRedirectForProvisionalNavigation:)]) {
        [self.xgtcDelegate webView:webView didReceiveServerRedirectForProvisionalNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    ///执行真实业务操作
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
        [self.xgtcDelegate webView:webView didFailNavigation:navigation withError:error];
    }
}

///这个只有iOS9以后才有回调
#ifdef NSFoundationVersionNumber_iOS_8_x_Max
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    ///执行真实业务操作
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(webViewWebContentProcessDidTerminate:)]) {
        if (@available(iOS 9.0, *)) {
            [self.xgtcDelegate webViewWebContentProcessDidTerminate:webView];
        } else {
            // Fallback on earlier versions
        }
    }
}
#endif

/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
    ///执行真实业务操作
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [self.xgtcDelegate webView:webView didStartProvisionalNavigation:navigation];
    }
    self.progressView.hidden = NO;
}

/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
    ///执行真实业务操作
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(webView:didCommitNavigation:)]) {
        [self.xgtcDelegate webView:webView didCommitNavigation:navigation];
    }
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
    ///执行真实业务操作
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [self.xgtcDelegate webView:webView didFinishNavigation:navigation];
    }

    ///判断一下是否要显示叉叉按钮
    [self updateLeftNavBarItems];
    self.firstTime = NO;

    self.progressView.hidden = YES;
    // 不执行前段界面弹出列表的 JS 代码
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    ///执行真实业务操作
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [self.xgtcDelegate webView:webView didFailProvisionalNavigation:navigation withError:error];
    }
    //    if (error.message.length) {
    //        [JDStatusBarNotification showWithStatus:error.message dismissAfter:1.5 styleName:JDStatusBarStyleError];
    //    }
    self.firstTime = NO;

    self.progressView.hidden = YES;
}


///https的认证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    ///这个如果业务实现了，这边就不做了
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(webView:didReceiveAuthenticationChallenge:completionHandler:)]) {
        [self.xgtcDelegate webView:webView didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
    }else {
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if ([challenge previousFailureCount] == 0) {
                NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
            } else {
                completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
            }
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
}

#pragma --mark KVO监测加载进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.webView) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];

            if(self.webView.estimatedProgress >= 1.0f) {

                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(xgtc_updateNavgitionTitle:)]) {
                [self.xgtcDelegate xgtc_updateNavgitionTitle:self.webView.title];
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma --mark Actions
- (void)popBack:(id)sender {

    if ([self.webView canGoBack]) {
        [self.webView goBack];
        return;
    }

    ///要销毁
    [self preDealloc];

//    if (self.navigationController.presentingViewController && self.navigationController.viewControllers.count == 1) {
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    } else {
        [self.xgtcDelegate xgtc_backAction];
//    }
}

- (void)clickedCloseItem:(UIButton *)sender {
    [self preDealloc];
    if (self.navigationController.presentingViewController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSArray<UIViewController *> *vcs = self.navigationController.viewControllers;
        UIViewController *popVc = nil;
        for (NSInteger i = vcs.count - 1; i > 0; i--) {
            UIViewController *vc = vcs[i];
            if (![vc isMemberOfClass:[[self containerViewController] class]]) {
                popVc = vc;
                break;
            }
        }

        if (popVc) {
            [self.navigationController popToViewController:popVc animated:YES];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

///更新左边按钮,这个只执行一次，后面就不变了
- (void)updateLeftNavBarItems {
    if (self.closeButton || self.firstTime) {
        return;
    }

    ///初始时goback一般都为NO
    if (![self.webView canGoBack]) {
        return;
    }

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 72, XGTCBaseImageNavBarWidth)];
    UIButton *backItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, XGTCBaseImageNavBarWidth, XGTCBaseImageNavBarWidth)];
    [backItem setImage:[UIImage imageNamed:[self backButtonImageName]] forState:UIControlStateNormal];
    backItem.exclusiveTouch = YES;
    [backView addSubview:backItem];

    UIButton *closeItem = [[UIButton alloc]initWithFrame:CGRectMake(35, 0, XGTCBaseImageNavBarWidth, XGTCBaseImageNavBarWidth)];
    [closeItem setImage:[UIImage imageNamed:[self closeButtonImageName]] forState:UIControlStateNormal];
    closeItem.exclusiveTouch = YES;
    [backView addSubview:closeItem];
    UIBarButtonItem *navBackItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    [backItem addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    [closeItem addTarget:self action:@selector(clickedCloseItem:) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton = closeItem;
    if ([self.containerViewController isKindOfClass:[XGTCBaseViewController class]]) {
        ((XGTCBaseViewController *)[self containerViewController]).leftCustomButton = backItem;
    }

    [[self containerViewController].navigationItem xgtc_setLeftBarButtonItem:navBackItem];
}

- (UINavigationController *)navigationController {
    if ([self containerViewController].parentViewController.navigationController) {
        return [self containerViewController].parentViewController.navigationController;
    }
    return [[self containerViewController] navigationController];
}

///当前webview 包裹的vc
- (UIViewController *)containerViewController {
    if (!self.xgtcDelegate || ![self.xgtcDelegate respondsToSelector:@selector(xgtc_containerViewController)]) {
        return nil;
    }

    return [self.xgtcDelegate xgtc_containerViewController];;
}

///返回按钮图片
- (NSString *)backButtonImageName {
    NSString *defaultImageName = nil;
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(xgtc_backButtonImageName)]) {
        defaultImageName = [self.xgtcDelegate xgtc_backButtonImageName];
    }

    if (!defaultImageName) {
        defaultImageName = @"xgtc_white_back";
    }
    return defaultImageName;
}
///关闭按钮图片
- (NSString *)closeButtonImageName {
    NSString *defaultImageName = nil;
    if (self.xgtcDelegate && [self.xgtcDelegate respondsToSelector:@selector(xgtc_closeButtonImageName)]) {
        defaultImageName = [self.xgtcDelegate xgtc_closeButtonImageName];
    }

    if (!defaultImageName) {
        defaultImageName = @"xgtc_close_back";
    }
    return defaultImageName;
}


#pragma --mark 方法替换
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.xgtcDelegate respondsToSelector:aSelector]) {
        return self.xgtcDelegate;
    }

    return [super forwardingTargetForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL aSelector = [anInvocation selector];
    if ([self.xgtcDelegate respondsToSelector:aSelector]) {
        [anInvocation invokeWithTarget:self.xgtcDelegate];
    }
}

@end
