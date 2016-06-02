//
//  ICECustomAlertView.m
//  ICEAlertView
//
//  Created by WLY on 16/6/1.
//  Copyright © 2016年 ICE. All rights reserved.
//


#import "ICECustomAlertView.h"
#import "UIButton+ICEBlock.h"


const static NSInteger ICEBtn_Tag = 100;
const static CGFloat ICE_Spacing = 10;
const static CGFloat ICEButton_H = 35;


#pragma mark - iOS 设备类型
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define ICESCREEN_W  CGRectGetWidth([UIScreen mainScreen].bounds) //屏幕宽度
#define ICESCREEN_H  CGRectGetHeight([UIScreen mainScreen].bounds) //屏幕高度
#define ICEAlertView_H MAX(ICESCREEN_H, ICESCREEN_W) / 4 //最大高度
#define ICEAlertView_W MIN(ICESCREEN_W, ICESCREEN_H) / (IS_IPAD ? 3 : 1.5) //宽度
#define ICEContent_W   (ICEAlertView_W - 2 * ICE_Spacing) // 内容区域宽度



/**
 *  计算文本高度
 */
CGFloat getStringHeight(NSString *string, UIFont *font) {
    ;
    
    return [string boundingRectWithSize:CGSizeMake(ICEAlertView_W, ICEAlertView_H / 3) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.height;
}


@interface ICECustomAlertView ()
/**
 *  容器视图
 */
@property (nonatomic, retain) UIView *containerView;
/**
 *  背景视图
 */
@property (nonatomic, strong) UIView *backgroundView;
/**
 *  回调
 */
@property (nonatomic, copy) ICEAlertViewCompletionBlock completion;

//要推出一个视图1. 创建一个要推出的视图,并加载到指定位置.
//使用动画推出要显示的视图
//使用动画隐藏已经显示的视图
//屏幕旋转处理

@end

@implementation ICECustomAlertView


/**
 *  使用自定义视图 基础类方法
 */
+ (void)alertViewWithCustomView:(UIView *)customView{

    ICECustomAlertView *alertView = [[ICECustomAlertView alloc] init];
    
    [alertView p_loadAlertView];
    customView.frame = alertView.containerView.bounds;
    [alertView.containerView addSubview:customView];
    [alertView p_showWithAnimation];

}


/**
 *  加载视图
 */
- (void)p_loadAlertView{

    //获取背景视图
    self.backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
    [topWindow addSubview:self.backgroundView];
    
    //加载内容视图
    self.containerView =[[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = ICE_Spacing / 2;
    self.containerView.bounds = CGRectMake(0, 0, ICEAlertView_W, ICEAlertView_H);
    self.containerView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 2, CGRectGetHeight([UIScreen mainScreen].bounds) / 2);
    
    [self.backgroundView addSubview:self.containerView];
}


/**
 *  显示
 */
- (void)p_showWithAnimation{

    self.containerView.layer.opacity = 0.5f;
    self.containerView.layer.transform = CATransform3DMakeScale(0.0f, 0.0f, 1.0);
    [UIView animateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionNone animations:^{
        self.containerView.layer.opacity = 1.0f;
        self.containerView.layer.transform = CATransform3DMakeScale(1.00, 1.00, 1);
    } completion:NULL];
    
}


/**
 *  隐藏
 */
- (void)p_dismissWithAnimation{

    CATransform3D currentTransform = self.containerView.layer.transform;
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            self.backgroundView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
            self.containerView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
            self.containerView.layer.opacity = 0.0f;
    }
    completion:^(BOOL finished) {
                         
        for (UIView *subView in self.backgroundView.subviews) {
            [subView removeFromSuperview];
        }
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;
                     }
     ];


}




/**
 *  在指定位置添加一个layer水平直线
 *
 *  @param postion y
 */
- (void)p_addLevelLine:(CGPoint)postion{

    CALayer *partLine = [CALayer layer];
    partLine.backgroundColor = [[UIColor lightGrayColor] CGColor];
    partLine.bounds = CGRectMake(0, 0, ICEAlertView_W, 0.6);
    partLine.opacity = 0.8;
    partLine.position = postion;
    [self.containerView.layer addSublayer:partLine];
}

/**
 *  添加一条垂直方向的直线
 */
- (void)p_addVerticalLine:(CGPoint)postion{

    CALayer *partLine = [CALayer layer];
    partLine.backgroundColor = [[UIColor lightGrayColor] CGColor];
    partLine.bounds = CGRectMake(0, 0, 0.6, ICEButton_H + ICE_Spacing);
    partLine.opacity = 0.8;
    partLine.position = postion;
    [self.containerView.layer addSublayer:partLine];
}

/**
 *  选中操作
 */
- (void)p_handelAction:(UIButton *)button{
    
    NSInteger index = button.tag - ICEBtn_Tag;
    [self p_dismissWithAnimation];
    if (self.completion) {
        self.completion(index);
    }
}


/**
 *  配置按钮
 *
 *  @param buttonTitles 按钮数组
 *  @param y            按钮的起始y值
 */
- (void)p_initConfigerButtons:(NSArray *)buttontitles withY:(CGFloat)y{

    UIColor *color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15];
    
    if (buttontitles && buttontitles.count) {
        NSInteger count = buttontitles.count;
        if (count == 1) {
            UIButton *cancleBtn = [self p_button:buttontitles.firstObject];
            cancleBtn.tag = ICEBtn_Tag;
            cancleBtn.bounds = CGRectMake(0, 0, ICEAlertView_W, ICEButton_H + ICE_Spacing);
            cancleBtn.center = CGPointMake(ICEAlertView_W / 2, (y + ICEButton_H / 2 + ICE_Spacing / 2));
            [cancleBtn setBackgroundImage:[self imageWithColor:color size:cancleBtn.bounds.size] forState:UIControlStateHighlighted];
            [self p_addCorner:cancleBtn byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
            [self.containerView addSubview:cancleBtn];
        }
        if (count > 1) {
            UIButton *cancleBtn = [self p_button:buttontitles[0]];
            cancleBtn.tag = ICEBtn_Tag;
            cancleBtn.frame = CGRectMake(0, y, ICEAlertView_W / 2, ICEButton_H + ICE_Spacing);
            [self p_addCorner:cancleBtn byRoundingCorners:UIRectCornerBottomLeft];
            [cancleBtn setBackgroundImage:[self imageWithColor:color size:cancleBtn.bounds.size] forState:UIControlStateHighlighted];
            [self.containerView addSubview:cancleBtn];

            
            
            UIButton *ensureBtn = [self p_button:buttontitles[1]];
            ensureBtn.tag = ICEBtn_Tag + 1;
            ensureBtn.frame = CGRectMake(ICEAlertView_W / 2, y, ICEAlertView_W / 2, ICEButton_H + ICE_Spacing);
            [ensureBtn setBackgroundImage:[self imageWithColor:color size:ensureBtn.bounds.size] forState:UIControlStateHighlighted];
            [self p_addCorner:cancleBtn byRoundingCorners: UIRectCornerBottomRight];

            [self.containerView addSubview:ensureBtn];
            
            //分割线
            [self p_addVerticalLine:CGPointMake(ICEAlertView_W / 2,  y + ICEButton_H / 2 + ICE_Spacing / 2)];
        }
        
        
    }else{
        
        UIButton *cancleBtn = [self p_button:@"确定"];
        cancleBtn.tag = ICEBtn_Tag;
        cancleBtn.bounds = CGRectMake(0, 0, ICEAlertView_W, ICEButton_H + ICE_Spacing);
        cancleBtn.center = CGPointMake(ICEAlertView_W / 2, (y + ICEButton_H / 2 + ICE_Spacing / 2));
        [cancleBtn setBackgroundImage:[self imageWithColor:color size:cancleBtn.bounds.size] forState:UIControlStateHighlighted];
        [self p_addCorner:cancleBtn byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];

        [self.containerView addSubview:cancleBtn];
    }
    
}


/**
 *  按钮单元
 */
- (UIButton *)p_button:(NSString *)title{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.backgroundColor = [UIColor clearColor];
    button.adjustsImageWhenHighlighted = NO;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *button) {
        [self p_handelAction:button];
    }];
    return button;
}

/**
 通过颜色设置图片
 
 @param color  The color.
 */
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  加圆角
 *
 *  @param view   指定视图
 *  @param corner 指定位置
 */
- (void)p_addCorner:(UIView *)view byRoundingCorners:(UIRectCorner)corner{

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayre = [[CAShapeLayer alloc] init];
    maskLayre.path = maskPath.CGPath;
    view.layer.mask = maskLayre;

}

////////////////////////////////////////////
#pragma mark - 标题类


+ (void)alertViewWithTitle:(NSString *)title withMessage:(NSString *)message withButtonTitles:(NSArray *)buttontitles completion:(ICEAlertViewCompletionBlock)completion{

     __strong ICECustomAlertView *alertView = [[ICECustomAlertView alloc] init];
    if (alertView) {
        
        [alertView p_loadAlertView];
        __block CGFloat y = ICE_Spacing;
        if (title && title.length > 0) {
            UILabel *titleLable = [alertView p_titleLabel:title];
            CGFloat title_h =  getStringHeight(title, titleLable.font);
            titleLable.frame = CGRectMake(ICE_Spacing, y, ICEContent_W, title_h);
            [alertView.containerView addSubview:titleLable];
            y += title_h;
        }else{
            y += ICE_Spacing;
        }
        
        if (message && message.length > 0) {
            y += ICE_Spacing;
            UILabel *titleLable = [alertView p_titleLabel:message];
            titleLable.font = [UIFont systemFontOfSize:12];
            titleLable.textColor = [UIColor lightGrayColor];
            CGFloat title_h =  getStringHeight(message, titleLable.font);
            titleLable.frame = CGRectMake(ICE_Spacing, y, ICEContent_W, title_h);
            [alertView.containerView addSubview:titleLable];
            y += title_h;
            y += ICE_Spacing;

        }else if(!title){
            y += ICE_Spacing;
        }
        
        y += ICE_Spacing ;

        [alertView p_addLevelLine:CGPointMake(ICEAlertView_W / 2, y)];
        
        
        CGRect bounds = alertView.containerView.bounds;
        bounds.size.height = y + ICEButton_H +  ICE_Spacing;
        alertView.containerView.bounds = bounds;
        alertView.containerView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 2, CGRectGetHeight([UIScreen mainScreen].bounds) / 2);
        

        [alertView p_initConfigerButtons:buttontitles withY:y];

        alertView.completion = completion;

        [alertView p_showWithAnimation];
    }
    
    
}


/**
 *  标题单元
 */
- (UILabel *)p_titleLabel:(NSString *)title{

    UILabel *titleLable= [[UILabel alloc] init];
    titleLable.text = title;
    titleLable.numberOfLines = 0;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:14];

    return titleLable;
}


////////////////////////////////////////////
#pragma mark - 自定义提示内容
+ (void)alertViewWithCustomView:(UIView *)customView withButtonTitles:(NSArray *)buttontitles completion:(ICEAlertViewCompletionBlock)completion{

    
    ICECustomAlertView *alertView = [[ICECustomAlertView alloc] init];
    if (alertView) {
        [alertView p_loadAlertView];
        
        CGFloat custom_w = MIN(customView.bounds.size.width, ICEContent_W);
        CGFloat custom_h = MIN(customView.bounds.size.height, ICEAlertView_H);
        customView.bounds = CGRectMake(0, 0, custom_w, custom_h);
        customView.center = CGPointMake(ICEAlertView_W / 2, ICE_Spacing + custom_h / 2);
        [alertView.containerView addSubview:customView];
        CGFloat y = ICE_Spacing * 2 + customView.bounds.size.height;

        //分割线
        [alertView p_addLevelLine:CGPointMake(ICEAlertView_W / 2, y)];

        //按钮
        [alertView p_initConfigerButtons:buttontitles withY:y];
        
        alertView.completion = completion;
        
        [alertView p_showWithAnimation];

    }
}


@end
