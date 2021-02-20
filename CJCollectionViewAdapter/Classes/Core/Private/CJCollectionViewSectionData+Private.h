//
//  CJCollectionViewSectionData+Private.h
//  CJCollectionViewAdapter
//
//  Created by cj1024 on 2020/10/10.
//  Copyright © 2020 cj1024. All rights reserved.
//

#import "CJCollectionViewSectionData.h"

@interface CJCollectionViewSectionData (PositionValueCache)

@property(nonatomic, assign, readwrite) CGFloat sectionGlobalYOffset;
@property(nonatomic, assign, readwrite) CGFloat sectionHeightRecorder;

@property(nonatomic, assign, readwrite) CGFloat sectionTopInsetRecorder;
@property(nonatomic, strong, readwrite, nullable) NSNumber *sectionStickyHeaderHeightRecorder;
@property(nonatomic, assign, readwrite) NSInteger sectionSeparatorHeaderIndexRecorder;
@property(nonatomic, strong, readwrite, nullable) NSNumber *sectionSeparatorHeaderHeightRecorder;
@property(nonatomic, assign, readwrite) NSInteger sectionInnerHeaderIndexRecorder;
@property(nonatomic, strong, readwrite, nullable) NSNumber *sectionInnerHeaderHeightRecorder;
@property(nonatomic, assign, readwrite) CGFloat sectionBottomInsetRecorder;
@property(nonatomic, strong, readwrite, nullable) NSNumber *sectionStickyFooterHeightRecorder;
@property(nonatomic, assign, readwrite) NSInteger sectionSeparatorFooterIndexRecorder;
@property(nonatomic, strong, readwrite, nullable) NSNumber *sectionSeparatorFooterHeightRecorder;
@property(nonatomic, assign, readwrite) NSInteger sectionInnerFooterIndexRecorder;
@property(nonatomic, strong, readwrite, nullable) NSNumber *sectionInnerFooterHeightRecorder;
@property(nonatomic, assign, readwrite) NSRange sectionItemsRangeRecorder;
@property(nonatomic, assign, readwrite) NSInteger sectionWrappedItemsCountRecorder;

@property(nonatomic, copy, readwrite, nullable) NSArray <UICollectionViewLayoutAttributes *> *cachedLayoutAttributes;

@end

@interface CJCollectionViewSectionData (Private)

@property(nonatomic, weak, readwrite, nullable) UICollectionReusableView <ICJCollectionViewSectionBackground> *attachedBackgroundContainer;

- (NSUInteger)collectionViewWrappedItemCount:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (CGFloat)sectionHeight:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (nonnull __kindof UICollectionViewCell *)collectionViewWrappedCell:(nonnull UICollectionView *)collectionView forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (nullable UICollectionViewLayoutAttributes *)collectionViewWrappedLayoutAttributes:(nonnull UICollectionView *)collectionView forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (BOOL)collectionViewWrappedCellShouldHighlight:(nonnull UICollectionView *)collectionView forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (BOOL)collectionViewWrappedCellShouldSelect:(nonnull UICollectionView *)collectionView forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (BOOL)collectionViewWrappedCellShouldDeselect:(nonnull UICollectionView *)collectionView forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)collectionViewWrappedCellDidSelected:(nonnull UICollectionView *)collectionView forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)collectionViewWrappedCellDidDeselected:(nonnull UICollectionView *)collectionView forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)collectionView:(nonnull UICollectionView *)collectionView wrappedCellWillDisplay:(nonnull UICollectionViewCell *)cell forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)collectionView:(nonnull UICollectionView *)collectionView wrappedCellDidEndDisplay:(nonnull UICollectionViewCell *)cell forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView shouldInvalidateLayoutForWrappedBoundsChange:(CGRect)wrappedNewBounds originalNewBounds:(CGRect)originalNewBounds forOriginalSection:(NSUInteger)originalSection;

@end
