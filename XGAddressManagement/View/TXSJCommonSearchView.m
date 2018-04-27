//
//  XGOAMessageSearchInputView.m
//  XGOA
//  搜索框 加 取消按钮的view
//  Created by 虞振兴 on 2017/4/18.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#import "TXSJCommonSearchView.h"
#import "NSString+Util.h"

#define TXSJSearchViewCancelRightTitle @"取消"

@interface TXSJCommonSearchView() <UITextFieldDelegate>

@property (nonatomic, assign) NSInteger maxNumberOfDescriptionChars;    //最大限制字符个数
@property (nonatomic,strong) UIButton *clearButton;
@property (nonatomic, assign) BOOL isBackIconLeftBtn;//是否是 返回的 左按钮

///上次任务
@property (nonatomic, copy) dispatch_block_t lastSearchBlock;
@end

@implementation TXSJCommonSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame withMaxLength:CGFLOAT_MAX];
}

- (instancetype)initWithFrame:(CGRect)frame withMaxLength:(NSInteger)maxLength {
    return [self initWithFrame:frame withMaxLength:maxLength withRightBtnTitle:@"确定"];
}

//初始化  maxLength 最大字符限制 左边按钮的 文字
- (instancetype)initWithFrame:(CGRect)frame withMaxLength:(NSInteger)maxLength withRightBtnTitle:(NSString *)rightBtnTitle{
    self = [super initWithFrame:frame];
    _maxNumberOfDescriptionChars = maxLength;
    _rightBtnTitle = rightBtnTitle;
    _isBackIconLeftBtn = YES;
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setPlaceHolder:(NSString *)placeHolder{
    if (_searchTF) {
        _searchTF.placeholder = placeHolder;
    }
}

- (void)setUpUI{
    self.backgroundColor = [UIColor whiteColor];
    
    self.leftButton.frame = CGRectMake(TXSJCommonPadding, 7, 30, 30);
    [self.leftButton addTarget:self action:@selector(leftBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setImage:ImageNamed(@"icon_back") forState:UIControlStateNormal];
    [self addSubview: self.leftButton];
    
    UIView *seperatorLine1 = [[UIView alloc] init];
    seperatorLine1.backgroundColor = kLineColor;
    [self addSubview:seperatorLine1];
    [seperatorLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(66);
        make.top.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(1, 24));
    }];
  
    [self addSubview:self.rightBtn];
    
    self.rightBtn.frame = [self rectForRightBtnTitle];
    
    UIView *seperatorLine2 = [[UIView alloc] init];
    seperatorLine2.backgroundColor = UIColorHex(0xe5e5e5);
    [self.rightBtn addSubview:seperatorLine2];
    [seperatorLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightBtn.mas_left).offset(0);
        make.centerY.mas_equalTo(self.rightBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 24));
    }];
    
    [self  addSubview:self.searchTF];
    //搜索
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(seperatorLine1.mas_right).offset(23);
        make.right.equalTo(self.rightBtn.mas_left).offset(-3);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(seperatorLine1.mas_centerY);
    }];
    
    _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearButton.hidden = YES;
    [_clearButton setImage:[UIImage imageNamed:@"addresssearch_clear"] forState:UIControlStateNormal];
    [self  addSubview:_clearButton];
    [_clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.right.equalTo(self.rightBtn.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.searchTF.mas_centerY);
    }];
    
    _searchTempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchTempBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:_searchTempBtn];
    [_searchTempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.searchTF);
    }];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLineColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self bindViewModel];
}

//右边按钮的 CGRect rightBtn～～使用
-(CGRect)rectForRightBtnTitle{
    [self.leftButton setTitle:@"  " forState:UIControlStateNormal];
    CGFloat width = 0;
    if(self.searchTempBtn.hidden){
        width = TXSJSearchViewCancelRightTitle.length  * 15 + 30;
    }else if(!self.rightBtnTitle || [self.rightBtnTitle isEmptyString]) {
        width = 0;
    }else {
       width = self.rightBtnTitle.length * 15 + 30;
    }
    
    CGRect rect = CGRectMake(self.width - width, 0, width, self.height);
   
    return rect;
}

//左边按钮的 CGRect  leftBtn～～使用
-(CGRect)rectForLeftBtnTitle{
    CGRect rect;
    if(!self.searchTempBtn.hidden){
        rect = CGRectMake(TXSJCommonPadding, 7, 30, 30);
        self.isBackIconLeftBtn = YES;
    }else if(!self.leftBtnTitle || [self.leftBtnTitle isEmptyString]) {
        rect = CGRectMake(TXSJCommonPadding, 7, 30, 30);
        self.isBackIconLeftBtn = YES;
    }else {
        rect = CGRectMake(TXSJCommonPadding, 7, self.leftBtnTitle.length * 15 + 4, 30);
        self.isBackIconLeftBtn = NO;
    }
    
    return rect;
}

- (void)bindViewModel {
    WEAKSELF(weakSelf);
    
    //搜索空白按钮～～  用于改变头部布局
    [[self.searchTempBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONGSELF(strongSelf);
        strongSelf.searchTempBtn.hidden = YES;
        [strongSelf changeLayoutWithSearchStatus];
    }];
    
    [[self.clearButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
         STRONGSELF(strongSelf);
        strongSelf.searchTF.text = @"";
    }];
    
    [[[RACObserve(self.searchTempBtn, hidden) distinctUntilChanged] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        STRONGSELF(strongSelf);
        [strongSelf changeLayoutWithSearchStatus];
    }];
    
    
    [[self.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]  subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONGSELF(strongSelf);
        if ([strongSelf.delegate respondsToSelector:@selector(rightActionBtnClicked:)]) {
            [strongSelf.delegate rightActionBtnClicked:strongSelf.searchTempBtn.hidden];
        }
    }];
    
    [self changeLayoutWithSearchStatus];
}


//设置右边按钮的 文字
-(void)setRightBtnTitle:(NSString *)rightBtnTitle {
    _rightBtnTitle = rightBtnTitle;
    self.rightBtn.frame = [self rectForRightBtnTitle];
    [self layoutSubviews];
}

//设置左边按钮的 文字
-(void)setLeftBtnTitle:(NSString *)leftBtnTitle{
    _leftBtnTitle = leftBtnTitle;
   // 搜索 输入状态 的时候  左边按钮显示为文字 （义乌）
    self.leftButton.frame = [self rectForLeftBtnTitle];
    [self layoutSubviews];
}


//改变布局  根据是否是搜索状态
-(void)changeLayoutWithSearchStatus{
 
    self.clearButton.hidden = !self.searchTempBtn.hidden || self.searchTF.text.length==0;
    NSString *rightBtnNeedStr = self.searchTempBtn.hidden?TXSJSearchViewCancelRightTitle:self.rightBtnTitle;
    
    WEAKSELF(weakSelf);
    [UIView animateWithDuration:0.2 animations:^{
        STRONGSELF(strongSelf);
        CGFloat searchTF_firstX = strongSelf.searchTempBtn.hidden?TXSJCommonPadding : UIScale(84);
        
        strongSelf.leftButton.frame = [strongSelf rectForLeftBtnTitle];
        
        strongSelf.rightBtn.frame = [strongSelf rectForRightBtnTitle];
        
        strongSelf.clearButton.frame = CGRectMake(strongSelf.rightBtn.x - 5 - strongSelf.clearButton.width,strongSelf.clearButton.y, strongSelf.clearButton.width, strongSelf.clearButton.height);
        //~~!这view就用于地址相关了～～！
        strongSelf.searchTF.frame = CGRectMake(strongSelf.searchTF.x, strongSelf.searchTF.y, strongSelf.width - searchTF_firstX - strongSelf.rightBtn.width - 10, strongSelf.searchTF.height);
        
    } completion:^(BOOL finished) {
        STRONGSELF(strongSelf);
         [strongSelf.rightBtn setTitle:rightBtnNeedStr forState:UIControlStateNormal];
        //左按钮  根据isBackIconShow 显示对应样式
        [strongSelf.leftButton setTitle:strongSelf.isBackIconLeftBtn?@"  ":self.leftBtnTitle forState:UIControlStateNormal];
        [strongSelf.leftButton setImage:strongSelf.isBackIconLeftBtn?ImageNamed(@"icon_back"):[UIImage new] forState:UIControlStateNormal];
    }];
    
    [self setIsOpenKeyBoard:self.searchTempBtn.hidden];
}


- (void)setIsOpenKeyBoard:(BOOL)isOpenKeyBoard {
    _isOpenKeyBoard = isOpenKeyBoard;
    isOpenKeyBoard?[self.searchTF becomeFirstResponder]:[self.searchTF resignFirstResponder];
}



#pragma mark - properties 

-(UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitleColor:kTitleColor forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn setTitle:self.rightBtnTitle forState:UIControlStateNormal];
    }
    return _rightBtn;
}

-(UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitleColor:kTitleColor forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _leftButton;
}

-(UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] init];
        _searchTF.backgroundColor = [UIColor whiteColor];
        _searchTF.delegate = self;
        _searchTF.placeholder = @"请输入您的收货地址";
        _searchTF.font = FONT_13;
        _searchTF.returnKeyType = UIReturnKeySearch;
    }
    return _searchTF;
}



#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string&&string.length>0&&![string predicateSearchText]) {
        return NO;
    }
    NSString *beString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (beString.length>self.maxNumberOfDescriptionChars&&self.maxNumberOfDescriptionChars!=0) {
        return NO;
    }
    //时时搜索
    if(self.isTimeToSearch){
        [self searchToResult:beString];
    }
    self.clearButton.hidden = beString.length==0;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.searchTF&&self.searchTF.becomeFirstResponder) {
        [self.searchTF resignFirstResponder];
    }
    [self searchToResult];
    return YES;
}

- (void)searchToResult{
    [self searchToResult:self.searchTF.text];
}

- (void)searchToResult:(NSString *)beString{
    if ([self.delegate respondsToSelector:@selector(searchTextFieldInputAction:)]) {
        WEAKSELF(weakSelf);
        if (self.lastSearchBlock) {
            dispatch_block_cancel(self.lastSearchBlock);
        }
        dispatch_block_t block = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            STRONGSELF(strongSelf);
            [strongSelf.delegate searchTextFieldInputAction:beString];
        });
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.2 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), block);

        self.lastSearchBlock = block;
    }
}

-(void)leftBackClicked:(id)btn{
    if ([self.delegate respondsToSelector:@selector(commonSearchLeftButtonClicked:)]) {
        [self.delegate commonSearchLeftButtonClicked:self.isBackIconLeftBtn];
    }
}



@end
