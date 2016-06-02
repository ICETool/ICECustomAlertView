//
//  ICECustomAlertView.h
//  ICEAlertView
//
//  Created by WLY on 16/6/1.
//  Copyright © 2016年 ICE. All rights reserved.
//
/**
 *  暂不支持按钮数大于2
 *  暂不支持屏幕旋转
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ICEAlertViewStyle) {
    ICEAlertViewStyleCustom = 0,//自定义提示内容
    ICEAlertViewStyleDefault , //显示两个标题 类似系统提示
    ICEAlertViewStyleInputView,//输入框类型
    ICEAlertViewStyleTitle  = ICEAlertViewStyleDefault,
};

typedef void(^ICEAlertViewCompletionBlock) (NSInteger index);

@interface ICECustomAlertView : NSObject

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint center;


/**
 *  自定义提示内容的提示视图
 *
 *  @param customView   提示内容视图
 *  @param buttontitles 按钮的标题
 *  return instancetype 仅返回一个弹出界面, 可承载自定义视图
 */
+ (void)alertViewWithCustomView:(nonnull UIView *)customView;

/**
 *  自定义提示内容的提示视图
 *
 *  @param customView   提示内容视图
 *  @param buttontitles 按钮的标题
 */
+ (void)alertViewWithCustomView:(nonnull UIView *)customView
                               withButtonTitles:(nullable NSArray  *)buttontitles
                                     completion:(nullable ICEAlertViewCompletionBlock)completion;


/**
 *  标题类提示框
 *
 *  @param title        标题
 *  @param message      提示内容
 *  @param buttontitles 按钮标题
 *  @param completion   回调
 */
+ (void)alertViewWithTitle:(nullable NSString *)title
                          withMessage:(nullable NSString *)message
                     withButtonTitles:(nullable NSArray  *)buttontitles
                           completion:(nullable ICEAlertViewCompletionBlock)completion;



/**
 *  推出视图
 */
- (void)showAlertView;
/**
 *  撤销警告视图
 */
- (void)dismissAlertView;

@end
