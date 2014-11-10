//
//  M9Promise.m
//  M9Dev
//
//  Created by MingLQ on 2014-11-10.
//  Copyright (c) 2014年 iwill. All rights reserved.
//

#import "M9Promise.h"

#import "EXTScope.h"

#import "M9Utilities.h"
#import "NSArray+.h"
#import "NSDictionary+.h"

@interface M9Promise ()

@property(nonatomic, copy) Task task;

@end

@implementation M9Promise {
    Then _then;
    Done _done;
    Catch _catch;
    
    Fulfill _fulfill;
    Reject _reject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        weakify(self);
        
        _then = ^(Fulfill onFulfilled, Reject onRejected) {
            strongify(self);
            return [[self class] promise:^(Fulfill fulfill, Reject reject) {
                // TODO: handle(new Handler(onFulfilled, onRejected, resolve, reject))
            }];
        };
        _done = ^(Fulfill onFulfilled) {
            strongify(self);
            return self.then(onFulfilled, nil);
        };
        _catch = ^(Reject onRejected) {
            strongify(self);
            return self.then(nil, onRejected);
        };
        
        _fulfill = ^void (id value) {
        };
        _reject = ^void (id reason) {
        };
    }
    return self;
}

+ (instancetype)promise:(Task)task {
    M9Promise *promise = [self new];
    promise.task = task;
    return promise;
}

+ (instancetype)all:(Task)first, ... {
    M9Promise *promise = [self new];
    // TODO: NSMutableArray *tasks = va_array(M9Promise *, first);
    return promise;
}

+ (instancetype)any:(Task)first, ... {
    M9Promise *promise = [self new];
    // TODO: NSMutableArray *tasks = va_array(M9Promise *, first);
    return promise;
}

@end
