//
//  TXSJBaseViewController.m
//  retail
//
//  Created by apple on 2017/7/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJBaseViewController.h"
#import "TXSJTheme.h"
#import "TXSJPopupView.h"
//#import "TXSJShoppingCartEngine.h"
@interface TXSJBaseViewController ()
@property (nonatomic, strong, readwrite) TXSJViewModel *viewModel;

@property (nonatomic,strong) UIImage *defaultImg;
@property (nonatomic,strong) NSString *defaultTitle;
@property (nonatomic,strong) NSString *defaultBtnTitle;

@end

@implementation TXSJBaseViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    TXSJBaseViewController *viewController = [super allocWithZone:zone];

    WEAK(weakObj, viewController);
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         STRONG(strongObj);
         [strongObj setUpSubviews];
         [strongObj bindViewModel];
     }];
    
    return viewController;
}

- (TXSJBaseViewController *)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TXSJBgColor;
    [self shakeAnimationImageViewCart];
    ///定制导航器统一样式
    [self navBarUI];
}

- (void)navBarUI {
    ///左边返回按钮
    if (self.navigationController.viewControllers.count > 1) {
//        self.backImage = [UIImage imageNamed:@"icon_back"];
    }
    //导航栏下方的横线颜色
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:kLineColor2]];
    //
    ///定制导航器统一样式, 字体要18，苹方
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kTitleColor, NSFontAttributeName:FontR(18)}];
    //设置导航栏背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;//使设置的导航栏颜色不失真

    ///右侧按钮
//    [self reloadRightBarButtons];
}

- (void)setShowShareButton:(BOOL)showShareButton {
    BOOL changed = self.showShareButton != showShareButton;
    _showShareButton = showShareButton;
    if (changed) {
        [self reloadRightBarButtons];
    }
}

///刷新右侧按钮
//- (void)reloadRightBarButtons {
//    ///所有的二级页面都默认有购物车按钮，分享按钮默认在很多页面都显示
//    if (self.navigationController.viewControllers.count > 1) {
//
//        ///购物车是默认是一直显示着的（个别可能不显示），但是分享是要具体界面才会显示分享按钮
//        NSMutableArray *itemsArray = [NSMutableArray array];
//
//        if ([self showShareButton]) {
//            UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
//            [itemsArray addObject:shareButton];
//        }
//
//        if ([self showShoppintCartButton]) {
//            //监听 购物车变化
//            WEAKSELF(weakSelf);
//            [[RACObserve(TXSJShoppingCartManager, shoppCartAmont) ignore:nil] subscribeNext:^(id  x) {
//                STRONGSELF(strongSelf);
//                if ([x integerValue] > 0 && [x integerValue] < 100) {
//                    strongSelf.badgeLable.hidden = NO;
//                    strongSelf.badgeLable.text = [NSString stringWithFormat:@"%@",x];
//                }else if ([x integerValue] > 99){
//                    strongSelf.badgeLable.hidden = NO;
//                    strongSelf.badgeLable.text = @"99+";
//                }else {
//                    strongSelf.badgeLable.hidden = YES;
//                }
//
//            }];
//            UIBarButtonItem *shoppingCart = [[UIBarButtonItem alloc] initWithCustomView:self.shoppingCartButton];
//            [self.shoppingCartButton addSubview:self.badgeLable];
//            [itemsArray addObject:shoppingCart];
//        }
//        [self.navigationItem xgtc_setRightBarButtonItems:itemsArray];
//    }
//}

- (void)toastMessageTitle:(NSString *)title {
    [self toastMessageTitle:title toastImageStr:nil];
}
- (void)toastMessageTitle:(NSString *)title toastImageStr:(NSString *)str {
    [self.view toastMessageTitle:title toastImageStr:str];
}

- (void)bindViewModel {
    
}

///navBar的高度
- (CGFloat)navBarHeight {
    CGFloat height = 0;
    ///如果navbar是隐藏的就直接返回0
    if ([self prefersStatusBarHidden]) {
        return height;
    }

    height += [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;

    return height;
}

//loading动画
-(void)showLoading{
//    [self showLoadingInView:self.view];
    [self.view txsjLoading];
}

//loading动画
-(void)hiddenLoading{
    [self.view hudCleanUp:YES];
//    [self hiddenLoadingFromView:self.view];
}

//-(void)showLoadingInView:(UIView *)view{
//    UIImageView *firstImg = [view viewWithTag:9999];
//    if(firstImg){
//        return;
//    }
//    firstImg = [[UIImageView alloc] initWithImage:ImageNamed(@"动画_00000")];
//    firstImg.tag = 9999;
//    CGFloat loadingWidth = UIScale(60);
//    firstImg.frame = CGRectMake(self.view.centerX - loadingWidth/2, self.view.centerY - loadingWidth/2, loadingWidth, loadingWidth);
//    [self.view addSubview:firstImg];
//    NSMutableArray *imgsArr = [NSMutableArray array];
//    for (int i=0; i<=56; i++) {
//        UIImage *img =  [UIImage imageNamed:[NSString stringWithFormat:@"动画_000%02d",i]];
//        [imgsArr addObject:img];
//    }
//    firstImg.animationImages = imgsArr;
//
//    [firstImg startAnimating];
//}
//
//-(void)hiddenLoadingFromView:(UIView *)view{
//    UIImageView *firstImg = [view viewWithTag:9999];
//    if(firstImg){
//        [firstImg removeFromSuperview];
//    }
//}


//无数据时候的 默认图片 布局

-(void)setDefaultImg:(UIImage *)defaultImg defaultTitle:(NSString *)defaultTitle defaultBtnTitle:(NSString *)defaultBtnTitle{
    _defaultImg = defaultImg;
    _defaultTitle = defaultTitle;
    _defaultBtnTitle = defaultBtnTitle;
}

-(void)showNodataInView:(UIView *)parentView isShow:(BOOL)isShow {
     [_defaultView removeFromSuperview];
    if(!isShow){
        return;
    }
    _defaultView = [self getDefaultView:parentView];
}

-(UIView *)getDefaultView:(UIView *)parentView{
    UIView *needDefaultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentView.width, 0)];
    UIImageView *defaultIV  = [[UIImageView alloc] initWithImage:self.defaultImg];
    [needDefaultView addSubview:defaultIV];
    defaultIV.sd_layout.topSpaceToView(needDefaultView, 0)
    .centerXEqualToView(needDefaultView)
    .widthIs(self.defaultImg.size.width)
    .heightIs(self.defaultImg.size.height);
    
    UILabel *defaultLab = [[UILabel alloc] init];
    defaultLab.textColor = kContentGrayColor;
    defaultLab.font = FONT_16;
    defaultLab.textAlignment = NSTextAlignmentCenter;
    [needDefaultView addSubview:defaultLab];
    defaultLab.sd_layout.topSpaceToView(defaultIV, UIScaleHeight(24))
    .centerXEqualToView(needDefaultView)
    .widthIs(needDefaultView.width - 2*TXSJShortPadding)
    .autoHeightRatio(0);
    
    defaultLab.text = self.defaultTitle;
    
    BOOL isHaveDefaultBtn = !(!self.defaultBtnTitle || [self.defaultBtnTitle isEmptyString]);
    
    if(isHaveDefaultBtn){
        [needDefaultView addSubview:self.defaultBtn];
        self.defaultBtn.sd_layout.topSpaceToView(defaultLab, UIScale(46))
        .centerXEqualToView(needDefaultView)
        .widthIs(UIScale(167))
        .heightIs(UIScaleHeight(50));
        
        [self.defaultBtn setTitle:self.defaultBtnTitle forState:UIControlStateNormal];
        
        [needDefaultView setupAutoHeightWithBottomView:self.defaultBtn bottomMargin:5];
    }else{
        [needDefaultView setupAutoHeightWithBottomView:defaultLab bottomMargin:5];
    }
    [needDefaultView layoutSubviews];
    
    [parentView addSubview:needDefaultView];
    
    if(parentView == self.view) {
        needDefaultView.centerY = parentView.centerY - 64;
    }else if([parentView isKindOfClass:[UITableView class]]){
        needDefaultView.centerY = parentView.centerY - ((UITableView *)parentView).tableHeaderView.height/2 - 64;
    }else {
        needDefaultView.centerY = parentView.centerY;
    }
    
    return needDefaultView;
}

-(UIButton *)defaultBtn {
    if (!_defaultBtn) {
        _defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _defaultBtn.backgroundColor = kTitleColor;
        _defaultBtn.size = CGSizeMake(UIScale(167), UIScaleHeight(50));
        [_defaultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _defaultBtn.titleLabel.font = FONT_16;
    }
    return _defaultBtn;
}

- (UIButton *)backToTopButton {
    if (!_backToTopButton) {
        _backToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backToTopButton addTarget:self action:@selector(backToTopAction) forControlEvents:UIControlEventTouchUpInside];
        [_backToTopButton setImage:[UIImage imageNamed:@"Details_top"] forState:UIControlStateNormal];

        ///直接添加到self.view上
        [self.view addSubview:_backToTopButton];
        [_backToTopButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(UIScale(50));
            make.right.equalTo(self.view).offset(- TXSJCommonPadding);
            make.bottom.equalTo(self.view).offset(- TXSJCommonPadding - UIScale(55) - iPhoneXBottomDefaultHeight);
        }];
    }

    return _backToTopButton;
}

///返回到顶端，子类重写把想回到顶端的scrollview滑到顶端
- (void)backToTopAction {

}

///如果写在base中耦合度就高了
//- (void)gotoShoppingCartAction:(id)sender {
//    ///去购物车
//    [[TXSJUrlHandle sharedInstance] handelLocalSchemeUrlString:@"shoppingcar"];
//}

///显示分享view（用默认的的分享view，初始化有用的具体分享信息，就不在这里初始化了，以后可以把分享view改掉，分享的传入model,每次view可以单例就好）
- (void)showShareViewAction:(id)sender {

}


- (UIButton *)shoppingCartButton {
    if (!_shoppingCartButton) {
        CGSize defaultSize = CGSizeMake(XGTCBaseImageNavBarWidth, XGTCBaseImageNavBarWidth);
        UIImage *shoppingCartImage = [UIImage imageNamed:@"list_cart_light_20"];
        _shoppingCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shoppingCartButton addTarget:self action:@selector(gotoShoppingCartAction:) forControlEvents:UIControlEventTouchUpInside];
        [_shoppingCartButton setImage:shoppingCartImage forState:UIControlStateNormal];
        _shoppingCartButton.frame = CGRectMake(0, 0, defaultSize.width, defaultSize.height);
    }

    return _shoppingCartButton;
}
- (UILabel *)badgeLable {
    if (!_badgeLable) {
        _badgeLable = [[UILabel alloc]init];
        _badgeLable.layer.cornerRadius = 10;
        _badgeLable.hidden = YES;
        _badgeLable.clipsToBounds = YES;
        _badgeLable.adjustsFontSizeToFitWidth = YES;
        _badgeLable.backgroundColor = [UIColor redColor];
        //10为小红点的高度和宽度
        _badgeLable.frame = CGRectMake(24, 5, 20, 20);
        _badgeLable.font = [UIFont systemFontOfSize:10];
        _badgeLable.textColor = [UIColor whiteColor];
        _badgeLable.textAlignment = NSTextAlignmentCenter;
    }
    return _badgeLable;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        CGSize defaultSize = CGSizeMake(XGTCBaseImageNavBarWidth, XGTCBaseImageNavBarWidth);
        UIImage *shareImage = [UIImage imageNamed:@"Details_share_black"];
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton addTarget:self action:@selector(showShareViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_shareButton setImage:shareImage forState:UIControlStateNormal];
        _shareButton.frame = CGRectMake(0, 0, defaultSize.width, defaultSize.height);
    }

    return _shareButton;
}

//配置tableview cell 的 ViewModel的 执行操作～～  比如我的主页那  订单cell的 取消订单操作 然后主页刷新数据
- (void)configureCell:(UITableView *)tableView viewModelActionAtIndexPath:(NSIndexPath *)indexPath;{};

- (void)setUpSubviews {
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ///设置navBar的显示隐藏
    [self.navigationController setNavigationBarHidden:[self needNavigationBarHidden] animated:YES];

//    ///百度统计页面
//    NSString *className = NSStringFromClass([self class]);
//    [BaiduMobStatTracker pageviewStartWithName:className];
}

-(void)dealloc {
    NSLog(@"###WDF %@ dealloc", [self class]);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.viewModel.willDisappearSignal sendNext:nil];
//    ///百度统计页面
//    NSString *className = NSStringFromClass([self class]);
//    [BaiduMobStatTracker pageviewEndWithName:className];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///是否显示NavBar，默认显示
-  (BOOL)needNavigationBarHidden {
    return NO;
}

///默认所有二级页面都显示，如果有二给页面不显示，那么就重写此方法
- (BOOL)showShoppintCartButton {
    ///所有的二级页面都默认有购物车按钮，分享按钮默认在很多页面都显示
    if (self.navigationController.viewControllers.count > 1) {
        return YES;
    }

    return NO;
}


#pragma --mark statusBar
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
- (void)shakeAnimationImageViewCart {
 
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:TXSJNotificationCartAnimation object:nil] subscribeNext:^(NSNotification * notification) {
        if ([notification.object integerValue] == TXSJCartAnimationTypeRigthCart) {
            //如果正在播放动画则直接返回
            UIImageView * imageView = ((TXSJBaseViewController *)[TXSJCommonUtils getCurrentVC]).shoppingCartButton.imageView;
            if (imageView.isAnimating) {
                return;
            }
            //    //创建可变数组存放序列帧图片
            NSMutableArray *images = [NSMutableArray array];
            for (int i = 1; i < 21; i++) {
                UIImage *img =  [UIImage imageNamed:[NSString stringWithFormat:@"list_cart_light_%d",i]];
                [images addObject:img];
            }
            imageView.animationImages = images;
            imageView.animationRepeatCount = 1;
            imageView.animationDuration = images.count * 0.04;
            [imageView startAnimating];
        }
    }];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
