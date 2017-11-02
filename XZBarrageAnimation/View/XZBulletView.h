//
//  XZBulletView.h
//  XZProject
//
//  Created by admin on 16/10/26.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MoveStatus) {
    Start,
    Enter,
    End
};
@interface XZBulletView : UIView
/** 弹道 */
@property (nonatomic, assign) int trajectory;
/** 弹幕状态的回调 */
@property (nonatomic, copy) void(^moveStatusBlock)(MoveStatus status);
/** 初始化弹幕 */
- (instancetype)initWithComment:(NSString *)comment;
/** 开始动画 */
- (void)startAnimation;
/** 结束动画 */
- (void)stopAnimation;

@end
