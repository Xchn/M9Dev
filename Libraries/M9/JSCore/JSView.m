//
//  JSView.m
//  M9Dev
//
//  Created by MingLQ on 2014-08-11.
//  Copyright (c) 2014年 MingLQ <minglq.9@gmail.com>. All rights reserved.
//

#import "JSView.h"

#import "M9Utilities.h"
#import "NSDictionary+.h"

@implementation JSView {
    NSMutableDictionary *keyedSubviews;
}

@dynamic keyedSubviews;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        keyedSubviews = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSDictionary *)keyedSubviews {
    return [keyedSubviews copy];
}

- (UIView *)subviewForKey:(id)key {
    return [[keyedSubviews objectForKey:key] as:[UIView class]];
}

- (void)addSubview:(UIView *)subview forKey:(id)key {
    [keyedSubviews setObjectOrNil:subview forKey:key];
}

- (void)removeSubviewForKey:(id)key {
    [keyedSubviews removeObjectForKey:key];
}

@end

#pragma mark -

@implementation JSView (JS)

@end
