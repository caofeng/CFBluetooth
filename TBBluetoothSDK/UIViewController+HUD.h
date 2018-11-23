//
//  UIViewController+HUD.h
//  TBBluetoothSDK
//
//  Created by Topband on 2018/11/20.
//  Copyright © 2018年 深圳拓邦股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

#define kMBProgressHUDDuration 1.9


@interface UIViewController (HUD)

- (void)setHUD:(MBProgressHUD *)HUD;
- (MBProgressHUD *)HUD;

- (MBProgressHUD *)showHUDLoading;
- (MBProgressHUD *)showHUDLoadingInView:(UIView *)inView;

- (MBProgressHUD *)showHUDLoadingWithText:(NSString *)text;
- (MBProgressHUD *)showHUDLoadingWithText:(NSString *)text inView:(UIView *)inView;

- (MBProgressHUD *)showHUDWithText:(NSString *)text;
- (MBProgressHUD *)showHUDWithText:(NSString *)text inView:(UIView *)inView;
- (MBProgressHUD *)showHUDWithText:(NSString *)text duration:(NSTimeInterval)duration;
- (MBProgressHUD *)showHUDWithText:(NSString *)text duration:(NSTimeInterval)duration inView:(UIView *)inView;

- (void)hideHUD:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
