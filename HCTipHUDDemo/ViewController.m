//
//  ViewController.m
//  HCTipHUDDemo
//
//  Created by Jentle on 16/9/1.
//  Copyright © 2016年 Jentle. All rights reserved.
//

#import "ViewController.h"
#import "HCTipHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//用法示例1：动画效果
    [HCTipHUD showInView:self.view withMessage:@"点击屏幕切换无动画效果"];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//用法示例2：无动画效果
    [HCTipHUD normalShowInView:self.view withMessage:@"弹框无动画效果"];
}

@end
