//
//  ZRRunLoopSource.h
//  RunLoopDemo
//
//  Created by pingqian on 17/6/19.
//  Copyright © 2017年 O2O. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZRRunLoopSource : NSObject
{
    CFRunLoopSourceRef runLoopSource;
    NSMutableArray *commands;
}

- (id)init;

// 添加
- (void)addToCurrentRunLoop;

// 销毁
- (void)invalidate;


// 处理方法
- (void)sourceFired;


// 用来注册需要处理的命令的客户机接口
- (void)addCommand:(NSInteger)command withData:(id)data;
- (void)fireAllCommandsOnRunLoop:(CFRunLoopSourceRef)runloop;


// 这些是CFRunLoopRef 的回调函数
// 调度函数
void RunLoopSourceScheduleRoutine(void *info, CFRunLoopRef r1, CFStringRef mode);

// 处理函数
void RunLoopSourcePerformRoutine(void *info);

// 取消函数
void RunLoopSourceCancelRoutine(void *info, CFRunLoopRef rl, CFStringRef mode);

@end


// RunLoopContext 是一个 在注册 input source 时使用的容器对象
@interface ZRRunLoopContext : NSObject
{
    CFRunLoopRef runloop;
    ZRRunLoopSource *source;
}

/** 持有 runloop 和 source */
@property (readonly) CFRunLoopRef runloop;

@property (readonly) ZRRunLoopSource *source;

- (id)initWithSource:(ZRRunLoopSource *)src andLoop:(CFRunLoopRef)loop;

@end
