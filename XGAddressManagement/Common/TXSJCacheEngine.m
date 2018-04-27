////
////  TXSJCacheEngine.m
////  retail
////
////  Created by wangdf on 2017/9/18.
////  Copyright © 2017年 apple. All rights reserved.
////
//
//#import "TXSJCacheEngine.h"
//#import "TXSJUserModel.h"
//#import "TXSJStoresModel.h"
//#import "TXSJAPIGenerate.h"
//#import <JPUSHService.h>
//#import "TXSJStoresModel.h"
//#import <XGTCArchiverUtils.h>
//#import "TXSJLocalPathUtils.h"
//#import "TXSJValueModel.h"
//#import "TXSJShoppCartModel.h"
//#define TXSJCurrentUserModel @"TXSJCurrentUserModel"
//#define TXSJCurrentStroresModel @"TXSJCurrentStroresModel"
//
//NSString * const TXSJCacheDialogId = @"dialogId";
//NSString * const TXSJCacheDialogDate  = @"dialogDate";
//
//@interface TXSJCacheEngine ()
//
//////JPUSH req number
//@property (nonatomic, assign) NSInteger seqNumber;
//
//@end
//
//@implementation TXSJCacheEngine
//
//+ (instancetype)shareInstance {
//    static TXSJCacheEngine *instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[TXSJCacheEngine alloc] init];
//    });
//    return instance;
//}
//
//- (instancetype)init {
//    if (self = [super init]) {
//        _seqNumber = 0;
//        
//        ///加载上次登录的用户信息
//        [self loadLoginPhoneNumber];
//        ///环境变化的时候就要更新cacheManager
//        WEAKSELF(weakSelf);
//        [[RACObserve([TXSJAPIGenerate shareInstance], environmentType) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
//            STRONGSELF(strongSelf);
//            [strongSelf cleanCacheMnager];
//        }];
//    }
//    return self;
//}
//
//
/////环境变化，检查一下缓存manager
//- (void)cleanCacheMnager {
//    _cacheManager = nil;
//}
//
//-(YYCache *)cacheManager {
//    if (!_cacheManager) {
//        NSString *appInfo = [[TXSJAPIGenerate shareInstance] appInfoName];
//        _cacheManager = [[YYCache alloc] initWithName:appInfo];
//    }
//    return _cacheManager;
//}
//
//
//- (NSString *)accountSavePath {
//    return [[TXSJLocalPathUtils shareInstance] getAccountsStoragePath];
//}
//- (NSString *)goodsCartSavePath {
//    return [[TXSJLocalPathUtils shareInstance] getGoodsCartStoragePath];
//}
//- (NSString *)goodsCartNetworks {
//    return [[TXSJLocalPathUtils shareInstance] getGoodsCartNetworksStoragePath];
//}
//- (NSString *)homeIndexListSavePath {
//    return [[TXSJLocalPathUtils shareInstance] getHomeIndexListStoragePath];
//}
//- (NSString *)homeIndexListSavePathV11 {
//    return [[TXSJLocalPathUtils shareInstance] getHomeIndexListStoragePathV11];
//}
//- (NSString *)homeMenuListSavePath {
//    return [[TXSJLocalPathUtils shareInstance] getHomeMenuListStoragePath];
//}
//
//- (NSInteger)loginUserId {
//    if (!self.userModel) {
//        return -1;
//    }
//    return self.userModel.userId;
//}
//
//- (NSString *)loginUserToken {
//    if (!self.userModel || !self.userModel.token) {
//        return nil;
//    }
//    
//    return self.userModel.token;
//}
//
//- (NSString *)userNameToShow {
//    if (!self.userModel || !self.userModel.token) {
//        return @"";
//    }
//    //有昵称就显示昵称
//    if(self.userModel.nickName && ![self.userModel.nickName isEmptyString] ) {
//        return self.userModel.nickName;
//    }
//    if(self.userModel.loginName && ![self.userModel.loginName isEmptyString] ) {
//        return self.userModel.loginName;
//    }
//    if(self.phoneNumber && ![self.phoneNumber isEmptyString] ) {
//        return self.phoneNumber;
//    }
//    
//    return @"";
//}
//
//
////jpush seq number
//- (NSInteger)JPushSeqNumber {
//    @synchronized (self) {
//        ++_seqNumber;
//    }
//    
//    return _seqNumber;
//}
//
////修改头像
//- (void)modifyPicture:(NSString *)avatar {
//    TXSJUserModel *userModel = self.userModel;
//    if (userModel) {
//        userModel.faceLink = avatar;
//    }
//    
//    ///保存用户信息, 就不设置userModel了，不用再上传tags
//    [self saveUserInfo:userModel];
//}
//
////修改个人信息
//- (void)updateUserInfo:(TXSJUserModel *)userModel {
//    ///更新一下登录的手机号
//    self.phoneNumber = userModel.loginName;
//    [self saveUserInfo:userModel];
//}
//
/////保存用户信息,有就保存，没有就当清除操作
//- (void)saveUserInfo:(TXSJUserModel *)userModel {
//    if (userModel) {
//        [self.cacheManager setObject:userModel forKey:TXSJCurrentUserModel];
//    }else {
//        [self.cacheManager removeObjectForKey:TXSJCurrentUserModel];
//    }
//}
//
//- (TXSJUserModel *)userModel {
//    TXSJUserModel *userModel = (TXSJUserModel *)[self.cacheManager objectForKey:TXSJCurrentUserModel];
//    if (userModel) {
//        if (userModel.userId == 0 || userModel.token.length == 0) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.userModel = nil;
//            });
//            return nil;
//        }
//        return userModel;
//    }
//    return nil;
//}
//
//- (TXSJStoresModel *)storesModel {
//    TXSJStoresModel *storesModel = (TXSJStoresModel *)[self.cacheManager objectForKey:TXSJCurrentStroresModel];
//    
//    ////一期的门店是写死一个id的
//    if (!storesModel) {
//        storesModel = [[TXSJStoresModel alloc] init];
//        storesModel.storeId = [[TXSJAPIGenerate shareInstance] defaultStoresId];
//        ///存下缓存,也要设置tags，好有JPush
//        [self setStoresModel:storesModel];
//        //        [self.cacheManager setObject:storesModel forKey:TXSJCurrentStroresModel];
//    }
//    
//    if (storesModel) {
//        if (storesModel.storeId == 0) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.storesModel = nil;
//            });
//            return nil;
//        }
//        
//        return storesModel;
//    }
//    
//    return nil;
//}
/////用户信息更改时,同时设置JPush
//- (void)setUserModel:(TXSJUserModel *)userModel {
//    //    ///获取一下registerId
//    //    NSString *registerId = [JPUSHService registrationID];
//    //    NSLog(@"####WDF JPush registerId = %@", registerId);
//    
//    if (userModel) {
//        ///保存最后登录的手机号
//        self.phoneNumber = userModel.loginName;
//        
//        ///设置门店id、城市、登录状态
//        NSMutableSet *set = [NSMutableSet set];
//        if (self.storesModel) {
//            [set addObject:[NSString stringWithFormat:@"stores_%zd", self.storesModel.storeId]];
//        }
//        [set addObject:@"login"];
//        WEAKSELF(weakSelf);
//        dispatch_async_main_safe(^{
//            STRONGSELF(strongSelf);
//            [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                DDLogDebug(@"setTags: rescode: %ld, \ntags: %@, \nseq: %ld\n", (long)iResCode, iTags , (long)seq);
//                NSLog(@"%s iTags = %@", __FUNCTION__, iTags);
//            } seq:[strongSelf seqNumber]];
//            [JPUSHService setAlias:userModel.loginName completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//                DDLogDebug(@"setAlias: rescode: %ld, \nalias: %@, \nseq: %ld\n", (long)iResCode, iAlias , (long)seq);
//                NSLog(@"%s iAlias = %@", __FUNCTION__, iAlias);
//            } seq:[strongSelf seqNumber]];
//        });
//        
//        ///保存到缓存里
//        [self saveUserInfo:userModel];
//    }else {
//        NSMutableSet *set = [NSMutableSet set];
//        if (self.storesModel) {
//            [set addObject:[NSString stringWithFormat:@"stores_%zd", self.storesModel.storeId]];
//        }
//        [set addObject:@"logout"];
//        WEAKSELF(weakSelf);
//        dispatch_async_main_safe(^{
//            STRONGSELF(strongSelf);
//            [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                DDLogDebug(@"setTags: rescode: %ld, \ntags: %@, \nseq: %ld\n", (long)iResCode, iTags , (long)seq);
//                NSLog(@"%s iTags = %@", __FUNCTION__, iTags);
//            } seq:[strongSelf seqNumber]];
//            
//            ///删除标签
//            [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//                DDLogDebug(@"deleteAlias: rescode: %ld, \nalias: %@, \nseq: %ld\n", (long)iResCode, iAlias , (long)seq);
//            } seq:[strongSelf seqNumber]];
//            //        [JPUSHService setAlias:@"" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//            //            DDLogDebug(@"rescode: %ld, \nalias: %@, \nseq: %ld\n", (long)iResCode, iAlias , (long)seq);
//            //        } seq:[strongSelf seqNumber]];
//        });
//        ///从缓存移除
//        [self saveUserInfo:nil];
//    }
//}
//
/////门店更改时
//- (void)setStoresModel:(TXSJStoresModel *)storesModel {
//    //    ///获取一下registerId
//    //    NSString *registerId = [JPUSHService registrationID];
//    //    NSLog(@"####WDF JPush registerId = %@", registerId);
//    
//    if (storesModel) {
//        ///设置门店id、城市、登录状态
//        NSMutableSet *set = [NSMutableSet set];
//        [set addObject:[NSString stringWithFormat:@"stores_%ld", (long)storesModel.storeId]];
//        
//        ///是否是登录状态
//        if (self.userModel) {
//            [set addObject:@"login"];
//        }else {
//            [set addObject:@"logout"];
//        }
//        
//        WEAKSELF(weakSelf);
//        dispatch_async_main_safe(^{
//            STRONGSELF(strongSelf);
//            [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                DDLogDebug(@"rescode: %ld, \ntags: %@, \nseq: %ld\n", (long)iResCode, iTags , (long)seq);
//            } seq:[strongSelf seqNumber]];
//        });
//        
//        ///保存到缓存里
//        [self.cacheManager setObject:storesModel forKey:TXSJCurrentStroresModel];
//    }else {
//        NSMutableSet *set = [NSMutableSet set];
//        ///是否是登录状态
//        if (self.userModel) {
//            [set addObject:@"login"];
//        }else {
//            [set addObject:@"logout"];
//        }
//        
//        WEAKSELF(weakSelf);
//        dispatch_async_main_safe(^{
//            STRONGSELF(strongSelf);
//            [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//                DDLogDebug(@"rescode: %ld, \ntags: %@, \nseq: %ld\n", (long)iResCode, iTags , (long)seq);
//            } seq:[strongSelf seqNumber]];
//        });
//        
//        ///从缓存移除
//        [self.cacheManager removeObjectForKey:TXSJCurrentStroresModel];
//    }
//}
//
//-(void)setPhoneNumber:(NSString *)phoneNumber {
//    _phoneNumber = phoneNumber;
//    [self saveLoginPhoneNumber];
//}
//
/////加载上次登录手机号（不分环境，不用缓存存，用文件存）
//- (void)loadLoginPhoneNumber {
//    NSDictionary *accountDic = [XGTCArchiverUtils loadUnArchiverObject:[self accountSavePath]];
//    if (!accountDic || 0 == accountDic.allKeys.count) {
//        return;
//    }
//    
//    ///上次登录的手机号
//    _phoneNumber = [accountDic stringObjectForKey:@"phoneNumber"];
//}
//
/////添加本地商品
//- (void)addCartModel:(TXSJValueModel *)cartModel {
//    NSMutableArray *array = [[NSMutableArray alloc]init];
//    NSMutableArray *arr = [XGTCArchiverUtils loadUnArchiverObject:[self goodsCartSavePath]];
//    if (arr) {
//        TXSJValueModel *model = cartModel;
//        for (int i = 0; i < arr.count; i ++) {
//            TXSJValueModel *saveModel = arr[i];
//            if (saveModel.productId == cartModel.productId && saveModel.goodsId == cartModel.goodsId) {
//                saveModel.count = cartModel.count + saveModel.count;
//                if (saveModel.count >= 99) {
//                    saveModel.count = 99;
//                }
//                model = saveModel;
//                [arr removeObjectAtIndex:i];
//                break;
//            }
//        }
//        [arr addObject:model];
//    }else {
//        arr = array;
//        [arr addObject:cartModel];
//    }
//    [XGTCArchiverUtils saveArchiverObject:arr savePath:[self goodsCartSavePath]];
////    [(TXSJBaseViewController *)[TXSJCommonUtils getCurrentVC] toastMessageTitle:@"加入购物车成功" toastImageStr:@"Details_success"];
//}
//
/////批量加入
//- (void)addCartArray:(NSArray *)cartArray {
//    if (!cartArray.count) {
//        return;
//    }
//
//    NSMutableArray *array = [[NSMutableArray alloc]init];
//    for (id cart in cartArray) {
//        @autoreleasepool{
//            if ([cart isMemberOfClass:[TXSJValueModel class]]) {
//                [array addObject:cart];
//            }else {
//                TXSJValueModel *model = [TXSJValueModel modelWithJSON:cart];
//                if (model) {
//                    [array addObject:model];
//                }
//            }
//        }
//    }
//
//
//    NSMutableArray *arr = [XGTCArchiverUtils loadUnArchiverObject:[self goodsCartSavePath]];
//    if (arr) {
//        [arr addObjectsFromArray:array];
//    }else {
//        arr = array;
//    }
//    [XGTCArchiverUtils saveArchiverObject:arr savePath:[self goodsCartSavePath]];
//    ///有动画应该都不提示了
////    [(TXSJBaseViewController *)[TXSJCommonUtils getCurrentVC] toastMessageTitle:@"加入购物车成功" toastImageStr:@"Details_success"];
//}
//
/////更新本地所有的商品列表
//- (void)updateLocalCartListArr:(NSMutableArray *)cartListArr {
//    //    NSMutableArray *array = [[NSMutableArray alloc]init];
//    //    NSMutableArray *arr = [XGTCArchiverUtils loadUnArchiverObject:[self goodsCartSavePath]];
//    //    if (arr) {
//    //        arr = cartListArr;
//    //    }else {
//    //        arr = array;
//    //        arr = cartListArr;
//    //    }
//    [XGTCArchiverUtils saveArchiverObject:cartListArr savePath:[self goodsCartSavePath]];
//}
//
////获取购物车列表数据
//- (NSMutableArray *)getCartListData {
//    NSMutableArray *arr = [XGTCArchiverUtils loadUnArchiverObject:[self goodsCartSavePath]];
//    return arr;
//}
//
////删除更新数据
//- (void)removeDataIndex:(TXSJValueModel *)itemModel {
//    NSMutableArray *arrSave = [self getCartListData];
//    for (int i = 0; i < arrSave.count; i ++) {
//        TXSJValueModel *saveModel = arrSave[i];
//        if (saveModel.productId == itemModel.productId && saveModel.goodsId == itemModel.goodsId) {
//            if (itemModel.isDelete == 1) {
//                //删除
//                [arrSave removeObjectAtIndex:i];
//                [self updateLocalCartListArr:arrSave];
//            }else {
//                //更新
//                [arrSave replaceObjectAtIndex:i withObject:itemModel];
//                [self updateLocalCartListArr:arrSave];
//            }
//        }
//    }
//}
////购物车缓存网络数据
//- (void)addShoppCartModel:(TXSJShoppCartModel *)model {
//    [XGTCArchiverUtils saveArchiverObject:model savePath:[self goodsCartNetworks]];
//}
////获取购物车缓存网络数据
//- (TXSJShoppCartModel *)getShoppCartModel {
//    TXSJShoppCartModel *modelCart = [XGTCArchiverUtils loadUnArchiverObject:[self goodsCartNetworks]];//[[TXSJShoppCartModel alloc] init];
//    return modelCart;
//}
////首页各屏数据
//- (void)setHomeIndexListArr:(NSMutableArray *)homeIndexListArr {
//    [XGTCArchiverUtils saveArchiverObject:homeIndexListArr savePath:[self homeIndexListSavePath]];
//}
//
////首页各屏数据V1.1版本
//-(void)setHomeIndexListArrForV11:(NSMutableArray *)homeIndexListArrForV11{
//    [XGTCArchiverUtils saveArchiverObject:homeIndexListArrForV11 savePath:[self homeIndexListSavePathV11]];
//}
//
////获取首页各屏数据
//- (NSMutableArray *)getHomeIndexListArrData {
//    NSMutableArray *arr = [XGTCArchiverUtils loadUnArchiverObject:[self homeIndexListSavePath]];
//    if(!arr){
//        arr = [NSMutableArray array];
//    }
//    return arr;
//}
//
////获取首页各屏数据 V1.1版本
//- (NSMutableArray *)getHomeIndexListArrDataForV11 {
//    NSMutableArray *arr = [XGTCArchiverUtils loadUnArchiverObject:[self homeIndexListSavePathV11]];
//    if(!arr){
//        arr = [NSMutableArray array];
//    }
//    return arr;
//}
//
/////弹框key，没登录时默认用同一个key
//- (NSString *)cacheDialogKey {
//    if (self.loginUserId <= 0) {
//        return [NSString stringWithFormat:@"TXSJDialogCacheKey_%d", 0];
//    }
//    return [NSString stringWithFormat:@"TXSJDialogCacheKey_%ld", (long)self.loginUserId];
//}
//
/////已经弹框的ids
//- (NSArray *)cachedDialogIds {
//    ///这个弹框还要跟用户相关,如果没有登录，那就不缓存，一直弹
//    NSString *cacheKey = [self cacheDialogKey];
//    if (cacheKey.length > 0) {
//        NSArray *dialogIds = (NSArray *)[self.cacheManager objectForKey:cacheKey];
//
//        ///以下代码迭代几个版本后删除，至少5个版本
//        ///1.1数据类弄更改了，第一次缓存的时候要把老模型便利一下
//        NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:dialogIds.count];
//        for (id cache in dialogIds) {
//            @autoreleasepool{
//                if (![cache isKindOfClass:[NSDictionary class]]) {
//                    [newArray addObject:@{TXSJCacheDialogId:cache}];
//                }else {
//                    [newArray addObject:cache];
//                }
//            }
//        }
//
//        return newArray;
//    }
//
//    return nil;
//}
//
/////保存已经弹框的id
//- (void)saveDialogId:(NSInteger)dialogId cacheDate:(NSString *)dateString {
//    ///只有登录用户才去缓存
//    NSString *cacheKey = [self cacheDialogKey];
//    if (cacheKey.length > 0) {
//        @synchronized(self.cacheManager) {
//            NSMutableArray *dialogIds = [NSMutableArray arrayWithArray:(NSArray *)[self.cacheManager objectForKey:cacheKey]];
//            ///添加缓存时间字段
//            NSMutableDictionary *cacheDic = [NSMutableDictionary dictionary];
//            [cacheDic setObject:@(dialogId) forKey:TXSJCacheDialogId];
//            if (dateString) {
//                [cacheDic setObject:dateString forKey:TXSJCacheDialogDate];
//            }
//            [dialogIds addObject:cacheDic];
//            [self.cacheManager setObject:dialogIds forKey:cacheKey];
//        }
//    }
//}
//
//
////首页栏目数据
//- (void)setHomeMenuListArr:(NSMutableArray *)homeMenuListArr{
//    [XGTCArchiverUtils saveArchiverObject:homeMenuListArr savePath:[self homeMenuListSavePath]];
//}
////获取首页栏目数据
//- (NSMutableArray *)getHomeMenuListArrData {
//    NSMutableArray *arr = [XGTCArchiverUtils loadUnArchiverObject:[self homeMenuListSavePath]];
//    if(!arr){
//        arr = [NSMutableArray array];
//    }
//    return arr;
//}
//
/////保存用户信息
//- (void)saveLoginPhoneNumber {
//    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
//    
//    ///登录用记手机
//    if (_phoneNumber) {
//        [userDic setValue:_phoneNumber forKey:@"phoneNumber"];
//    }
//    
//    ///不存keychain了,帐号只有手机号，每次都验证码登录，存keychain其实没多大必要
//    [XGTCArchiverUtils saveArchiverObject:userDic savePath:[self accountSavePath]];
//}
// 
//
//@end

