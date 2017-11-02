//
//  XZBulletViewController.m
//  XZProject
//
//  Created by admin on 16/10/26.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "XZBulletViewController.h"
#import "XZBulletView.h"
#import "XZBulletManager.h"

@interface XZBulletViewController ()
/**  */
@property (nonatomic, strong) XZBulletManager *manager;

@end

@implementation XZBulletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    self.manager = [[XZBulletManager alloc] init];
    __weak typeof(self) weakSelf = self;
    self.manager.generateViewBlock = ^(XZBulletView *view){
        [weakSelf addBulletView:view];
    };
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 40);
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:@"start" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didClickStartButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(250, 100, 100, 40);
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:@"stop" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didClickStopButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didClickStartButton {
    [self.manager start];
}

- (void)didClickStopButton {
    [self.manager stop];
}

// 添加弹幕到当前view
- (void)addBulletView:(XZBulletView *)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(width, 300 + view.trajectory * 50, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    [view startAnimation];
}

@end
