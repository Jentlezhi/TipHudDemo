//
//  HCTipHUD.h
//  HelperCar
//
//  Created by Jentle on 16/8/10.
//  Copyright © 2016年 allydata. All rights reserved.
//  文字弹窗提示，自动隐藏，取消动画请调用normalShow方法

#import <UIKit/UIKit.h>

@interface HCTipHUD : UILabel

/**
 *  显示tosat到视图
 */
+ (void)showInView:(UIView *)view withMessage:(NSString *)message;
/**
 *  显示tosat到keyWindow
 */
+ (void)showMessage:(NSString *)message;

/**
 *  显示tosat到视图，无动画效果
 */
+ (void)normalShowInView:(UIView *)view withMessage:(NSString *)message;
/**
 *  显示tosat到keyWindow，无动画效果
 */
+ (void)normalShowMessage:(NSString *)message;

@end
