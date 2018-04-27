//
//  TXSJCommomCell.m
//  retail
//
//  Created by 虞振兴 on 2017/8/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJCommomCell.h"

@interface TXSJCommomCell()
@property (nonatomic,assign) TXSJCommonCellType type;

@property (nonatomic,strong) UIView *sepratorBottomLine;//底部分割线

@end

@implementation TXSJCommomCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initLayout];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(TXSJCommonCellType)type{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.type = type;
        [self initLayout];
    }
    return self;
}

- (void)initLayout {
    self.backgroundColor = [UIColor whiteColor];
    switch (self.type) {
        case TXSJCommonCellTypeUserLocation: {
            //icon
            self.symIV.sd_layout.topSpaceToView(self.contentView, 15)
            .leftSpaceToView(self.contentView, 16)
            .widthIs(20)
            .heightIs(20);
            //title
            self.titleLab.font = Font_Name_Size(@"PingFangSC-Semibold", 14);
            self.titleLab.sd_layout.leftSpaceToView(self.symIV, 8)
            .heightIs(UIScaleHeight(17));
            [self.titleLab setSingleLineAutoResizeWithMaxWidth:kScreenWidth - 44 - UIScale(90) - TXSJShortPadding - 15];
            
            //rightbtn
            [self.rightBtn setImage:ImageNamed(@"positioning_refresh") forState:UIControlStateNormal];
            [self.rightBtn setTitle:@" 重新定位" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:kTitleColor2 forState:UIControlStateNormal];
            //            self.rightBtn.titleLabel.font = Font_Name_Size(@"AppleSDGothicNeo-Regular", 14);
            self.rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            self.rightBtn.sd_layout.centerYEqualToView(self.contentView)
            .rightSpaceToView(self.contentView, TXSJShortPadding)
            .widthIs(UIScale(90))
            .heightIs(UIScale(44));
            //subcontent
            
            self.subContentLab.font = FONT_12;
            self.subContentLab.sd_layout.topSpaceToView(self.titleLab, 4)
            .leftEqualToView(self.titleLab)
            .rightSpaceToView(self.rightBtn, TXSJShortPadding)
            .autoHeightRatio(0);
            self.subContentLab.text = @"";
            
            self.sepratorBottomLine.sd_layout.topSpaceToView(self.subContentLab, 15)
            .leftSpaceToView(self.contentView,TXSJCommonPadding)
            .rightSpaceToView(self.contentView,TXSJCommonPadding)
            .heightIs(kLineNormalHeight);
            
            [self setupAutoHeightWithBottomView:self.sepratorBottomLine bottomMargin:0];
            
            break;
        }
        case TXSJCommonCellTypeGoLogin:{//登录按钮
            self.titleLab.font = FONT_14;
            self.titleLab.sd_layout.topEqualToView(self.contentView).leftSpaceToView(self.contentView,16).widthIs(UIScale(240)).heightIs(UIScale(65));
            //rightbtn
            self.rightBtn.layer.cornerRadius = 1;
            self.rightBtn.layer.borderColor = UIColorHex(0xcdac69).CGColor;
            self.rightBtn.layer.borderWidth = 1;
            [self.rightBtn setImage:nil forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"登录" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:UIColorHex(0xcdac69) forState:UIControlStateNormal];
            self.rightBtn.sd_layout.centerYEqualToView(self.contentView)
            .rightSpaceToView(self.contentView, TXSJCommonPadding)
            .widthIs(UIScale(60))
            .heightIs(UIScale(30));
            [self setupAutoHeightWithBottomView:self.titleLab bottomMargin:0];
            break;
        }
        case TXSJCommonCellTypeContentNoArrow://标题  右边子内容 没右箭头,icon
        case TXSJCommonCellTypeValue1: ////icon 标题  右边子内容  加 一个右箭头
        case TXSJCommonCellTypeValue2:{//标题  右边子内容  加 一个右箭头
            //icon
            self.symIV.sd_layout.centerYEqualToView(self.contentView)
            .leftSpaceToView(self.contentView, TXSJCommonPadding)
            .widthIs(UIScaleHeight(22))
            .heightEqualToWidth();
            //title
            self.titleLab.sd_layout.centerYEqualToView(self.contentView)
            .leftSpaceToView(self.symIV, 15)
            .heightIs(UIScaleHeight(21));
            [self.titleLab setSingleLineAutoResizeWithMaxWidth:UIScale(240)];
            //右箭头
            _arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_arrow"]];
            [self.contentView addSubview:_arrowIV];
            _arrowIV.sd_layout.centerYEqualToView(self.contentView)
            .rightSpaceToView(self.contentView, TXSJCommonPadding)
            .widthIs(UIScale(14))
            .heightIs(UIScale(14));
            
            //subcontent
            self.subContentLab.sd_layout.centerYEqualToView(self.contentView)
            .rightSpaceToView(_arrowIV, UIScale(2))
            .heightIs(UIScaleHeight(15));
            [self.subContentLab setSingleLineAutoResizeWithMaxWidth:UIScale(240)];
            
            self.sepratorBottomLine.sd_layout.bottomSpaceToView(self.contentView, kLineNormalHeight)
            .leftSpaceToView(self.contentView,TXSJCommonPadding)
            .rightSpaceToView(self.contentView,TXSJCommonPadding)
            .heightIs(kLineNormalHeight);
            
            //标题  右边子内容  加 一个右箭头
            if (_type == TXSJCommonCellTypeValue2) {
                self.symIV.sd_layout.widthIs(0);
                self.symIV.hidden = YES;
                self.titleLab.sd_layout.leftSpaceToView(self.contentView,16);
            }
            //标题  右边子内容 没右箭头,icon
            if (_type == TXSJCommonCellTypeContentNoArrow) {
                self.symIV.sd_layout.widthIs(0);
                self.symIV.hidden = YES;
                _arrowIV.sd_layout.widthIs(0);
                _arrowIV.hidden = YES;
                
                self.titleLab.sd_layout.leftSpaceToView(self.contentView,16);
            }
            
            //             [self setupAutoHeightWithBottomView:self.titleLab bottomMargin:TXSJShortPadding];
            break;
        }
        case TXSJCommonCellTypeLineSeprator:{
            self.backgroundColor = kLineColor;
            break;
        }
            
        default:  {
            //title
            self.titleLab.font = Font_Name_Size(@"PingFangSC-Semibold", 14);
            self.titleLab.sd_layout.topSpaceToView(self.contentView, 15)
            .leftSpaceToView(self.contentView,16)
            .heightIs(UIScaleHeight(17));
            [self.titleLab setSingleLineAutoResizeWithMaxWidth:kScreenWidth - 16 *2];
            //subcontent
            self.subContentLab.font = FONT_12;
            self.subContentLab.sd_layout.topSpaceToView(self.titleLab, 4)
            .leftEqualToView(self.titleLab)
            .rightSpaceToView(self.contentView, 16)
            .autoHeightRatio(0);
            
            self.sepratorBottomLine.sd_layout.topSpaceToView(self.subContentLab, 15)
            .leftSpaceToView(self.contentView,TXSJCommonPadding)
            .rightSpaceToView(self.contentView,TXSJCommonPadding)
            .heightIs(kLineNormalHeight);
            
            [self setupAutoHeightWithBottomView:self.sepratorBottomLine bottomMargin:0];
            break;
        }
    }
}

-(void)setViewModel:(TXSJCommonItemViewModel *)viewModel {
    _viewModel = viewModel;
    
    switch (self.type) {
        case TXSJCommonCellTypeUserLocation: {
            if(!viewModel.data.subContentStr || [viewModel.data.subContentStr isEmptyString]) {
                self.symIV.sd_layout.topSpaceToView(self.contentView, 17);
                self.titleLab.sd_layout.topSpaceToView(self.contentView, 18);
            }else {
                self.symIV.sd_layout.topSpaceToView(self.contentView, 23);
                self.titleLab.sd_layout.topSpaceToView(self.contentView, 15);
            }
            self.symIV.image = ImageNamed(@"location");
            
            self.titleLab.text = viewModel.data.titleStr;
            
            self.subContentLab.text = viewModel.data.subContentStr;
            
            //行间距
            self.subContentLab.isAttributedContent = YES;
            self.subContentLab.attributedText = [TXSJCommonUtils generateAttributeTextWithText:self.subContentLab.text withFont:self.subContentLab.font withSpace:TXSJLinePaddingHeight];
            
            break;
        }
        case TXSJCommonCellTypeValue1:
        case TXSJCommonCellTypeValue2: {
            //TXSJCommonCellTypeValue2 是没有icon的
            if(_type == TXSJCommonCellTypeValue1) {
                if (!viewModel.data.picUrl||[viewModel.data.picUrl isEmptyString]) {
                    self.symIV.image = Default_IMG_1;
                }else if ([viewModel.data.picUrl isHttpUrl]) {//网络图片的话就下载
//                    [self.symIV sd_setImageWithURL:[NSURL URLWithString:viewModel.data.picUrl] placeholderImage:Default_IMG_1];
                }else {//app包内文件
                    self.symIV.image = ImageNamed(viewModel.data.picUrl);
                }
            }
            self.titleLab.text = viewModel.data.titleStr;
            self.subContentLab.text = viewModel.data.subContentStr;
            break;
        }
        default: {
            self.titleLab.text = viewModel.data.titleStr;
            self.subContentLab.text = viewModel.data.subContentStr;
            //行间距
            self.subContentLab.isAttributedContent = YES;
            self.subContentLab.attributedText = [TXSJCommonUtils generateAttributeTextWithText:self.subContentLab.text withFont:self.subContentLab.font withSpace:TXSJLinePaddingHeight];
            
            break;
        }
    }
    
    
    [self layoutSubviews];
}


-(void)rightBtnClick{
    if ([self.delegate respondsToSelector:@selector(commomCellRightBtnClickWithType:)]) {
        [self.delegate commomCellRightBtnClickWithType:self.viewModel.type];
    }
}

//isAllwidthSeparatorLine;//是否是 整宽的 分割线  还是普通空一部分的线
-(void)setIsAllwidthSeparatorLine:(BOOL)isAllwidthSeparatorLine {
    _isAllwidthSeparatorLine = isAllwidthSeparatorLine;
    if (_sepratorBottomLine) {
        _sepratorBottomLine.sd_layout.leftSpaceToView(self.contentView, _isAllwidthSeparatorLine?0:TXSJCommonPadding)
        .widthIs(_isAllwidthSeparatorLine?kScreenWidth:kScreenWidth - 2*TXSJCommonPadding);
    }
    [self layoutSubviews];
}

//隐藏或者显示 线～～  暂时只有 Value1类型有线
-(void)hiddenOrShowLine:(BOOL)isHidden {
    if (_sepratorBottomLine) {
        _sepratorBottomLine.hidden = isHidden;
    }
    [self layoutSubviews];
}

-(UIView *)sepratorBottomLine {
    if (!_sepratorBottomLine) {
        _sepratorBottomLine = [[UIView alloc] init];
        _sepratorBottomLine.backgroundColor = kLineColor;
        [self.contentView addSubview:_sepratorBottomLine];
    }
    return _sepratorBottomLine;
}


-(UIImageView *)symIV {
    if (!_symIV) {
        _symIV = [[UIImageView alloc] initWithFrame:CGRectMake(TXSJCommonPadding, TXSJShortPadding, UIScaleHeight(40), UIScaleHeight(40))];
        [self.contentView addSubview:_symIV];
    }
    return _symIV;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = FONT_15;
        _titleLab.textColor = kTitleColor;
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}

-(UILabel *)subContentLab {
    if (!_subContentLab) {
        _subContentLab = [[UILabel alloc] init];
        _subContentLab.font = FONT_14;
        _subContentLab.textColor = kContentColor;
        [self.contentView addSubview:_subContentLab];
    }
    return _subContentLab;
}

-(UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitleColor:kTitleColor forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = FONT_14;
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rightBtn];
    }
    return _rightBtn;
}

@end
