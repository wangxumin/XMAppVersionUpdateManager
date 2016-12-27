//
//  XMAppVersionUpdateManager.h
//  XMAppVersionUpdateManager
//
//  Created by 王续敏 on 16/12/13.
//  Copyright © 2016年 wangxumin. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSString *APPID = @"";

@interface XMAppVersionUpdateManager : NSObject

/**
 检查新版本
 */
+ (void)checkAppVersion;

@end
