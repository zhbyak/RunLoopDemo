//
//  ViewController.m
//  RunLoopDemo
//
//  Created by pingqian on 17/6/17.
//  Copyright © 2017年 O2O. All rights reserved.
//

#import "ViewController.h"
#import "ZRWorkerClass.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    // http://yangchao0033.github.io/blog/2016/01/18/runloop-5/
    
    
    [self runLoopTest];
}

/*
 runloop 添加runloop observer。
 */
- (void)runLoopTest {
    //
    
    // 应用使用垃圾回收，所以不需要 自动释放池 autorelease pool
    NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
    // 创建一个 run loop observer 并且将他添加到当前 run loop 中去
    /*!
     *  @author 杨超, 16-01-13 15:01:45
     *  http://yangchao0033.github.io/blog/2016/01/06/runloopshen-du-tan-jiu/
     *
     *  @brief CFRunLoopObserverContext 用来配置 CFRunLoopObserver 对象行为的结构体
     typedef struct {
        CFIndex  version;
        void *   info;
        const void *(*retain)(const void *info);
        void (*release)(const void *info);
        CFStringRef  (*copyDescription)(const void *info);
     } CFRunLoopObserverContext;
     *
     *  @param version 结构体版本号，必须为0
     *  @param info 一个程序预定义的任意指针，可以再 run loop Observer 创建时为其关联。这个指针将被传到所有 context 多定义的所有回调中。
     *  @param retain 程序定义 info 指针的内存保留（retain）回调,可以为 NULL
     *  @param release 程序定义 info 指针的内存释放（release）回调，可以为 NULL
     *  @param copyDescription 程序定于 info 指针的 copy 描述回调，可以为 NULL
     *
     *  @since
     */
    CFRunLoopObserverContext context = {0 , (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &myRunLoopObserverCallBack, &context);
    
    if (observer) {
        CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
    
    // 创建并安排好 timer
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(doFireTimer) userInfo:nil repeats:YES];
    NSInteger loopCount = 10;
//    do {
//        // 3秒后运行 run loop 实际效果是每三秒进入一次当前 while 循环
//        [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
//        loopCount --;
//    } while (loopCount);
    
}

void myRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    NSLog(@"observer正在回调\n%@----%tu----%@", observer, activity, info);
}

- (void)doFireTimer {
    NSLog(@"计时器回调");
}



- (void)testCocoaNSTimer{
    NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
    
    // 创建并调度第一个 timer
    NSDate* futureDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
    NSTimer* myTimer = [[NSTimer alloc] initWithFireDate:futureDate
                                                interval:0.1
                                                  target:self
                                                selector:@selector(myDoFireTimer1:)
                                                userInfo:nil
                                                 repeats:YES];
    [myRunLoop addTimer:myTimer forMode:NSDefaultRunLoopMode];
    
    // 创建并调动第二个 timer
    [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:self
                                   selector:@selector(myDoFireTimer2:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)myDoFireTimer1:(NSObject *)obj{
    
}

- (void)myDoFireTimer2:(NSObject *)obj{
    
}

void myCFTimerCallback(){
    
}

- (void)testCFTimer{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopTimerContext context = {0, NULL, NULL, NULL, NULL};
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0.1, 0.3, 0, 0,
                                                   &myCFTimerCallback, &context);
    
    CFRunLoopAddTimer(runLoop, timer, kCFRunLoopCommonModes);
}

- (void)launchThread {
    NSPort *myPort = [NSMachPort port];
    if (myPort) {
        // 这个类处理即将过来的 port 信息
        [myPort setDelegate:self];
        // 将此端口作为 input source 安装到当前 run loop 中去
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
        // 开启工作子线程，让工作子线程去释放 port
        [NSThread detachNewThreadSelector:@selector(LaunchThreadWithPort:) toTarget:[ZRWorkerClass class] withObject:myPort];
    }
}

# define kCheckinMessage 100

// 处理工作线程的响应的代理方法
- (void)handlePortMessage:(NSPortMessage *)portMessage
{
    unsigned int message = [portMessage msgid];
    // 定义远程端口
    NSPort *distantPort = nil;
    if (message == kCheckinMessage) {
        // 获取工作线程的通信 port
        distantPort = [portMessage sendPort];
        
        // 引用计数+1 并 保存工作端口以备后用
        [self storeDistantPort:distantPort];
    } else {
        // 处理其他信息
    }
}

- (void)storeDistantPort:(NSPort *)port {
    // 保存远程端口
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
