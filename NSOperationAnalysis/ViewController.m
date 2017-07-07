//
//  ViewController.m
//  NSOperationAnalysis
//
//  Created by apple on 17/7/7.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import "ViewController.h"
#import "NonConcurrentOperation.h"
#import "ConcurrentOpetation.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //在默认情况下，operation 是同步执行的，也就是说在调用它的 start 方法的线程中执行它们的任务。
    NSInvocationOperation *invocationOpe = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(invocationOpe) object:nil];
//    [invocationOpe start];
    invocationOpe.completionBlock = ^{
        //一个任务执行完后，会执行到这里，而且和执行任务的线程是同一个线程
        NSLog(@"invocationOperation completionBlock = %@",[NSThread currentThread]);
    };
    
    NSBlockOperation *blockOpe = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOperation1 = %@",[NSThread currentThread]);
    }];
    [blockOpe addExecutionBlock:^{
        NSLog(@"blockOperation2 = %@",[NSThread currentThread]);

    }];
    [blockOpe addExecutionBlock:^{
        NSLog(@"blockOperation3 = %@",[NSThread currentThread]);
        
    }];
    [blockOpe addExecutionBlock:^{
        NSLog(@"blockOperation4 = %@",[NSThread currentThread]);
        
    }];
    [blockOpe addExecutionBlock:^{
        NSLog(@"blockOperation5 = %@",[NSThread currentThread]);
        
    }];
    [blockOpe addExecutionBlock:^{
        NSLog(@"blockOperation6 = %@",[NSThread currentThread]);
        
    }];
    [blockOpe addExecutionBlock:^{
        NSLog(@"blockOperation7 = %@",[NSThread currentThread]);
        
    }];
    [blockOpe addExecutionBlock:^{
        NSLog(@"blockOperation8 = %@",[NSThread currentThread]);
        
    }];
    [blockOpe addExecutionBlock:^{
        NSLog(@"blockOperation9 = %@",[NSThread currentThread]);
        
    }];
    blockOpe.completionBlock = ^{
        //放到queue中的NSBlockOperation会开辟多个线程，当最后一个任务执行完后会执行到这里，而且执行到这里的线程和最后一个任务执行的线程是同一个线程
        NSLog(@"blockOperation completionBlock = %@",[NSThread currentThread]);

    };
    //将NSInvocationOperation或者NSBlockOpetation添加到queue中不需要手动调用start
//    [blockOpe start];
    //优先级高的任务，调用几率比较大，并不是一定会优先执行
    //队列优先级只应用于相同 operation queue 中的 operation 之间，不同 operation queue 中的 operation 不受此影响
//    blockOpe.queuePriority = NSOperationQueuePriorityHigh;
//    invocationOpe.queuePriority = NSOperationQueuePriorityLow;
    //依赖关系不光在同队列中生效，不同队列的NSOperation对象之前设置的依赖关系一样会生效
    //一定要在添加到queue之前，进行设置依赖关系。
    [invocationOpe addDependency:blockOpe];
    //取消opration
//    [invocationOpe cancel];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //并发数:同时执⾏行的任务数.比如,同时开3个线程执行3个任务,并发数就是3，最大并发数不要乱写（5以内），不要开太多，一般以2~3为宜，因为虽然任务是在子线程进行处理的，但是cpu处理这些过多的子线程可能会影响UI，让UI变卡
    queue.maxConcurrentOperationCount = 1;
    [queue addOperation:invocationOpe];
    [queue addOperation:blockOpe];
    //取消全部的opration
//    [queue cancelAllOperations];
    //暂停queue
    //这里需要强调的是，所谓的暂停和取消并不会立即暂停或取消当前操作，而是不在调用新的NSOperation。
//    [queue setSuspended:YES];
    
/***************************************************************************************/
    //最简单的使用NSOperationqueue创建一个并行队列
    NSOperationQueue * queue1 = [[NSOperationQueue alloc]init];
    [queue1 addOperationWithBlock:^{
        //这里是你想做的操作
    }];
    
/***************************************************************************************/
    
    //自定义线程的目的：想使用NSOperation对象的start方法（不和NSOpetationQueue配合使用），来配置opration对象是否是并发执行的。
    [self setNonConcurrentOpetation];
    [self setConcurrentOperation];
}

- (void)invocationOpe{
    NSLog(@"invocationOperation = %@",[NSThread currentThread]);
    //invocationOperation = <NSThread: 0x608000068bc0>{number = 1, name = main}
}


- (void)setNonConcurrentOpetation{
    NonConcurrentOperation *nonConcurrentOpe = [[NonConcurrentOperation alloc]init];
    [nonConcurrentOpe start];
    //任务去哪了？自定义operation 任务是放在main中执行的，可以自定义init方法中把数据传输到自定义类中，在main方法中实现任务
}

- (void)setConcurrentOperation{
    ConcurrentOpetation *concurrentOpe = [[ConcurrentOpetation alloc]init];
    [concurrentOpe start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
