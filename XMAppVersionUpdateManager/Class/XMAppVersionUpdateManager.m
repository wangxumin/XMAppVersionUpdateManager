//
//  XMAppVersionUpdateManager.m
//  XMAppVersionUpdateManager
//
//  Created by 王续敏 on 16/12/13.
//  Copyright © 2016年 wangxumin. All rights reserved.
//

#import "XMAppVersionUpdateManager.h"
#import <UIKit/UIKit.h>
@implementation XMAppVersionUpdateManager
+ (void)checkAppVersion{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @try {
            
        if ([APPID isEqual: @""] || APPID.length == 0) {
            @throw [NSException exceptionWithName:@"HasNoAPPID" reason:@"没有设置APPID" userInfo:nil];
            return ;
        }
        NSURL *appStoreUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@", APPID]];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:appStoreUrl];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",appInfoDic);
                if ([appInfoDic[@"results"] count] == 0) {
                    NSLog(@"暂无版本信息");
                    return ;
                }
                NSDictionary *messageDic = appInfoDic[@"results"][0];
                //版本
                NSString *appVersionStr = messageDic[@"version"];
                //更新内容
                NSString *releaseNotes = messageDic[@"releaseNotes"];
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"newVersion"] == nil ||[[NSUserDefaults standardUserDefaults] objectForKey:@"newVersion"] != appVersionStr) {
                    [[NSUserDefaults standardUserDefaults] setObject:appVersionStr forKey:@"newVersion"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AppUpdate"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                if (appVersionStr == nil || [self getCurrentVersion] == appVersionStr || [[NSUserDefaults standardUserDefaults] boolForKey:@"AppUpdate"]){
                    return;
                }
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"有新版本更新\n%@",appVersionStr] message:releaseNotes preferredStyle:UIAlertControllerStyleAlert];
                UIView *messageParentView = [self getParentViewOfTitleAndMessageFromView:alertVC.view];
                if (messageParentView && messageParentView.subviews.count > 1) {
                    UILabel *messageLb = messageParentView.subviews[1];
                    messageLb.textAlignment = NSTextAlignmentLeft;
                }
                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"稍后更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                NSString *alertVCTitle = [NSString stringWithFormat:@"有新版本更新\n%@",appVersionStr];
                NSMutableAttributedString *alertControllerStr = [self changeStrWith:alertVCTitle range:NSMakeRange(6, alertVCTitle.length - 6) strColor:[UIColor lightGrayColor] strFont:[UIFont systemFontOfSize:16]];
                //修改提示框标题字体
                [alertVC setValue:alertControllerStr forKey:@"attributedTitle"];
                
                UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *appStroeStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?l=en&mt=8", APPID];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStroeStr]];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AppUpdate"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }];
                [alertVC addAction:cancleAction];
                [alertVC addAction:conformAction];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIViewController *currentVc = [self activityViewController];
                    [currentVc presentViewController:alertVC animated:YES completion:nil];
                });
            }
        }];
        [task resume];
            
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        } @finally {
            
        }
    });
}

/**
 递归算法
 */
+ (UIView *)getParentViewOfTitleAndMessageFromView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            return view;
        }else{
            UIView *resultV = [self getParentViewOfTitleAndMessageFromView:subView];
            if (resultV) return resultV;
        }
    }
    return nil;
}


/**
 富文本编辑

 @param string 要编辑的字符串
 @param range 需要改变的字符串range
 @param color 字体颜色
 @param font 字体大小
 @return 修改后的字符串
 */
+ (NSMutableAttributedString *)changeStrWith:(NSString *)string
                                       range:(NSRange)range
                                    strColor:(UIColor *)color
                                     strFont:(UIFont *)font
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attributedString addAttribute:NSFontAttributeName value:font range:range];
    return attributedString;
}

/**
 获取当前系统版本
 */
+ (NSString *)getCurrentVersion{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

/**
 获取当前显示的控制器
 
 @return 当前控制器
 */
+ (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}


@end
