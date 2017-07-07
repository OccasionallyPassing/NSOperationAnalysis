//
//  NonConcurrentOperation.m
//  NSOperationAnalysis
//
//  Created by apple on 17/7/7.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import "NonConcurrentOperation.h"

@implementation NonConcurrentOperation

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)main{
    @try {
        if (self.isCancelled) return;
        
        NSLog(@"Start executing %@, mainThread: %@, currentThread: %@", NSStringFromSelector(_cmd), [NSThread mainThread], [NSThread currentThread]);
        
        for (NSUInteger i = 0; i < 3; i++) {
            if (self.isCancelled) return;
            
            sleep(1);
            
            NSLog(@"Loop %@", @(i + 1));
        }
        
        NSLog(@"Finish executing %@", NSStringFromSelector(_cmd));
    }
    @catch(NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}

@end
