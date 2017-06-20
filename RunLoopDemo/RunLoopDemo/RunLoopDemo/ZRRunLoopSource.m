//
//  ZRRunLoopSource.m
//  RunLoopDemo
//
//  Created by pingqian on 17/6/19.
//  Copyright © 2017年 O2O. All rights reserved.
//

#import "ZRRunLoopSource.h"
#import "ZRAppDelegate.h"

void RunLoopSourceScheduleRoutine(void *info, CFRunLoopRef r1, CFStringRef mode){
    ZRRunLoopSource *obj = (__bridge ZRRunLoopSource *)info;
    // 这里的 Appdelegate 是主线程的代理
    
    ZRAppDelegate *del = [ZRAppDelegate sharedAppDelegate];
    
    // 上下文对象中持有source自己
    ZRRunLoopContext *theContext = [[ZRRunLoopContext alloc] initWithSource:obj andLoop:r1];
    // 通过代理去注册 Source 自己
    [del performSelectorOnMainThread:@selector(registerSource:) withObject:theContext waitUntilDone:NO];
    
}

void RunLoopSourcePerformRoutine (void *info)
{
    ZRRunLoopSource*  obj = (__bridge ZRRunLoopSource*)info;
    [obj sourceFired];
}

void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    ZRRunLoopSource* obj = (__bridge ZRRunLoopSource*)info;
    ZRAppDelegate* del = [ZRAppDelegate sharedAppDelegate];
    ZRRunLoopContext* theContext = [[ZRRunLoopContext alloc] initWithSource:obj andLoop:rl];
    
    [del performSelectorOnMainThread:@selector(removeSource:)
                          withObject:theContext waitUntilDone:YES];
}

@implementation ZRRunLoopSource

- (id)init {
    // 创建上下文容器，其中会连接自己的 info，retain info release info，还会关联三个例行程序。
    CFRunLoopSourceContext context = {0, (__bridge void *)(self), NULL, NULL, NULL ,NULL, NULL, &RunLoopSourceScheduleRoutine, RunLoopSourceCancelRoutine, RunLoopSourcePerformRoutine};
    /** 通过索引，上下文，和CFAllocator创建source */
    runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
    commands = [[NSMutableArray alloc] init];
    return  self;
}

- (void)addToCurrentRunLoop{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(runLoop, runLoopSource, kCFRunLoopDefaultMode);
}

- (void)addCommand:(NSInteger)command withData:(id)data{
    //  TODO
}

- (void)fireAllCommandsOnRunLoop:(CFRunLoopSourceRef)runloop{
    //  TODO
}

- (void)fireCommandsOnRunLoop:(CFRunLoopRef)runloop
{
    CFRunLoopSourceSignal(runLoopSource);
    CFRunLoopWakeUp(runloop);
}

@end

@implementation ZRRunLoopContext

- (id)initWithSource:(ZRRunLoopSource *)src andLoop:(CFRunLoopRef)loop{
    if (self = [super init]) {
        runloop = loop;
        source = src;
    }
    return self;
}

- (CFRunLoopRef)runloop{
    return runloop;
}

- (ZRRunLoopSource *)source{
    return source;
}

@end
