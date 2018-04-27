//
//  XGTCNavigationController.m
//  retail
//
//  Created by wangdf on 2017/9/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "XGTCNavigationController.h"
#import "Masonry.h"

@interface XGTCNavigationController ()

@end

@implementation XGTCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (@available(iOS 11.0, *)) {
        [self changeSubviewLayout:self.navigationBar];
    }
}

- (void)changeSubviewLayout:(UIView *)view {
    ///这样也有弊端，如果左右的顺序变了就尴尬了
    NSInteger index = 0;
    for (UIView *subview in [view subviews]) {
        NSLog(@"subview class = %@, super.class = %@", NSStringFromClass([subview class]), NSStringFromClass([subview.superview class]));
        if ([subview isMemberOfClass:NSClassFromString(@"_UIButtonBarStackView")]) {

            ///左右偏移一点，图片内部也有偏移,和ios10及以下的一样位置
            CGFloat margin = 8;
            ///重设置autolayout
            if (index == 0) {
                [subview mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(subview.superview).offset(margin);
                    make.top.bottom.equalTo(subview);
                }];
            }else {
                [subview mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(subview.superview).offset(-margin);
                    make.top.bottom.equalTo(subview);
                }];
            }

            index++;
        }else if ([subview.superview isMemberOfClass:NSClassFromString(@"_UITAMICAdaptorView")]) {
            ///不改约束时,每加一个barItem就会有一个adaptorView，但一改后，就没了这层view，item直接在stackView下面了，真TM蛋疼
            //这个要是不设置，第一次刷新的时候就只有图片宽度了
            [subview mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(subview.superview.mas_centerX);
                make.width.mas_equalTo(subview.bounds.size.width);
                //                make.height.equalTo(subview.superview.mas_height);
                make.height.mas_equalTo(44); //因parent会变，变写死个44高度，navBar的高度始终是44,变了也是_UIbackroundView
            }];
        }

        if ([subview subviews].count > 0) {
            [self changeSubviewLayout:subview];
        }
    }
}

@end
