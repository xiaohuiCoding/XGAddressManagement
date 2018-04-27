//
//  TXSJCommonModel.h
//  retail
//  TXSJCommonCell TXSJCommonViewModel 使用
//  Created by 虞振兴 on 2017/8/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <XGTCBaseModel.h>

@interface TXSJCommonModel : XGTCBaseModel

@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *subContentStr;
@property (nonatomic,strong) NSString *picUrl;

/** 地址 使用  **/
@property (nonatomic,assign) CGFloat latitude;
@property (nonatomic,assign) CGFloat longitude;
@property (nonatomic,strong) NSString *poiName; //～～用户的收货地址  titleStr要显示 姓名加电话
@property (nonatomic,strong) NSString *province;//省
@property (nonatomic,strong) NSString *city;//城市
@property (nonatomic,strong) NSString *area;//区域

-(instancetype)initWithTitle:(NSString *)title subContent:(NSString *)content latitude:(CGFloat)latitude longitude:(CGFloat)longitude province:(NSString *)province city:(NSString *)city area:(NSString *)area;

-(instancetype)initWithTitle:(NSString *)title subContent:(NSString *)content;

-(instancetype)initWithTitle:(NSString *)title subContent:(NSString *)content  picUrl:(NSString *)picUrl;
@end
