//
//  DelegateRequestInfo.m
//  M9Dev
//
//  Created by MingLQ on 2014-07-17.
//  Copyright (c) 2014年 iwill. All rights reserved.
//

#import "DelegateRequestInfo.h"

#import "EXTScope.h"
#import "M9Utilities.h"
#import "NSInvocation+.h"

@implementation DelegateRequestInfo

@dynamic delegate;

- (id)init {
    self = [super init];
    if (self) {
        weakify(self);
        [super setSuccess:^(id<M9ResponseInfo> responseInfo, id responseObject) {
            strongify(self);
            if ([self.delegate respondsToSelector:self.successSelector]) {
                M9RequestInfo *requestInfo = self;
                /* NOTE:
                 *  save requestItem as self.requestItem when send request
                 *  make responseItem from self.requestItem and callback here
                 */
                [self.delegate invokeWithSelector:self.successSelector arguments:&requestInfo, &responseInfo, &responseObject];
            }
        }];
        [super setFailure:^(id<M9ResponseInfo> responseInfo, NSError *error) {
            strongify(self);
            if ([self.delegate respondsToSelector:self.failureSelector]) {
                M9RequestInfo *requestInfo = self;
                [self.delegate invokeWithSelector:self.failureSelector arguments:&requestInfo, &responseInfo, &error];
            }
        }];
    }
    return self;
}

- (void)setSuccess:(void (^)(id<M9ResponseInfo>, id))success {
}

- (void)setFailure:(void (^)(id<M9ResponseInfo>, NSError *))failure {
}

- (id)delegate {
    return self.owner;
}

- (void)setDelegate:(id)delegate {
    self.owner = delegate;
}

- (void)setDelegate:(id)delegate successSelector:(SEL)successSelector failureSelector:(SEL)failureSelector {
    self.delegate = delegate;
    self.successSelector = successSelector;
    self.failureSelector = failureSelector;
}

- (void)makeCopy:(DelegateRequestInfo *)copy {
    copy.userInfo = self.userInfo;
    copy.delegate = self.delegate;
    copy.successSelector = self.successSelector;
    copy.failureSelector = self.failureSelector;
}

@end
