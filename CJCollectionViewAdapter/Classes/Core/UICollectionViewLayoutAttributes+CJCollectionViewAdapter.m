//
//  UICollectionViewLayoutAttributes+CollectionViewAdapter.m
//  CJCollectionViewAdapter
//
//  Created by cj1024 on 2020/10/10.
//  Copyright © 2020 cj1024. All rights reserved.
//

#import "UICollectionViewLayoutAttributes+CJCollectionViewAdapter.h"
#import <objc/runtime.h>

@implementation UICollectionViewLayoutAttributes (CJCollectionViewAdapter)

static NSString * const kUICollectionViewLayoutAttributesOriginalFrameKey = @"collectionviewadapter.layoutattributes.originalinfo.frame";

@dynamic originalFrame;

- (CGRect)originalFrame {
    NSValue *value = objc_getAssociatedObject(self, (__bridge const void *)(kUICollectionViewLayoutAttributesOriginalFrameKey));
    return [value isKindOfClass:[NSValue class]] ? [value CGRectValue] : self.frame;
}

- (void)setOriginalFrame:(CGRect)originalFrame {
    self.frame = originalFrame;
    objc_setAssociatedObject(self, (__bridge const void *)(kUICollectionViewLayoutAttributesOriginalFrameKey), [NSValue valueWithCGRect:originalFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
