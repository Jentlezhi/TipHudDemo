//
//  HCTipHUD.m
//  HelperCar
//
//  Created by Jentle on 16/8/10.
//  Copyright © 2016年 allydata. All rights reserved.
//

#import "HCTipHUD.h"

static CFTimeInterval const kDefaultForwardAnimationDuration = 0.5;
static CFTimeInterval const kDefaultBackwardAnimationDuration = 0.5;
static CFTimeInterval const kDefaultWaitAnimationDuration = 1.0;

static CGFloat const kDefaultDismissDuration = 1.5f;
static CGFloat const kDefalultTextInset = 10.0;

@interface HCTipHUD()

@property (assign, nonatomic) CFTimeInterval  forwardAnimationDuration;
@property (assign, nonatomic) CFTimeInterval  backwardAnimationDuration;
@property (assign, nonatomic) UIEdgeInsets    textInsets;
@property (assign, nonatomic) CGFloat         maxWidth;
@property (assign, nonatomic, getter=isSetAnimation) BOOL setAnimation;

@end

static HCTipHUD *tipHUD;

@implementation HCTipHUD

+ (instancetype)toastWithText:(NSString *)text{
    HCTipHUD *tipHud = [[HCTipHUD alloc] initWithText:text];
    
    return tipHud;
}

- (instancetype)initWithText:(NSString *)text{
    self = [self initWithFrame:CGRectZero];
    if(self)
    {
        self.text = text;
        [self sizeToFit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.forwardAnimationDuration = kDefaultForwardAnimationDuration;
        self.backwardAnimationDuration = kDefaultBackwardAnimationDuration;
        self.textInsets = UIEdgeInsetsMake(kDefalultTextInset, kDefalultTextInset, kDefalultTextInset, kDefalultTextInset);
        self.maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) - 20.0;
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentLeft;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:15];
    }
    
    return self;
}

/**
 *  展示方法
 */
- (void)showInView:(UIView *)view{
    if (self.isSetAnimation) {
        [self addAnimationGroup];
    }
    CGPoint point = view.center;
    self.center = point;
    [view addSubview:self];
}

/**
 *  添加动画
 */
- (void)addAnimationGroup{
    CABasicAnimation *forwardAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    forwardAnimation.duration = self.forwardAnimationDuration;
    forwardAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5f :1.7f :0.6f :0.85f];
    forwardAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    forwardAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    CABasicAnimation *backwardAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    backwardAnimation.duration = self.backwardAnimationDuration;
    backwardAnimation.beginTime = forwardAnimation.duration + kDefaultWaitAnimationDuration;
    backwardAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4f :0.15f :0.5f :-0.7f];
    backwardAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    backwardAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[forwardAnimation,backwardAnimation];
    animationGroup.duration = forwardAnimation.duration + backwardAnimation.duration + kDefaultWaitAnimationDuration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.delegate = self;
    animationGroup.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:animationGroup forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if(flag){
        [self removeFromSuperview];
    }
}
- (void)sizeToFit
{
    [super sizeToFit];
    
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(self.bounds) + self.textInsets.left + self.textInsets.right;
    frame.size.width = width > self.maxWidth? self.maxWidth : width;
    frame.size.height = CGRectGetHeight(self.bounds) + self.textInsets.top + self.textInsets.bottom;
    self.frame = frame;
}

- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textInsets)];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines{
    bounds.size = [self.text boundingRectWithSize:CGSizeMake(self.maxWidth - self.textInsets.left - self.textInsets.right,
                                                             CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    return bounds;
}

/**
 *  提示框公共方法
 *
 *  @param msg           提示文字信息
 *  @param view          父视图
 *  @param showAnimation 是否显示动画
 */
+ (void)showInView:(UIView *)view withMsg:(NSString *)msg  showAnimation:(BOOL)showAnimation{
    BOOL isAddSuperView = NO;
    for (UIView *item in view.subviews) {
        if ([item isKindOfClass:[HCTipHUD class]]) {
            isAddSuperView = YES;
        }
    }
    if (isAddSuperView) return;
    tipHUD = [[HCTipHUD alloc] initWithText:msg];
    tipHUD.setAnimation = showAnimation;
    [tipHUD showInView:view];
}

+ (void)showInView:(UIView *)view withMessage:(NSString *)message{
    [self showInView:view withMsg:message showAnimation:YES];
}


+ (void)showMessage:(NSString *)message {
    [self showInView:[UIApplication sharedApplication].keyWindow withMsg:message showAnimation:YES];
}


+ (void)normalShowInView:(UIView *)view withMessage:(NSString *)message {
    [self showInView:view withMsg:message showAnimation:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDefaultDismissDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tipHUD removeFromSuperview];
    });
}

+ (void)normalShowMessage:(NSString *)message{
    [self showInView:[UIApplication sharedApplication].keyWindow withMsg:message showAnimation:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDefaultDismissDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tipHUD removeFromSuperview];
    });
}

@end
