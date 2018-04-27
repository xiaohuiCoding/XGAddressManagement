//
//  TXSJRefreshGifHeader.h
//  tuchao
//
//  Created by xiaohui on 2017/5/22.
//  Copyright © 2017年 TuChao. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface TXSJRefreshGifHeader : MJRefreshGifHeader

///是否要对iphoneX的进行偏移，主要是如果navBar隐藏了的话，有齐刘海的问题，就要多偏移，如果navbar显示着就不能要有偏移
@property (nonatomic, assign) BOOL needOffsetWithIPhoneX;

@end
