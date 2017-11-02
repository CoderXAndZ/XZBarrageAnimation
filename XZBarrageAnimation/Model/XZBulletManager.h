//
//  XZBulletManager.h
//  XZProject
//
//  Created by admin on 16/10/26.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XZBulletView;
@interface XZBulletManager : NSObject
/** 弹幕开始执行 */
- (void)start;

/** 弹幕停止执行 */
- (void)stop;

// 到controller的回调
@property (nonatomic, copy) void(^generateViewBlock)(XZBulletView *);
@end
