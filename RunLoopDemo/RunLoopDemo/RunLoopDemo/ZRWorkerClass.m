//
//  ZRWorkerClass.m
//  RunLoopDemo
//
//  Created by pingqian on 17/6/20.
//  Copyright © 2017年 O2O. All rights reserved.
//

#import "ZRWorkerClass.h"

@implementation ZRWorkerClass

+ (void)LaunchThreadWithPort:(id)inData
{
    @autoreleasepool {
        
        // 设置本线程与主线程的连接
        NSPort* distantPort = (NSPort*)inData;
        
        ZRWorkerClass*  workerObj = [[self alloc] init];
        [workerObj sendCheckinMessage:distantPort];
        
        // 让 run loop 处理这些逻辑
        do
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                     beforeDate:[NSDate distantFuture]];
        }
        while (![workerObj shouldExit]);
        
    }
}

// Worker thread check-in method
- (void)sendCheckinMessage:(NSPort*)outPort
{
    // 保留（retain）并保存远端的 port 以备后用
    [self setRemotePort:outPort];
    
    // 创建和配置工作线程的端口（ps：当前线程端口）
    NSPort* myPort = [NSMachPort port];
    [myPort setDelegate:self];
    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
    
    // 创建 check-in 登记信息
    NSPortMessage* messageObj = [[NSPortMessage alloc] initWithSendPort:outPort
                                                            receivePort:myPort components:nil];
    
    if (messageObj)
    {
        // 完成配置信息 并 立即发送出去
        [messageObj setMsgId:setMsgid:kCheckinMessage];
        [messageObj sendBeforeDate:[NSDate date]];
    }
}

- (void)setRemotePort:(NSPort *)outPort{
    
}

@end
