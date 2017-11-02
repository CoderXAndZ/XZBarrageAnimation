//
//  XZBulletView.m
//  XZProject
//
//  Created by admin on 16/10/26.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "XZBulletView.h"

// 间距
#define kXZPadding 10
// 图像的宽高
#define kXZPhotoHeight 30

@interface XZBulletView ()
/** 弹幕label */
@property (nonatomic, strong) UILabel *lbComment;
/** 弹幕图片 */
@property (nonatomic, strong) UIImageView *photoIgv;
@end

@implementation XZBulletView

/** 初始化弹幕 */
- (instancetype)initWithComment:(NSString *)comment{
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = 15;
        
        // 计算弹幕的实际宽度
        NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat width = [comment sizeWithAttributes:attrs].width;
        self.bounds = CGRectMake(0, 0, width + 2 * kXZPadding + kXZPhotoHeight, 30);
        self.lbComment.text = comment;
        self.lbComment.frame = CGRectMake(kXZPadding + kXZPhotoHeight, 0, width, 30);
        
        self.photoIgv.frame = CGRectMake(-kXZPadding, -kXZPadding, kXZPhotoHeight + kXZPadding, kXZPhotoHeight + kXZPadding);
        self.photoIgv.layer.cornerRadius = (kXZPhotoHeight + kXZPadding) / 2;
        self.photoIgv.layer.borderColor = [UIColor orangeColor].CGColor;
        self.photoIgv.layer.borderWidth = 1;
        self.photoIgv.image = [UIImage imageNamed:@"header_cry_icon"];
    }
    return self;
}

/** 开始动画 */
- (void)startAnimation {
    // 根据弹幕长度执行动画效果
    // 根据 v = s/t,时间相同情况下，距离越长，速度就越快；
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4.0f;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    // 弹幕开始
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }
    
    // t = s / v;
    CGFloat speed = wholeWidth / duration;
    CGFloat enterDurartion = CGRectGetWidth(self.bounds) / speed;
    
    // 弹幕的自动追加
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDurartion + 2];
//    // 取消方法执行
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(enterDurartion * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (self.moveStatusBlock) {
//            self.moveStatusBlock(Enter);
//        }
//    });
    
    // 因为要改变frame的值，所以要加__block
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        // 改变x坐标
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        // 动画完成后，释放掉自己
        [self removeFromSuperview];
        // 回调：知道什么时候释放
        if (self.moveStatusBlock) {
            self.moveStatusBlock(End);
        }
    }];
}

// 进入屏幕
- (void)enterScreen {
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Enter);
    }
}

/** 结束动画 */
- (void)stopAnimation {
    // 取消方法执行
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

#pragma mark --- 懒加载即初始化
- (UILabel *)lbComment {
    if (!_lbComment) {
        _lbComment = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbComment.font = [UIFont systemFontOfSize:14];
        _lbComment.textColor = [UIColor whiteColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbComment];
    }
    return _lbComment;
}

- (UIImageView *)photoIgv {
    if (!_photoIgv) {
        _photoIgv = [UIImageView new];
        _photoIgv.clipsToBounds = YES;
        _photoIgv.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_photoIgv];
    }
    return _photoIgv;
}

@end
