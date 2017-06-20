//
//  ZRAppDelegate.m
//  RunLoopDemo
//
//  Created by pingqian on 17/6/19.
//  Copyright © 2017年 O2O. All rights reserved.
//

#import "ZRAppDelegate.h"
static ZRAppDelegate *_instance;

@implementation ZRAppDelegate

+ (instancetype)sharedAppDelegate
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)registerSource:(ZRRunLoopContext *)context
{
    [self.sourcesToPing addObject:context];
}

- (void)removeSource:(ZRRunLoopContext *)context
{
    id objToRemove = nil;
    
    for (ZRRunLoopContext *contextObj in self.sourcesToPing) {
        if ([contextObj isEqual:context]) {
            objToRemove = contextObj;
            break;
        }
    }
    
    if (objToRemove) {
        [self.sourcesToPing removeObject:objToRemove];
    }
}

- (NSMutableArray *)sourcesToPing {
    if (_sourcesToPing == nil) {
        _sourcesToPing = @[].mutableCopy;
    }
    return _sourcesToPing;
}

@end
