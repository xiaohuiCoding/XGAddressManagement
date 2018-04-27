//
//  TXSJCommomCell.h
//  retail
//
//  Created by 虞振兴 on 2017/8/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXSJCommonItemViewModel.h"
@protocol TXSJCommomCellDelegate <NSObject>
@optional
-(void)commomCellRightBtnClickWithType:(TXSJCommonCellType)type;
@end

@interface TXSJCommomCell : UITableViewCell
@property (nonatomic,weak) id <TXSJCommomCellDelegate> delegate;

@property (nonatomic,strong) UIImageView *symIV;//icon
@property (nonatomic,strong) UILabel *titleLab; //标题
@property (nonatomic,strong) UILabel *subContentLab; //内容  第二标题
@property (nonatomic,strong) UIButton *rightBtn; //右边 按钮
@property (nonatomic,strong)UIImageView *arrowIV;////右箭头 根据类型决定有木有箭头

@property (nonatomic,strong) TXSJCommonItemViewModel *viewModel;

@property (nonatomic,assign) BOOL isAllwidthSeparatorLine;//是否是 整宽的 分割线  还是普通空一部分的线

//隐藏或者显示 线～～  暂时只有 Value1类型有线
-(void)hiddenOrShowLine:(BOOL)isHidden;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  withType:(TXSJCommonCellType)type;
@end
