//
//  UIViewController+HUD.m
//  TBBluetoothSDK
//
//  Created by Topband on 2018/11/20.
//  Copyright © 2018年 深圳拓邦股份有限公司. All rights reserved.
//

#import "UIViewController+HUD.h"
#import <objc/runtime.h>

@implementation UIViewController (HUD)


- (void)setHUD:(MBProgressHUD *)HUD {
    
    objc_setAssociatedObject(self, @selector(setHUD:), HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)HUD {
    
    return objc_getAssociatedObject(self, @selector(setHUD:));
}

- (MBProgressHUD *)showHUDLoading {
    
    return [self showHUDLoadingWithText:nil inView:nil];
}

- (MBProgressHUD *)showHUDLoadingInView:(UIView *)inView {
    
    return [self showHUDLoadingWithText:nil inView:inView];
}

- (MBProgressHUD *)showHUDLoadingWithText:(NSString *)text {
    
    return [self showHUDLoadingWithText:text inView:nil];
}

- (MBProgressHUD *)showHUDLoadingWithText:(NSString *)text inView:(UIView *)inView {
    
    if (self.HUD) {
        [self.HUD hideAnimated:YES];
    }
    
    if (!inView) {
        inView = self.view;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor clearColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    hud.bezelView.layer.cornerRadius = 4;
    hud.margin = 15;
    
    self.HUD = hud;
    if (text) {
        hud.label.text = text;
        hud.label.font = [UIFont systemFontOfSize:16];
    }
    
    return hud;
}

- (MBProgressHUD *)showHUDWithText:(NSString *)text {
    
    return [self showHUDWithText:text duration:-1 inView:nil];
}

- (MBProgressHUD *)showHUDWithText:(NSString *)text inView:(UIView *)inView {
    
    return [self showHUDWithText:text duration:-1 inView:inView];
}

- (MBProgressHUD *)showHUDWithText:(NSString *)text duration:(NSTimeInterval)duration {
    
    return [self showHUDWithText:text duration:duration inView:nil];
}

- (MBProgressHUD *)showHUDWithText:(NSString *)text duration:(NSTimeInterval)duration inView:(UIView *)inView {
    
    if (text.length<=0) {
        return nil;
    }
    
    if (self.HUD) {
        [self.HUD hideAnimated:YES];
    }
    
    if (!inView) {
        inView = self.view;
    }
    if (duration <= 0) {
        duration = kMBProgressHUDDuration;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor clearColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    hud.bezelView.layer.cornerRadius = 4;
    hud.margin = 15;
    [hud hideAnimated:YES afterDelay:duration];
    self.HUD = hud;
    
    return hud;
}

- (void)hideHUD:(BOOL)animated {
    
    [self.HUD hideAnimated:animated];
}



@end
