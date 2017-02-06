//
//  SKStoreProductViewController+Addtion.m
//  XMAppVersionUpdateManager
//
//  Created by 王续敏 on 16/12/27.
//  Copyright © 2016年 wangxumin. All rights reserved.
//

#import "SKStoreProductViewController+Addtion.h"
#import <objc/runtime.h>
@implementation SKStoreProductViewController (Addtion)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = NSSelectorFromString(@"_didFinish"); //动态获取当前控制器点击取消时候的方法，以便dismiss自己
        SEL swizzledSelector = @selector(vc_didFinish);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else{
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}
- (void)vc_didFinish{
    [self vc_didFinish];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AppUpdate"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
