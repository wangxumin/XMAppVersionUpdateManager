//
//  ViewController.m
//  XMAppVersionUpdateManager
//
//  Created by 王续敏 on 16/12/13.
//  Copyright © 2016年 wangxumin. All rights reserved.
//

#import "ViewController.h"
#import "XMAppVersionUpdateManager.h"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)checkVersionAction:(UIButton *)sender {
    //检查版本
    [XMAppVersionUpdateManager checkAppVersion];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor yellowColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
