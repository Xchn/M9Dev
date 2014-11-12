//
//  M9Promise.h
//  M9Dev
//
//  Created by MingLQ on 2014-11-10.
//  Copyright (c) 2014年 iwill. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * M9Thenable
 *  Thenable from Promises/A+
 *
 * @see
 *  Promises/A+
 *  https://promisesaplus.com/
 *  http://www.ituring.com.cn/article/66566
 */

/**
 * M9ThenableCallback
 *  callback type for fulfill/reject
 *
 * @param id value
 *  value to fulfill/reject the current-promise
 *
 * @return
 *  nil if nothing to do
 *  a value to fulfill the next-promise from then
 *  a thenable to fulfill/reject the next-promise
 */
typedef id (^M9ThenableCallback)(id value);

@protocol M9Thenable <NSObject>

@property(nonatomic, copy, readonly) id<M9Thenable> (^then)(M9ThenableCallback fulfillCallback, M9ThenableCallback rejectCallback);

@end

#pragma mark -

/**
 * M9Promise
 *  a simple implementation Promises/A+ with Objective-C without exception handling
 *
 * @see
 *  PromiseJS Implementing
 *  https://www.promisejs.org/
 *  https://www.promisejs.org/implementing/
 *  https://github.com/then/promise/
 */

@class M9Promise;

typedef void (^M9PromiseCallback)(id value);
typedef void (^M9PromiseBlock)(M9PromiseCallback fulfill, M9PromiseCallback reject);

#define M9PromiseError @"M9PromiseError"
typedef NS_ENUM(NSInteger, M9PromiseErrorCode) {
    M9PromiseErrorCode_TypeError
};

@interface M9Promise : NSObject <M9Thenable>

#pragma mark <M9Thenable>

@property(nonatomic, copy, readonly) M9Promise *(^then)(M9ThenableCallback fulfillCallback, M9ThenableCallback rejectCallback);

#pragma mark helper

@property(nonatomic, copy, readonly) M9Promise *(^done)(M9ThenableCallback fulfillCallback);
@property(nonatomic, copy, readonly) M9Promise *(^catch)(M9ThenableCallback rejectCallback);
@property(nonatomic, copy, readonly) M9Promise *(^finally)(M9ThenableCallback fulfillCallback);

+ (instancetype)promise:(M9PromiseBlock)task;

+ (instancetype)all:(M9PromiseBlock)task, ...;
+ (instancetype)any:(M9PromiseBlock)task, ...;
// !!!: if (howMany <= 0 || howMany > count) howMany = count;
+ (instancetype)some:(NSInteger)howMany :(M9PromiseBlock)task, ...;

@end