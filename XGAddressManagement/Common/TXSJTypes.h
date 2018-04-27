//
//  XGOATypes.h
//  XGOA
//  所有公用枚举都存放在TXSJTypes_h中
//  Created by wangdf on 2017/4/7.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#ifndef TXSJTypes_h
#define TXSJTypes_h

#import <UIKit/UIKit.h>


#pragma mark --  ENUM
///版本更新类型
typedef NS_ENUM(NSInteger, TXSJVersionUpdateType) {
    TXSJVersionUpdateTypeNormal = 0,            //普通更新模式
    TXSJVersionUpdateTypeForced       ,            //强制更新
};

//第三方授权登录类型
typedef NS_ENUM(NSInteger, TXSJThirdAuthType) {
    TXSJThirdAuthTypeQQ     = 1 ,            //QQ
    TXSJThirdAuthTypeWeiXin     ,            //weixin
    TXSJThirdAuthTypeWeiBo      ,           //微博
};


///普通通用cell类型   TXSJCommonCell使用
typedef NS_ENUM(NSInteger, TXSJCommonCellType) {
    TXSJCommonCellTypeDefault = 0,  //标题 加 副标题
    TXSJCommonCellTypeUserLocation,  //标题 加 副标题  加 icon 以及 右边按钮～～～  特殊的  自己位置定位显示的特殊type
    TXSJCommonCellTypeGoLogin,  //标题 加 右边按钮～ 登录按钮  
    TXSJCommonCellTypeValue1, //icon 标题  右边子内容  加 一个右箭头
    TXSJCommonCellTypeValue2, //  标题  右边子内容  加 一个右箭头
    TXSJCommonCellTypeContentNoArrow, //  标题  右边子内容  以及无右箭头
    TXSJCommonCellTypeLineSeprator //分割线
};

///普通通用cell类型   TXSJShoppCartCell使用
typedef NS_ENUM(NSInteger, TXSJShoppCartType) {
    TXSJShoppCartTypeTogether = 0,  //凑单 样式
    TXSJShoppCartTypeReduced,   //已经减少价格的样式
    TXSJShoppCartTypeLapse, //已经失效或者超出范围商品
    TXSJShoppCartTypeOrdinary //普通商品
};

///登陆输入框格式
typedef NS_ENUM(NSInteger, TXSJInputFrameType) {
    TXSJInputFrameTypeTextFiledAndBut = 0,  //有按钮验证码的
    TXSJInputFrameTypeTextFiled,   //没有按钮验证码的
};
///修改手机号码
typedef NS_ENUM(NSInteger, TXSJPhoneViewType) {
    TXSJPhoneViewTypePhone = 0,//手机号码页面
    TXSJPhoneViewTypeModifyPhone,  //修改手机号码页面
    TXSJPhoneViewTypeBindingPhone,   //绑定手机号码页面
};

///发送验证类型
typedef NS_ENUM(NSInteger, TXSJVerifyCodeType) {
    TXSJVerifyCodeTypeLogin = 1,        //登录
    TXSJVerifyCodeTypeBindPhone,    //绑定手机
    TXSJVerifyCodeTypeModifyPhone, //更新手机
};

///轮播图类型   TXSjCycleScrollView使用
typedef NS_ENUM(NSInteger, TXSJCycleScrollViewCellType) {
    TXSJCycleScrollViewCellTypeRecommand,  //首页 推荐 今日推荐 轮播图样式
    TXSJCycleScrollViewCellTypeImg,   //就是一张大背景图片
};

///简单的 商品展示 collectionViewCell的 类型  TXSJSimpleGoodICollectCell使用
typedef NS_ENUM(NSInteger, TXSJSimpleGoodICollectCellType) {
    TXSJSimpleGoodICollectCellDefault = 0,  //默认样式  指首页预售那屏的样式 
    TXSJSimpleGoodICollectCellSpecialTopic,  //首页 专题那屏 使用的 样式
    TXSJSimpleGoodICollectCellBuyerRecommend, //达人食荐 首页 最后一屏  使用的 样式
    TXSJSimpleGoodICollectCellThirdClassify,  //分类三级分类里的 样式
    TXSJSimpleGoodICollectCellActivityShow   //活动页 商品展示样式  积分 + 兑换按钮
};

///商品展示 TXSJGoodShowTypeView的 类型
typedef NS_ENUM(NSInteger, TXSJGoodShowTypeViewType) {
    TXSJGoodShowTypeViewTypeDefault = 0,  //默认样式 特价促销屏有使用
    TXSJGoodShowTypeViewTypeSpecialTopic,  //首页 专题那屏 使用的 样式
};
///专题屏 商品展示 TXSJspeicalTopicGoodView的 类型  TXSJspeicalTopicGoodView使用
typedef NS_ENUM(NSInteger, TXSJSpeicalTopicGoodViewType) {
    TXSJSpeicalTopicGoodViewTypeDefault = 0,  //图文
    TXSJSpeicalTopicGoodViewTypeVideo //视频样式
};

///凑单类型
typedef NS_ENUM(NSInteger, TXSJKnockTogatherType) {
    TXSJKnockTogatherTypeActivity  = 1,            //活动凑单
    TXSJKnockTogatherTypeExpressPost = 2,            //免邮凑单
};

///请求类型
typedef NS_ENUM(NSInteger, XGOAShortRequestType) {
    XGOAShortRequestTypeGet = 0,
    XGOAShortRequestTypePost,
    XGOAShortRequestTypeDelete,
};

//评价内容布局类型
typedef NS_ENUM(NSInteger, EvaluationServiceContentType) {
    EvaluationServiceContentTypeDefault,   //普通  图片  加 正常星级
    EvaluationServiceContentTypeNoPicWithCenterTitle,  //没图片   星级标题在下面居中显示
};

///首页栏目  各屏类型  1=首页，3=今日特价，4=初见尝鲜，5=预售商品，6=节气餐桌，7=视觉盛宴，8=达人食荐
typedef NS_ENUM(NSInteger, TXSJHomeShowType) {
    TXSJHomeShowTypeFirstHome = 1,
    TXSJHomeShowTypePromoteSales = 3,
    TXSJHomeShowTypeNewGoodTry,
    TXSJHomeShowTypePreSellGood,
    TXSJHomeShowTypeSpecialTopic, //节气餐桌
    TXSJHomeShowTypeVideo, // 视觉盛宴
    TXSJHomeShowTypeBuyerRecommend
};

///V1.1版本 首页
typedef NS_ENUM(NSInteger, TXSJHomeMainShowTypeV11) {
    TXSJHomeMainShowTypeFirstHomeV11 = 1,//banner轮播
    TXSJHomeMainShowTypeTenIconV11 = 2,//十大icon
    TXSJHomeMainShowTypeNewerGiftV11,//新人专区
    TXSJHomeMainShowTypeOneAndTwoPicV11,//图片一排三
    TXSJHomeMainShowTypeSepicalActivityV11, //精选专题
    TXSJHomeMainShowTypeSepicalTopicV11, // 精选话题
    TXSJHomeMainShowTypeMoreGoodV11,// 更多好货
    TXSJHomeMainShowTypeEveryDayHotSell,//每日热销
};



///文件类型
typedef NS_ENUM(NSInteger, XGOAUploadFileType) {
    XGOAUploadFileTypeUnknown = 0, ///未知，或者非文件时
    XGOAUploadFileTypeImage,            //图片
    XGOAUploadFileTypeVideo,            //视频
};

///帖子列表展示类型
typedef NS_ENUM(NSInteger, XGOAListDisplayType) {
    XGOAListDisplayTypeHome = 0, ///主页列表展示
    XGOAListDisplayTypeCollection,            //收藏列表
};


///个人信息修改类型（头像另外的，所以不在类型里）
typedef NS_ENUM(NSInteger, TXSJUserItemType) {
    TXSJUserItemTypeNickName = 1, ///昵称
    TXSJUserItemTypeGeder ,              //性别
    TXSJUserItemTypeBirthday,           ///生日
    TXSJUserItemTypePhoneNumber, ///手机号
};
//个人中心-获取我的优惠券列表类型
typedef NS_ENUM(NSInteger, TXSJUserCouponListType) {
    TXSJUserCouponListTypeNOUse = 1, ///未使用
    TXSJUserCouponListTypeBeen ,              //已使用
    TXSJUserCouponListTypeExpired,           ///已过期
};
///two label type
typedef NS_ENUM(NSUInteger, TXSJUserCellType) {
    TXSJUserCellTypeNormal  = 1, ///有accesView
    TXSJUserCellTypeNoneAccessView , //左label,右image，没有accessView
};

///积分类型
typedef NS_ENUM(NSUInteger, TXSJIntegralViewType) {
    TXSJIntegralViewTypeAll  = 0, ///所有积分变动条目
    TXSJIntegralViewTypeIncome , //收入
    TXSJIntegralViewTypeCost , //支出
    TXSJIntegralViewTypeLock , //冻结
};

///积分类型
typedef NS_ENUM(NSUInteger, TXSJIntegralType) {
    TXSJIntegralTypeCost  = 0, //支出
    TXSJIntegralTypeIncome , //收入
};

///订单列表类型
typedef NS_ENUM(NSUInteger, TXSJOrderListType) {
    TXSJOrderListTypeAll  = 0, //全部
    TXSJOrderListTypeAfterServiceOrBack //退款或者售后
};

///分类类型  0 分类 1虚拟分类
typedef NS_ENUM(NSUInteger, TXSJHomeCategoryType) {
    TXSJHomeCategoryTypeDefault  = 0, //分类
    TXSJHomeCategoryTypeXuNi //1虚拟分类
};

///商品列表类型  0 分类
typedef NS_ENUM(NSUInteger, TXSJGoodsListType) {
    TXSJGoodsListTypeSubCategory  = 0, //子分类商品列表
    TXSJGoodsListTypeActivityAll, //1活动商品列表全部
    TXSJGoodsListTypeActivityTop, //活动商品列表全部
    TXSJGoodsListTypeKnockTogetherExpressPost, // 免邮凑单类型
    TXSJGoodsListTypeKnockTogetherExpressActivity, // 活动凑单类型
};

///地址管理 类型  0 默认 只显示 1 选择地址
typedef NS_ENUM(NSUInteger, TXSJAddressManagerType) {
    TXSJAddressManagerTypeDefault  = 0, // 默认
    TXSJAddressManagerTypeSelectForBuyerCar //1 购物车选择地址使用
};

//售后类型  0 仅换货 1退货退款 4仅退款
typedef NS_ENUM(NSUInteger, TXSJApplyAfterSalesServiceType) {
    TXSJApplyAfterSalesServiceTypeChangeGood  = 0, // 默认
    TXSJApplyAfterSalesServiceTypeOnlyMoney = 4,
    TXSJApplyAfterSalesServiceTypeALL = 1 // 退款
};

//支付状态 0 失败 1成功
typedef NS_ENUM(NSUInteger, TXSJOrderPayStateType) {
    TXSJOrderPayStateTypeFail  = 0,
    TXSJOrderPayStateTypeSucceed
};
//订单状态
typedef NS_ENUM(NSUInteger, TXSJOrderDetailStatusType) {
    TXSJOrderDetailStatusTypeToBePaid  = 0, //待支付
    TXSJOrderDetailStatusTypeDistribution,//配货中
    TXSJOrderDetailStatusTypeDelivery,//配送中
    TXSJOrderDetailStatusTypeComplete,//已完成
    TXSJOrderDetailStatusTypeCompleteConfirmGoods,//已完成 未确认收货
    TXSJOrderDetailStatusTypeCompleteAppraise,//已完成 未评价
    TXSJOrderDetailStatusTypeCancel,// 已关闭
    TXSJOrderDetailStatusTypeCancelAllocate,//已取消 配货中
    TXSJOrderDetailStatusTypeAudit,//审核中
    TXSJOrderDetailStatusTypeExchange,//完成换货
    TXSJOrderDetailStatusTypeReturn,//退回商品
    TXSJOrderDetailStatusTypeNegotiate,//协商处理
    TXSJOrderDetailStatusTypeRefunds, //完成退款
    TXSJOrderDetailStatusTypeAfterClosing, //售后关闭
    TXSJOrderDetailStatusTypeRefundCarried, //退款中
    TXSJOrderDetailStatusTypeCancelAfter, //撤销售后申请
    TXSJOrderDetailStatusTypeDelete //删除订单
};

//更改订单状态  订单状态 1 取消订单 2 删除订单 3 确认收货
typedef NS_ENUM(NSUInteger, TXSJChangeOrderStatusType) {
    TXSJChangeOrderStatusTypeCancel = 1,
    TXSJChangeOrderStatusTypeDelete,
    TXSJChangeOrderStatusTypeSureGetGood
};

///弹框类型
typedef NS_ENUM(NSUInteger, TXSJPopADType) {
    ///通知
    TXSJPopADTypeNotify = 0,
    ///领券
    TXSJPopADTypeCoupon ,
    ///新人礼包
    TXSJPopADTypeNewGift ,
};

///商品状态
typedef NS_ENUM(NSUInteger, TXSJGoodsBottomState) {
    ///已下架
    TXSJGoodsBottomStateSoldOut = 1,
    ///已售罄
    TXSJGoodsBottomStateSellOut,
    ///立即预订
    TXSJGoodsBottomStateOrderNow,
    ///加入购物车
    TXSJGoodsBottomStateAddToShoppingCar,
    ///查看其它预售商品
    TXSJGoodsBottomStateFindOther,
};

///v1.1版本 首页商品状态 使用
typedef NS_ENUM(NSUInteger, TXSJMainHomeGoodsStateV11) {
    ///正常 有库存
    TXSJMainHomeGoodsStateV11Normal = 1,
    ///已售罄
    TXSJMainHomeGoodsStateV11SellOut,
    ///已下架
    TXSJMainHomeGoodsStateV11Down
};

///商品下架状态 商品下架状态 0-->未到上线时间  1-->正常上线  2-->已过下架时间
typedef NS_ENUM(NSUInteger, TXSJGoodsSaleTimeType) {
    ///未到上线时间
    TXSJGoodsSaleTimeTypeBeforeSaleTime = 0,
    ///正常上线
    TXSJGoodsSaleTimeTypeOnSale,
    ///已过下架时间
    TXSJGoodsSaleTimeTypeAfterSaleTime,
    ////已售罄
    TXSJGoodsSaleTimeTypeSoldOut,
};

//分享类型0 商品 1活动
typedef NS_ENUM(NSUInteger, TXSJShareType) {
    ///商品
    TXSJShareTypeGoods = 0,
    ///活动
    TXSJShareTypeActivity,
};
//来源描述
typedef NS_ENUM(NSUInteger, TXSJSourceDescriptionType) {

    TXSJSourceDescriptionTypeUnknown = 0,///未知来源
    ///v1.1老的不处理，也先不删除
    TXSJSourceDescriptionTypeHomeBanner,//首页banner
    TXSJSourceDescriptionTypeHomeBoZaiRecommend,//首页波仔推荐
    TXSJSourceDescriptionTypeHomeBargain,//首页特价商品
    TXSJSourceDescriptionTypeHomeSingleRecommend,//首页单品推荐
    TXSJSourceDescriptionTypeHomeBookingGoods,//首页预售商品
    TXSJSourceDescriptionTypeBookingGoodsList,//预售商品列表
    TXSJSourceDescriptionTypeHomeProject,// 首页专题
    TXSJSourceDescriptionTypeHomeTalentFood,//首页达人食荐
    TXSJSourceDescriptionTypeEventDetails,//活动详情页
    TXSJSourceDescriptionTypeClassificationList,//商品列表（分类）
    TXSJSourceDescriptionTypePooledList,//商品列表（凑单）
    TXSJSourceDescriptionTypePhysicalCoupons,//实物优惠券
    TXSJSourceDescriptionTypeDetailsRecommend,//商详页推荐商品
    TXSJSourceDescriptionTypeIntegralExchange,//积分兑换
    TXSJSourceDescriptionTypeAlreadyBoughtOrder,//已购订单
    TXSJSourceDescriptionTypeShoppingCart,//购物车复购
    TXSJSourceDescriptionTypeBeginnersBuy,//新手必买
    TXSJSourceDescriptionTypePopupWindow,//弹窗
    TXSJSourceDescriptionTypePush,  //推送
    TXSJSourceDescriptionTypeSweepCode,  //扫码购
    ///v1.1.1新整理的类型
    TXSJSourceDescriptionTypeNewHomeBanner = 101,  //首页banner
    TXSJSourceDescriptionTypeNewHomeSelectionActivity , //精选活动
    TXSJSourceDescriptionTypeNewHomeMoreGoods , //更多好货
    TXSJSourceDescriptionTypeNewHomeHotSale , //人气销量榜
    TXSJSourceDescriptionTypeNewHomeNewTaste , //新品尝鲜
    TXSJSourceDescriptionTypeNewHomeActivityMore , //活动（多商品）
    TXSJSourceDescriptionTypeNewHomeActivityLitte , //活动（少商品）
    TXSJSourceDescriptionTypeSpecial , //专题
    TXSJSourceDescriptionTypeNewClassificationList,//商品列表（分类）
    TXSJSourceDescriptionTypeNewPooledList,//商品列表（凑单）
    TXSJSourceDescriptionTypeNewDetailsRecommend,//商详页推荐商品
    TXSJSourceDescriptionTypeNewPhysicalCoupons,//实物优惠券
    TXSJSourceDescriptionTypeNewShoppingCart,//购物车复购
    TXSJSourceDescriptionTypeBuyFromOrder,//订单复购
    TXSJSourceDescriptionTypeNewBeginnersBuy,//新手必买
    TXSJSourceDescriptionTypeNewHomeIcon,//十大Icon
    TXSJSourceDescriptionTypeEveryDayHotSell,//今日热销

};
///商品类型
typedef NS_ENUM(NSUInteger, TXSJGoodsSaleType) {
    ///普通商品
    TXSJGoodsSaleTypeNormal = 0,
    ///预售商品
    TXSJGoodsSaleTypePresell,
};

///支付类型 ,界面上写的1，2...这里也顺便定义成1，2...
typedef NS_ENUM(NSUInteger, TXSJPaymentPayType) {
    ///支付宝
    TXSJPaymentPayTypeAlipay = 1,
    ///微信
    TXSJPaymentPayTypeWeixin = 2,
};
///购物车类型
typedef NS_ENUM(NSInteger, TXSJCartAnimationType) {
    TXSJCartAnimationTypeTabbarCart = 0, ///tabbar
    TXSJCartAnimationTypeRigthCart,            //右上角
    TXSJCartAnimationTypeDetailCart,            //详情位置
};
#pragma mark --  Block
typedef void (^VoidBlock)(void);

typedef NS_ENUM(NSInteger, TXSJHomeCellType) {
    TXSJHomeCellTypeBanner = 1,//banner
    TXSJHomeCellTypeClassification,//分类
    TXSJHomeCellTypeNewUserGift,//新人礼
    TXSJHomeCellTypeNormalChannelNew,//常规频道（新）
    TXSJHomeCellTypeCommonTitle,//精选活动等标题
    TXSJHomeCellTypeSeperatorLine,//分割线
    TXSJHomeCellTypeSeperatorSpace,//分隔区域
    TXSJHomeCellTypeMoreGoods,//更多商品
    TXSJHomeCellTypeRecommendTopic,//精选话题
    TXSJHomeCellTypeOneRowMaxThreeGoods,//1排3个商品样式
    TXSJHomeCellTypeEveryDayHotSell,//每日热销
    TXSJHomeCellTypeSpecialTitle,//带图片的标题
    TXSJHomeCellTypeNormalChannel//常规频道（旧）
};

#endif /* XGOATypes_h */
