//
//  TXSJRefreshGifHeader.m
//  tuchao
//
//  Created by xiaohui on 2017/5/22.
//  Copyright © 2017年 TuChao. All rights reserved.
//

#import "TXSJRefreshGifHeader.h"

@interface TXSJRefreshGifHeader ()

///默认的一张图片
@property (nonatomic, strong) UIImageView *defaultImageView;

///rockImageView
@property (nonatomic, strong) UIImageView *rockImageView;

///endImageView
@property (nonatomic, strong) UIImageView *endImageView;

///下拉释放时的动画图片
@property (nonatomic, strong) NSMutableArray *preLoadingArray;
///正常加载中的动画图片
@property (nonatomic, strong) NSMutableArray *loadingArray;
///最后一次动画图片
@property (nonatomic, strong) NSMutableArray *stopArray;

///是否进入停止状态
@property (nonatomic, assign) BOOL prepareStop;

///顶部偏移（iphonex上有便宜）
@property (nonatomic, assign) CGFloat topMargin;
@end

@implementation TXSJRefreshGifHeader

- (instancetype)init {
    self = [super init];
    if (self) {
        self.needOffsetWithIPhoneX = NO;
    }
    return self;
}

- (void)prepare {
    [super prepare];
    self.clipsToBounds = YES;
//    self.mj_h = [self loadingImageHeight];
    self.mj_h = [self pullingAnimateHeight];

    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;

    ///加载前
    _preLoadingArray = [NSMutableArray array];
    for (NSInteger i = 36; i < 62; i++) {
        NSString *imageName = [NSString stringWithFormat:@"pulling_%ld", (long)i];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            [_preLoadingArray addObject:image];
        }
    }

    ///加载中
    _loadingArray = [NSMutableArray array];
    for (NSInteger i = 62; i < 84; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_%ld", (long)i];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            [_loadingArray addObject:image];
        }
    }

    ///结束
    _stopArray = [NSMutableArray array];
    for (NSInteger i = 84; i < 119; i++) {
        NSString *imageName = [NSString stringWithFormat:@"disappear_%ld", (long)i];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            [_stopArray addObject:image];
        }
    }


    ///加载时间
    CGFloat loadingTime = self.preLoadingArray.count / 24.0f;
    self.rockImageView.hidden = YES;
    self.rockImageView.animationImages = self.preLoadingArray;
    self.rockImageView.animationDuration = loadingTime;
    ///只动画一次
    self.rockImageView.animationRepeatCount = 1;


    ///结束时间
    CGFloat stopTime = self.stopArray.count / 24.0f;
    self.endImageView.hidden = YES;
    self.endImageView.animationImages = self.stopArray;
    self.endImageView.animationDuration = stopTime;
    ///只动画一次
    self.endImageView.animationRepeatCount = 1;

    ///添加defauleImageView
    [self addSubview:self.defaultImageView];

    ///添加rock imageView
    [self addSubview:self.rockImageView];

    ///添加end imageView
    [self addSubview:self.endImageView];

    ///加载中的的动画
    [self setImages:self.loadingArray duration:self.loadingArray.count / 24.0 forState:MJRefreshStateRefreshing];
}

- (void)placeSubviews {
    ///只改center_X
    self.defaultImageView.centerX = self.centerX;
    self.rockImageView.centerX = self.centerX;
    [super placeSubviews];

    ///重设一下frame
    CGRect frame = self.bounds;
    frame.origin.y = self.topMargin;
    frame.size.height -= self.topMargin;
    self.gifView.frame = frame;
    self.endImageView.frame = frame;

    [self bringSubviewToFront:self.rockImageView];
    [self bringSubviewToFront:self.defaultImageView];
    [self bringSubviewToFront:self.endImageView];
}

///随着下拉的距离增加小熊冒出来的头越来越大
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    ///把小熊慢慢的移下来，小熊最多探出半个头来，整个拉拽过程中
    CGFloat yPos = self.scrollView.contentOffset.y;
    if (self.scrollView.isDragging && yPos <= -self.scrollView.mj_insetT && (self.state != MJRefreshStateRefreshing || self.state != MJRefreshStateWillRefresh)) {
        ///如果是在拉的过程中,改变高度会引起一些问题，请注意
//        if (self.state == MJRefreshStatePulling) {
//            CGFloat maxMJHeight = [self pullingAnimateHeight];
//            //动态改变frame,为了释放时的那个飞走动画
//            CGFloat height = MIN(maxMJHeight, ABS(yPos));
//            self.mj_h = height;
//        }

        CGFloat maxHeight = self.mj_h;
        CGFloat imageMaxShowHeight = [self imageShowHeight];
        if (yPos < 0 && maxHeight > 0) {
            ///固定小熊的位置
            CGFloat rYPos = MIN(ABS(yPos), maxHeight);
            CGFloat delYPos = rYPos * imageMaxShowHeight / maxHeight;
            CGRect frame = self.defaultImageView.frame;
            frame.origin.y = maxHeight - delYPos;
            self.defaultImageView.frame = frame;
        }

        ///MJRefrehHerader中每次都判断的mj_h,然而我们需求这个是变的，导致状态一直在1、2间变，假如超过了原始的加载高度时，这时候刚好因mj_h变化导致状态变成1，释放时是不会加载的，所以这里加串逻辑，只要是偏移超过了就把状态设置成2
//        if (yPos < - ([self loadingImageHeight] + self.scrollView.mj_insetT) && self.state == MJRefreshStateIdle) {
//            self.state = MJRefreshStatePulling;
//        }
    }

    ///这个小图片只有往下dragging的时候显示
    self.defaultImageView.hidden = !(self.scrollView.isDragging && self.state != MJRefreshStateRefreshing) || yPos > -self.scrollView.mj_insetT;
}

///弹起图片的高度
- (CGFloat)pullingAnimateHeight {
    CGFloat pullingImageHeight = 0;
    if (_preLoadingArray.count > 0) {
        UIImage *image = [_preLoadingArray objectAtIndex:0];
        pullingImageHeight = image.size.height;
    }

    return pullingImageHeight + self.topMargin;// + [self imageShowHeight];
}

///如果是iphoneX要加多30，要不然就断头了
- (CGFloat)loadingImageHeight {
    CGFloat loadingHeight = 0;
    if (self.loadingArray.count > 0) {
        UIImage *image = [self.loadingArray objectAtIndex:0];
        loadingHeight = image.size.height;
    }

    if (_needOffsetWithIPhoneX) {
        if (@available(iOS 11.0, *)) {
            _topMargin = kKeyWindow.safeAreaInsets.top;
        }
    }

    loadingHeight += _topMargin;

    return loadingHeight;
}

- (CGFloat)imageShowHeight {
    return self.defaultImageView.bounds.size.height * 2.0 / 3.0;
}

- (void)setState:(MJRefreshState)state {
    [super setState:state];
    switch (state) {
        case MJRefreshStateRefreshing: {
            self.rockImageView.hidden = YES;
            self.defaultImageView.hidden = YES;
            self.endImageView.hidden = YES;
        }
            break;
        case MJRefreshStatePulling: {
            [self.gifView stopAnimating];
            self.rockImageView.hidden = YES;
            self.endImageView.hidden = YES;
        }
            break;
        case MJRefreshStateIdle: {
            ///还原大小
            if (!self.scrollView.isDragging) {
//                self.mj_h = [self loadingImageHeight];
                self.mj_h = [self pullingAnimateHeight];
            }
        }
            break;
        default:
            break;
    }
}

- (void)beginRefreshing {
    ///如果rock已经加载就做动画，如果没有加载就直接调super的
    ///如果是初始化时直接调的beginRefreshing的话就直接走super,免得容器有透明的insetTop的时候rock动画显得突兀
    if (!_rockImageView || self.scrollView.mj_offsetY > -self.mj_h) {
        self.mj_h = [self loadingImageHeight];
        [super beginRefreshing];
        return;
    }

    self.rockImageView.hidden = NO;
    [self.rockImageView startAnimating];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self performSelector:@selector(removeObservers) withObject:nil];
    [self.scrollView setContentOffset:CGPointMake(0, -(self.mj_h + self.scrollView.mj_insetT)) animated:NO];

    CGFloat loadingImageHeight = [self loadingImageHeight];
    CGRect frame = self.rockImageView.frame;
    frame.origin.y = self.topMargin + [self pullingAnimateHeight] -  loadingImageHeight;
    [UIView animateWithDuration:self.rockImageView.animationDuration animations:^{
        self.rockImageView.frame = frame;
        [self.scrollView setContentOffset:CGPointMake(0, -(loadingImageHeight + self.scrollView.mj_insetT)) animated:NO];
    } completion:^(BOOL finished) {
        self.mj_h = loadingImageHeight;
        self.rockImageView.hidden = YES;
        CGRect oriFrame = frame;
        oriFrame.origin.y = self.topMargin;
        self.rockImageView.frame = oriFrame;
         [super beginRefreshing];
        [self performSelector:@selector(addObservers) withObject:nil];
    }];
    #pragma clang diagnostic pop
}

- (void)endRefreshing {
    if (self.state != MJRefreshStateRefreshing || self.prepareStop) {
        return;
    }

    ///11.2前直接用gifView就好了，没有问题，但11.2系统是切换images的时候如果毅面没有设置repeatCount的话那就不显示新更换的images,如果设置了的话中间有个闪的过程，如果前面的下面都不设置repeatCount的话，能直接播放，但是在这规定时间就会多播放一点！！！！所以直接再弄个新的imgaeView去完成
    self.prepareStop = YES;
    ///24张图动画时间1s,
//    CGFloat stopTime = self.stopArray.count / 24.0f;
//    ///播放一次停止动画
//    [self.gifView stopAnimating];
//    self.gifView.animationImages = nil;
//    self.gifView.animationImages = self.stopArray;
//    self.gifView.animationDuration = stopTime;
//    ///心累 iOS 11.2 前面没有设置过animationRepeatCount 下面新设置上设置这个就不显示动画了，或者会闪一下
//    self.gifView.animationRepeatCount = 1;
//    [self.gifView startAnimating];
    [self.gifView stopAnimating];
    self.endImageView.hidden = NO;
    [self.endImageView startAnimating];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.endImageView.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.prepareStop = NO;
//        [self.gifView stopAnimating];
//        self.gifView.image = nil;
//        self.gifView.animationImages = nil;
//        self.gifView.animationDuration = 0;
//        self.gifView.animationRepeatCount = 0;
        self.endImageView.hidden = YES;
        [super endRefreshing];
    });
}

#pragma --mark SubViews
- (UIImageView *)defaultImageView {
    if (!_defaultImageView) {
        UIImage *image = [UIImage imageNamed:@"bozi_static"];
        _defaultImageView = [[UIImageView alloc] initWithImage:image];
        CGRect frame = CGRectMake((self.mj_w - image.size.width) / 2.0, self.mj_h + self.scrollView.mj_insetT, image.size.width, image.size.height);
        _defaultImageView.frame = frame;
    }

    return _defaultImageView;
}


- (UIImageView *)rockImageView {
    if (!_rockImageView) {
        _rockImageView = [[UIImageView alloc] init];
        _rockImageView.hidden = YES;
        UIImage *image = [_preLoadingArray objectAtIndex:0];
        _rockImageView.frame = CGRectMake((self.mj_w - image.size.width) / 2.0, self.topMargin, image.size.width, image.size.height);
    }

    return _rockImageView;
}

- (UIImageView *)endImageView {
    if (!_endImageView) {
        _endImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _endImageView.hidden = YES;
        _endImageView.contentMode = UIViewContentModeCenter;
    }

    return _endImageView;
}

@end
