//
//  XGOAAlertView.h
//  XGOA
//
//  Created by wangdf on 2017/4/10.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#import <UIKit/UIKit.h>
////action Sheet
typedef void(^XGOAActionSheetBlock)(NSInteger buttonIndex);
///alert block
typedef void(^XGOAAlertBlock)(void);

@interface UIAlertController(XGTCAlert)

////直接初始化按钮，block返回按钮index
+ (instancetype)xg_initActionSheetWithTitle:(NSString *)title message:(NSString *)message actionBlock:(XGOAActionSheetBlock)actionBlock cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

///只初始化一个空的，其它的action还是可以让用户自己去添加
+ (instancetype)xg_initActionSheetWithTitle:(NSString *)title message:(NSString *)message actionBlock:(XGOAActionSheetBlock)actionBlock;

///直接初始化为alertView
+ (instancetype)xg_initWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle cancelBlock:(XGOAAlertBlock)cancelBlock;
+ (instancetype)xg_initWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle cancelBlock:(XGOAAlertBlock)cancelBlock okButtonTitle:(NSString*)okButtonTitle okBlock:(XGOAAlertBlock)okBlock;

/**
 *  显示系统AlertView
 *  仅支持[确认][取消]两个button事件，index=0为取消，1为自定义按钮
 *
 *  @param title               title
 *  @param message             message
 *  @param currentVC           present UIAlertViewController
 *  @param cancelButtonTitle   cancelButtonTitle
 *  @param confirmButtonTitle  confirmButtonTitle
 *  @param handler             button handler
 */
+ (void)xg_showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                     currentVC:(id)currentVC
             cancelButtonTitle:(NSString *)cancelButtonTitle
            comfirmButtonTitle:(NSString *)confirmButtonTitle
                 buttonHandler:(void (^)(int))handler;

@end
