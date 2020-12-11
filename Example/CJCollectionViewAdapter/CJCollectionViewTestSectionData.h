//
//  CJCollectionViewTestSectionData.h
//  CJCollectionViewAdapter_Example
//
//  Created by cj1024 on 2020/12/11.
//  Copyright © 2020 cj1024. All rights reserved.
//

#import <CJCollectionViewAdapter/CJCollectionViewAdapter.h>

@interface CJCollectionViewTestSectionData : CJCollectionViewFlowLayoutSectionData

@property(nonatomic, assign, readonly) NSUInteger count;
@property(nonatomic, assign, readonly) BOOL carouselViewHeader;
@property(nonatomic, assign, readonly) NSUInteger itemsInOneRow; // 0 stands for 1
@property(nonatomic, assign, readonly) BOOL animated;

- (instancetype)initWithCount:(NSUInteger)count itemsInOneRow:(NSUInteger)itemsInOneRow animated:(BOOL)animated;
- (instancetype)initWithCount:(NSUInteger)count carouselViewHeader:(BOOL)carouselViewHeader itemsInOneRow:(NSUInteger)itemsInOneRow animated:(BOOL)animated;

@end
