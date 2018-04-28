//
//  ViewController.m
//  XGAddressManagement
//
//  Created by xiaohui on 2018/4/27.
//  Copyright © 2018年 XIAOHUI. All rights reserved.
//

#import "ViewController.h"
#import "TXSJMapSelectLocationVC.h"
#import "XGMapSelectLocationVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(150, 200, 100, 30);
    [button setTitle:@"地址管理" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)showAddress {
//    TXSJMapSelectLocationVC *vc = [[TXSJMapSelectLocationVC alloc] init];
    XGMapSelectLocationVC *vc = [[XGMapSelectLocationVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
