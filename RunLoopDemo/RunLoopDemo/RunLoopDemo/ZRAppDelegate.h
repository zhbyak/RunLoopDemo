//
//  ZRAppDelegate.h
//  RunLoopDemo
//
//  Created by pingqian on 17/6/19.
//  Copyright © 2017年 O2O. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZRRunLoopSource.h"

@interface ZRAppDelegate : NSObject

@property (nonatomic, strong) NSMutableArray *sourcesToPing;

/** 应该是一个单例 */
+ (instancetype)sharedAppDelegate;
- (void)registerSource:(ZRRunLoopContext *)context;
- (void)removeSource:(ZRRunLoopContext *)context;

@end
