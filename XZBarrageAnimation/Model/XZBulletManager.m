//
//  XZBulletManager.m
//  XZProject
//
//  Created by admin on 16/10/26.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "XZBulletManager.h"
#import "XZBulletView.h"

@interface XZBulletManager ()
/** 弹幕的数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 弹幕使用过程中的数组变量 */
@property (nonatomic, strong) NSMutableArray *bulletComments;
/** 存储弹幕view的数组变量 */
@property (nonatomic, strong) NSMutableArray *bulletViews;
/** 停止 */
@property BOOL bStopAnimation;
@end

@implementation XZBulletManager

- (instancetype)init {
    if (self = [super init]) {
        self.bStopAnimation = YES;
    }
    return self;
}

- (void)start {
    if (!self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.dataSource];
    [self initBulletComment];
}

- (void)stop {
    if (self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = YES;
    // 遍历bulletViews数组
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XZBulletView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    // 删除所有对象
    [self.bulletViews removeAllObjects];
}

/** 初始化弹幕，随机分配弹幕轨迹 */
- (void)initBulletComment {
    // 弹道数组
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (int i = 0; i < 3; i++) { // < trajectorys.count
        if (self.bulletComments.count > 0) {
            // 通过随机数获取弹幕的轨迹
            NSInteger index = arc4random()%trajectorys.count;
            int trajectory = [[trajectorys objectAtIndex:index] intValue];
            [trajectorys removeObjectAtIndex:index];
            // 从弹幕数组中逐一取出弹幕数据
            NSString *comment = [self.bulletComments firstObject];
            [self.bulletComments removeObjectAtIndex:0];
            
            // 创建弹幕view
            [self createBulletView:comment trajectory:trajectory];
        }
    }
}

// 创建弹幕根据弹幕内容和弹幕轨迹
- (void)createBulletView:(NSString *)comment trajectory:(int)trajectory {
    if (self.bStopAnimation) { // 如果停止动画，直接return
        return;
    }
    // 初始化XZBulletView
    XZBulletView *view = [[XZBulletView alloc] initWithComment:comment];
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    
    __weak typeof(view) weakView = view;
    __weak typeof(self) weakSelf = self;
    view.moveStatusBlock = ^(MoveStatus status){
        if (self.bStopAnimation) { // 如果停止动画，直接return
            return;
        }
        switch (status) {
            case Start:
            {
                // 弹幕开始进入屏幕，将view加入到弹幕管理的变量中bulletViews
                [weakSelf.bulletViews addObject:weakView];
                break;
            }
            case Enter:
            {
                // 弹幕完全进入屏幕，判断是否还有其他内容，如果有则在该弹幕轨迹中创建一个弹幕
                NSString *commentNext = [weakSelf nextComment];
                if (commentNext) { // 创建新的弹幕
                    [weakSelf createBulletView:commentNext trajectory:trajectory];
                }
                 break;
            }
            case End:
            {
                // 弹幕完全飞出屏幕后，从bulletViews中删除，释放资源
                if ([weakSelf.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.bulletViews removeObject:weakView];
                }
                // 循环
                if (weakSelf.bulletViews.count == 0) {
                    // 说明屏幕上已经没有弹幕，开始循环滚动
                    weakSelf.bStopAnimation = YES;
                    [weakSelf start];
                }
                break;
            }
            default:
                break;
        }
        
//        // 移出屏幕后销毁弹幕并释放资源
//        [weakView stopAnimation];
//        [weakSelf.bulletViews removeObject:weakView];
    };
    
    // 回调到controller
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

// 从数据源中取下一条弹幕
- (NSString *)nextComment {
    if (self.bulletComments.count == 0) {
        return nil;
    }
    NSString *comment = [self.bulletComments firstObject];
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comment;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:@[
                                                       @"弹幕1~~",
                                                       @"弹幕2~~~~",
                                                       @"弹幕3~~~~~~~~~~~~~~",
                                                       @"弹幕4~",
                                                       @"弹幕5~~~",
                                                       @"弹幕6~~~~~",
                                                       @"弹幕7~~~~~~~~",
                                                       @"弹幕89999"
                                                       ]];
    }
    return _dataSource;
}

- (NSMutableArray *)bulletViews {
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

- (NSMutableArray *)bulletComments {
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}

@end
