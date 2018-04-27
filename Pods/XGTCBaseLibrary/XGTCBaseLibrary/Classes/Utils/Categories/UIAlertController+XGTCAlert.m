//
//  XGOAAlertView.m
//  XGOA
//
//  Created by wangdf on 2017/4/10.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#import "UIAlertController+XGTCAlert.h"


@implementation  UIAlertController(XGTCAlert)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

////直接初始化按钮，block返回按钮index
+ (instancetype)xg_initActionSheetWithTitle:(NSString *)title message:(NSString *)message actionBlock:(XGOAActionSheetBlock)actionBlock cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];;

        NSInteger buttonIndex = 0;
        va_list strButtonNameList;
        va_start(strButtonNameList, otherButtonTitles);
        for (NSString *strBtnTitle = otherButtonTitles; strBtnTitle != nil; strBtnTitle = va_arg(strButtonNameList, NSString*))
        {
            [self xg_addActionButtonWithTitle:strBtnTitle index:buttonIndex style:UIAlertActionStyleDefault tapBlock:actionBlock alert:alert];
            buttonIndex++;
        }
        va_end(strButtonNameList);


        if(destructiveButtonTitle) {
            [self xg_addActionButtonWithTitle:destructiveButtonTitle index:buttonIndex style:UIAlertActionStyleDestructive  tapBlock:actionBlock alert:alert];
            buttonIndex++;
        }

        if(cancelButtonTitle) {
            [self xg_addActionButtonWithTitle:cancelButtonTitle index:buttonIndex style:UIAlertActionStyleCancel tapBlock:actionBlock alert:alert];
            //        buttonIndex++;
        }
    return alert;
}


///只初始化一个空的，其它的action还是可以让用户自己去添加
+ (instancetype)xg_initActionSheetWithTitle:(NSString *)title message:(NSString *)message actionBlock:(XGOAActionSheetBlock)actionBlock {
    return [self xg_initActionSheetWithTitle:title message:message actionBlock:[actionBlock copy] cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
}

///直接初始化为alertView
+ (instancetype)xg_initWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle cancelBlock:(XGOAAlertBlock)cancelBlock {
    return [self xg_initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle cancelBlock:cancelBlock okButtonTitle:nil okBlock:nil];
}


+ (instancetype)xg_initWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle cancelBlock:(XGOAAlertBlock)cancelBlock okButtonTitle:(NSString*)okButtonTitle okBlock:(XGOAAlertBlock)okBlock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];


    if (cancelButtonTitle) {
        UIAlertAction* action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           if (cancelBlock) {
                                                               cancelBlock();
                                                           }
                                                       }];
        [alert addAction:action];
    }

    if (okButtonTitle) {
        UIAlertAction* action = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           if (okBlock) {
                                                               okBlock();
                                                           }
                                                       }];
        [alert addAction:action];
    }

    return alert;
}


///add action buttons 直接block copy,让就算出了作用域也能正常执行到
+ (void)xg_addActionButtonWithTitle:(NSString *)title index:(NSInteger)buttonIndex style:(UIAlertActionStyle)style tapBlock:(XGOAActionSheetBlock)tapBlcok alert:(UIAlertController *)alert {
    if (!title.length) {
        return;
    }

    UIAlertAction* action = [UIAlertAction actionWithTitle:title style:style
                                                          handler:^(UIAlertAction * action) {
                                                              if (tapBlcok) {
                                                                  tapBlcok(buttonIndex);
                                                              }
                                                          }];

    [alert addAction:action];
}

+ (void)xg_showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                     currentVC:(id)currentVC
             cancelButtonTitle:(NSString *)cancelButtonTitle
            comfirmButtonTitle:(NSString *)confirmButtonTitle
                 buttonHandler:(void (^)(int))handler
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             if (handler) {
                                                                 handler(0);
                                                             };
                                                         }];
    [alertVC addAction:cancelAction];
    
    if (confirmButtonTitle) {
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  if (handler) {
                                                                      handler(1);
                                                                  }
                                                              }];
        [alertVC addAction:confirmAction];
    }
    
    [currentVC presentViewController:alertVC animated:YES completion:nil];
}


@end
