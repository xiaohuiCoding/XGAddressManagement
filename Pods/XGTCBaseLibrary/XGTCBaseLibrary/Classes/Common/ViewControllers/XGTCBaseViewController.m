//
//  XGTCBaseViewController
//  XGOA
//
//  Created by wangdf on 2017/4/7.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#import "XGTCBaseViewController.h"
#import "UIView+Toast.h"
#import "UINavigationItem+XGTC.h"


@interface XGTCBaseViewController ()<UIGestureRecognizerDelegate>

///蒙层
@property (strong, nonatomic) UIView *maskView;

@end

@implementation XGTCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //不让系统给边缘view添加偏移
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
//    ///定制导航器统一样式
//    self.navigationController.navigationBar.barTintColor = XGOABaseView_NAVColor;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];


    ///默认如果是push过来的都要显示返回按钮，如果有特殊需求，可以主动去隐藏或自定义
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationItem xgtc_setLeftBarButtonItem:self.leftBarButtonItem];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window) {   // 是否是正在使用的视图
        NSLog(@"####WDF 收到内存警告了，把不在当前显示的view都清空，等下次用的时候再创建");
        self.maskView = nil;
        //后期优化处理
        //self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ///显示引导页，如果界面有特殊需求，可以showMaskImg返回NO或者不重写，直接在要显示的地方去主动调一下checkShowMaskView
    ///如果以后放在viewDidLoad有被别的覆盖到，可以移动viewWillAppear中去执行下面代码
    if ([self showMaskImg]) {
        [self checkShowMaskView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    ///设置了leftBar后，默认的手势返回就失效了，所以要主动调一下
    ///放在这里是防止前面一个navigationController的正在动画中时更改会假死的，也可以集成UINavigationController在delegate中等动画执行完后去禁用或启用
    [self usePopGesture];
}


///禁用左滑返回
- (void)cancelPopGesture {
    if (self.navigationController) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

///打开左滑手势返回
- (void)usePopGesture {
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }else {
        [self cancelPopGesture];
    }
}

///topviewcontroller 主要是presen新viewCotroller的时候要检查是不是最上面的一个
- (UIViewController *)XGOATopViewController {
    UIViewController *top = self;

    UIViewController *above;
    while ((above = top.presentedViewController)) {
        top = above;
    }

    return top;
}

///显示错误
- (void)showToastMessage:(NSString *)message {
    [self showToastMessage:message position:CSToastPositionCenter];
}
- (void)showToastMessage:(NSString *)message position:(id)position {
    [self showToastMessage:message duration:[self showDurationWithMessage:message] position:position];
}
- (void)showToastMessage:(NSString *)message duration:(NSTimeInterval)duration position:(id)position {
    [self.view makeToast:message duration:duration position:position];
}

///根据显示文本计算显示时间
- (NSTimeInterval)showDurationWithMessage:(NSString *)message {
    if (message.length > 30) {
        return 3.0;
    }else if (message.length > 20) {
        return 2.0;
    }
    return 1.5;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

////统一的back button
- (UIBarButtonItem *)leftBarButtonItem {
    if (!_leftBarButtonItem) {
        if (!_backImage) {
            _backImage = [UIImage imageNamed:@"xgtc_white_back"];
        }

        CGSize defaultSize = CGSizeMake(XGTCBaseImageNavBarWidth, XGTCBaseImageNavBarWidth);
        UIImage *backButtonImage = self.backImage;
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        if (!_backImage) {
            [backButton setTitle:@"Back" forState:UIControlStateNormal];
            backButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else {
            if (backButtonImage.size.width > defaultSize.width) {
                defaultSize.width = backButtonImage.size.width;
            }
            if (backButtonImage.size.height > defaultSize.height) {
                defaultSize.height = backButtonImage.size.height;
            }
            [backButton setImage:backButtonImage forState:UIControlStateNormal];
        }

        backButton.frame = CGRectMake(0, 0, defaultSize.width, defaultSize.height);
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        _leftBarButtonItem = backBarButtonItem;
    }

    return _leftBarButtonItem;
}

- (void)setBackImage:(UIImage *)backImage {
    _backImage = backImage;
    ///如果已经初始化过了，就重新初始化一次
    if (_leftBarButtonItem) {
        _leftBarButtonItem = nil;
    }

    ///如果是主动调的设置，那就不用判断是否前面有viewController了
    [self.navigationItem xgtc_setLeftBarButtonItem:self.leftBarButtonItem];
}


-(UIButton *)rightButton {
    if (!_rightButton) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, XGTCBaseImageNavBarWidth, XGTCBaseImageNavBarWidth);
        [rightButton setTitleColor:[UIColor colorWithWhite:1.f alpha:0.5f] forState:UIControlStateDisabled];
        [rightButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        [self.navigationItem xgtc_setRightBarButtonItem:rightBarButtonItem];
        _rightButton = rightButton;
    }
    return _rightButton;
}

-(UIButton *)leftCustomButton {
    if (!_leftCustomButton) {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, XGTCBaseImageNavBarWidth, XGTCBaseImageNavBarWidth);
        [leftButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *lefttBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        [self.navigationItem xgtc_setLeftBarButtonItem:lefttBarButtonItem];
        _leftCustomButton = leftButton;
    }
    return _leftCustomButton;
}

- (IBAction)backAction:(id)sender {
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)leftButtonClicked:(id)sender {
    NSLog(@"%s", __func__);
    [self backAction:nil];
}

///子类可重写此方法实现点击事件
- (void)rightButtonClicked:(id)sender {
    NSLog(@"%s", __func__);
}


#pragma --mask view 对所有界面的蒙层引导做个通一处理的地方
///是否显示引导
- (BOOL)showMaskImg {
    return NO;
}

/* 是否需要自己控制 关闭显示 */
-(BOOL)isNeedUserClosed {
    return NO;
}

///是否有下一次的引导
- (BOOL)hasNextMask {
    return NO;
}

///蒙层关闭后事件
- (void)afterCloseMaskView {

}

///默认没有key
- (NSString *)maskShowKey {
    return nil;
}

///子view的引导
- (UIView *)maskViewWithSonClass:(CGSize)windowSize {
    return nil;
}

///关闭引导，如果子类要改变关闭方法的话，只要重写这个方法就好了，不用再新把添加mask的代码copy一份
- (void)close:(id)sender {
    if (_maskView.superview != nil) {
        [_maskView removeFromSuperview];
    }
    _maskView.hidden = YES;
    ///每次释放一下，毕竟一个页面多次提醒是少数，每次不释放，空点的内存
    _maskView = nil;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[self maskShowKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];


    ///如果还有下一个引导的放就做下一次的引导
    if ([self hasNextMask]) {
        [self checkShowMaskView];
    }else {
        ///蒙层关闭后事件
        [self afterCloseMaskView];
    }
}

///当前是否有蒙层引导页显示着
- (BOOL)hasMaskViewShowing {
    return [_maskView superview];
}

- (UIWindow *)maskWindow {
    ///取最后一个，稍微大点的window，一般情况可以直接使用keyWindow
    NSArray *windows = [UIApplication sharedApplication].windows;
    NSEnumerator *enumerator = [windows reverseObjectEnumerator];
    UIWindow *window;
    while (window = [enumerator nextObject]) {
        if (window && window.bounds.size.height >= 480){
            break;
        }
    }
    return window;
}

- (void)clearMaskView {
    for (UIView *view in [_maskView subviews]) {
        [view removeFromSuperview];
    }
}

- (void)setupMaskView {
    UIWindow *window = [self maskWindow];
    UIView *subMaskView = [self maskViewWithSonClass:window.bounds.size];
    if (!subMaskView) {
        return;
    }

    [self clearMaskView];
    [_maskView removeFromSuperview];
    UIColor *bgColor = [self maskBackGroupColor];
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
        _maskView.backgroundColor = bgColor;
    }

    
    if (![bgColor isEqual:[UIColor clearColor]]) {
        subMaskView.backgroundColor = [UIColor clearColor];
    }

    [_maskView addSubview:subMaskView];
//    WEAKSELF(weakSelf);
//    [subMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONGSELF(strongSelf);
//        make.edges.equalTo(strongSelf.maskView);
//    }];

    if(!self.isNeedUserClosed){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _maskView.bounds.size.width, _maskView.bounds.size.height)];
        [btn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [_maskView addSubview:btn];
    }
}



- (void)checkShowMaskView {
    NSString *key = [self maskShowKey];
    if (!key.length) {
        return;
    }

    BOOL showHelp = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    /* 第一次进入该主页 */
     if (showHelp == NO) {
        [self setupMaskView];
        [self showMaskView];
     }
}

///引导背景颜色(如果引导页设计需要不能用整张背景图时需要自定义的时候，这个函数就返回clearColor)
- (UIColor *)maskBackGroupColor {
    return [UIColor colorWithWhite:0 alpha:0.3];
}

- (void)showMaskView {
    if (_maskView.superview == nil) {
        UIWindow *window = [self maskWindow];
        [window addSubview:_maskView];
    }
    _maskView.hidden = NO;
}

#pragma --mark 屏幕旋转
- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


- (NSUInteger)appSupportedInterfaceOrientations {
    //    NSBundle *mainBundle = [NSBundle mainBundle];
    //    NSDictionary *infoDictionary = [mainBundle infoDictionary];
    //    NSArray *array = [infoDictionary arrayObjectForKey:@"UISupportedInterfaceOrientations"];
    //
    //    NSUInteger suported = UIInterfaceOrientationMaskPortrait;
    //    for (NSString * or in array) {
    //        if ([or isKindOfClass:[NSString class]]) {
    //            suported |= or.integerValue;
    //        }
    //    }
    //
    //    return suported;

    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


#pragma --mark StatusBar State
///默认是显示的，如果要想不显示return Yes
- (BOOL)prefersStatusBarHidden {
    return NO;
}

///默认用黑的
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

@end
