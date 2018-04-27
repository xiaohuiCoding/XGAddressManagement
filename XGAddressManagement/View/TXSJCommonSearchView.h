//
//  XGOAMessageSearchInputView.h
//  XGOA
//  搜索框
//  Created by 虞振兴 on 2017/4/18.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#define SearchTextFieldNormalLengthMax 40

#import <UIKit/UIKit.h>
@protocol TXSJCommonSearchViewDelegate <NSObject>
@optional
- (void)rightActionBtnClicked:(BOOL)isSearching;
- (void)cancelSearchBtnClick;
- (void)searchTextFieldInputAction:(NSString *)searchTxt; //搜索框输入回调 或者 是 键盘搜索（完成）按钮点击回调
//左边 返回箭头 点击事件
-(void)commonSearchLeftButtonClicked:(BOOL)isBackIconLeftBtn;

@end

@interface TXSJCommonSearchView : UIView
@property (nonatomic,weak) id <TXSJCommonSearchViewDelegate> delegate;
@property (nonatomic,strong) UITextField *searchTF;//搜索框
@property (nonatomic,copy) NSString *placeHolder;
@property (nonatomic,assign) BOOL isOpenKeyBoard;
@property (nonatomic,assign) BOOL isTimeToSearch;//是否是实时搜索
@property (nonatomic,strong) UIButton *searchTempBtn;

@property (nonatomic,strong) UIButton *rightBtn;//右边的按钮
@property (nonatomic,copy) NSString *rightBtnTitle;//设置右边按钮的 文字

@property (nonatomic,strong) UIButton *leftButton;//左边的按钮
@property (nonatomic,copy) NSString *leftBtnTitle;//设置左边按钮的 文字

//初始化  maxLength 最大字符限制
- (instancetype)initWithCoder:(NSCoder *)aDecoder UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame withMaxLength:(NSInteger)maxLength;
//初始化  maxLength 最大字符限制 左边按钮的 文字
- (instancetype)initWithFrame:(CGRect)frame withMaxLength:(NSInteger)maxLength withRightBtnTitle:(NSString *)rightBtnTitle NS_DESIGNATED_INITIALIZER;
////初始化  maxLength 最大字符限制 左边按钮的 文字 右边按钮的文字 1.1需求：左边 搜索时会是 城市 如义乌
//- (instancetype)initWithFrame:(CGRect)frame withMaxLength:(NSInteger)maxLength withRightBtnTitle:(NSString *)rightBtnTitle withLeftBtnTitle:(NSString *)leftBtnTitle NS_DESIGNATED_INITIALIZER;
@end
