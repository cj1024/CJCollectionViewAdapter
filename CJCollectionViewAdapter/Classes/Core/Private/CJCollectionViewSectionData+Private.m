//
//  CJCollectionViewSectionData+Private.m
//  CJCollectionViewAdapter
//
//  Created by cj1024 on 2020/10/10.
//  Copyright © 2020 cj1024. All rights reserved.
//

#import "CJCollectionViewSectionData.h"
#import "CJCollectionViewSectionData+Sealed.h"
#import "CJCollectionViewSectionData+Private.h"
#import "UICollectionViewLayoutAttributes+CJCollectionViewAdapter.h"

@implementation CJCollectionViewSectionData (PositionValueCache)

@dynamic sectionGlobalYOffset;
@dynamic sectionHeightRecorder;
@dynamic sectionTopInsetRecorder;
@dynamic sectionStickyHeaderHeightRecorder;
@dynamic sectionSeparatorHeaderIndexRecorder;
@dynamic sectionInnerHeaderIndexRecorder;
@dynamic sectionBottomInsetRecorder;
@dynamic sectionStickyFooterHeightRecorder;
@dynamic sectionSeparatorFooterIndexRecorder;
@dynamic sectionInnerFooterIndexRecorder;
@dynamic cachedLayoutAttributes;
@dynamic sectionItemsRangeRecorder;
@dynamic sectionWrappedItemsCountRecorder;

@end

@implementation CJCollectionViewSectionData (Private)

- (NSUInteger)collectionViewWrappedItemCount:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    NSUInteger count = [self sectionItemCount:collectionView forOriginalSection:originalSection];
    if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
        count++;
    }
    if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
        count++;
    }
    if ([self hasSectionInnerFooter:collectionView forOriginalSection:originalSection]) {
        count++;
    }
    if ([self hasSectionSeparatorFooter:collectionView forOriginalSection:originalSection]) {
        count++;
    }
    return count;
}

- (CGFloat)sectionHeight:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    CGFloat height = 0.0;
    NSUInteger index = 0;
    if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
        height += [self sectionSeparatorHeaderHeight:collectionView originalIndexPath:[NSIndexPath indexPathForItem:index inSection:originalSection]];
        index++;
    }
    if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
        height += [self sectionInnerHeaderHeight:collectionView originalIndexPath:[NSIndexPath indexPathForItem:index inSection:originalSection]];
        index++;
    }
    NSUInteger itemCount = [self sectionItemCount:collectionView forOriginalSection:originalSection];
    NSMutableArray <NSNumber *> *items = [NSMutableArray <NSNumber *> arrayWithCapacity:itemCount];
    NSMutableArray <NSIndexPath *> *originalIndexPaths = [NSMutableArray <NSIndexPath *> arrayWithCapacity:itemCount];
    for (NSUInteger i = 0; i < itemCount; i++) {
        [items addObject:[NSNumber numberWithUnsignedInteger:i]];
        [originalIndexPaths addObject:[NSIndexPath indexPathForItem:index inSection:originalSection]];
        index++;
    }
    height += [self sectionCellsHeight:collectionView forOriginalSection:originalSection forItems:items originalIndexPaths:originalIndexPaths];
    if ([self hasSectionInnerFooter:collectionView forOriginalSection:originalSection]) {
        height += [self sectionInnerFooterHeight:collectionView originalIndexPath:[NSIndexPath indexPathForItem:index inSection:originalSection]];
        index++;
    }
    if ([self hasSectionSeparatorFooter:collectionView forOriginalSection:originalSection]) {
        height += [self sectionSeparatorFooterHeight:collectionView originalIndexPath:[NSIndexPath indexPathForItem:index inSection:originalSection]];
        index++;
    }
    return height;
}

- (nonnull __kindof UICollectionViewCell *)collectionViewWrappedCell:(nonnull UICollectionView *)collectionView forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    NSUInteger realItem = item;
    NSUInteger originalSection = originalIndexPath.section;
    if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionSeparatorHeaderCell:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerHeaderCell:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    NSUInteger itemCount = [self sectionItemCount:collectionView forOriginalSection:originalSection];
    if (realItem < itemCount) {
        return [self sectionCell:collectionView forItem:realItem originalIndexPath:originalIndexPath];
    }
    realItem -= itemCount;
    if ([self hasSectionInnerFooter:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerFooterCell:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    return [self sectionSeparatorFooterCell:collectionView originalIndexPath:originalIndexPath];
}

- (nullable UICollectionViewLayoutAttributes *)collectionViewWrappedLayoutAttributes:(nonnull UICollectionView *)collectionView forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    NSUInteger realItem = item;
    CGFloat yOffset = 0.0;
    NSUInteger originalSection = originalIndexPath.section;
    if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            UICollectionViewLayoutAttributes *attributes = [self sectionSeparatorHeaderLayoutAttributes:collectionView originalIndexPath:originalIndexPath];
            attributes.frame = CGRectOffset(attributes.originalFrame, 0, yOffset);
            return attributes;
        }
        yOffset += [self sectionSeparatorHeaderHeight:collectionView originalIndexPath:originalIndexPath];
        realItem--;
    }
    if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            UICollectionViewLayoutAttributes *attributes = [self sectionInnerHeaderLayoutAttributes:collectionView originalIndexPath:originalIndexPath];
            attributes.frame = CGRectOffset(attributes.originalFrame, 0, yOffset);
            return attributes;
        }
        yOffset += [self sectionInnerHeaderHeight:collectionView originalIndexPath:originalIndexPath];
        realItem--;
    }
    NSUInteger itemCount = [self sectionItemCount:collectionView forOriginalSection:originalSection];
    if (realItem < itemCount) {
        UICollectionViewLayoutAttributes *attributes = [self sectionCellLayoutAttributes:collectionView forItem:realItem originalIndexPath:originalIndexPath];
        attributes.frame = CGRectOffset(attributes.originalFrame, 0, yOffset);
        return attributes;
    }
    yOffset += [self sectionItemFrame:collectionView forOriginalSection:originalIndexPath.section].size.height;
    realItem -= itemCount;
    if ([self hasSectionInnerFooter:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            UICollectionViewLayoutAttributes *attributes = [self sectionInnerFooterLayoutAttributes:collectionView originalIndexPath:originalIndexPath];
            attributes.frame = CGRectOffset(attributes.originalFrame, 0, yOffset);
            return attributes;
        }
        yOffset += [self sectionInnerFooterHeight:collectionView originalIndexPath:originalIndexPath];
        realItem--;
    }
    UICollectionViewLayoutAttributes *attributes = [self sectionSeparatorFooterLayoutAttributes:collectionView originalIndexPath:originalIndexPath];
    attributes.frame = CGRectOffset(attributes.originalFrame, 0, yOffset);
    return attributes;
}

- (BOOL)collectionViewWrappedCellShouldHighlight:(nonnull UICollectionView *)collectionView forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    NSUInteger realItem = item;
    NSUInteger originalSection = originalIndexPath.section;
    if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionSeparatorHeaderShouldHighlight:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerHeaderShouldHighlight:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    NSUInteger itemCount = [self sectionItemCount:collectionView forOriginalSection:originalSection];
    if (realItem < itemCount) {
        return [self sectionCellShouldHighlight:collectionView forItem:realItem originalIndexPath:originalIndexPath];
    }
    realItem -= itemCount;
    if ([self hasSectionInnerFooter:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerFooterShouldHighlight:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    return [self sectionSeparatorFooterShouldHighlight:collectionView originalIndexPath:originalIndexPath];
}

- (BOOL)collectionViewWrappedCellShouldSelect:(nonnull UICollectionView *)collectionView forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    NSUInteger realItem = item;
    NSUInteger originalSection = originalIndexPath.section;
    if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionSeparatorHeaderShouldSelect:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerHeaderShouldSelect:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    NSUInteger itemCount = [self sectionItemCount:collectionView forOriginalSection:originalSection];
    if (realItem < itemCount) {
        return [self sectionCellShouldSelect:collectionView forItem:realItem originalIndexPath:originalIndexPath];
    }
    realItem -= itemCount;
    if ([self hasSectionInnerFooter:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerFooterShouldSelect:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    return [self sectionSeparatorFooterShouldSelect:collectionView originalIndexPath:originalIndexPath];
}

- (BOOL)collectionViewWrappedCellShouldDeselect:(nonnull UICollectionView *)collectionView forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    NSUInteger realItem = item;
    NSUInteger originalSection = originalIndexPath.section;
    if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionSeparatorHeaderShouldDeselect:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerHeaderShouldDeselect:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    NSUInteger itemCount = [self sectionItemCount:collectionView forOriginalSection:originalSection];
    if (realItem < itemCount) {
        return [self sectionCellShouldDeselect:collectionView forItem:realItem originalIndexPath:originalIndexPath];
    }
    realItem -= itemCount;
    if ([self hasSectionInnerFooter:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerFooterShouldDeselect:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    return [self sectionSeparatorFooterShouldDeselect:collectionView originalIndexPath:originalIndexPath];
}

- (void)collectionViewWrappedCellDidSelected:(nonnull UICollectionView *)collectionView forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    NSUInteger realItem = item;
    NSUInteger originalSection = originalIndexPath.section;
    if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionSeparatorHeaderDidSelected:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerHeaderDidSelected:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    NSUInteger itemCount = [self sectionItemCount:collectionView forOriginalSection:originalSection];
    if (realItem < itemCount) {
        return [self sectionCellDidSelected:collectionView forItem:realItem originalIndexPath:originalIndexPath];
    }
    realItem -= itemCount;
    if ([self hasSectionInnerFooter:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerFooterDidSelected:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    return [self sectionSeparatorFooterDidSelected:collectionView originalIndexPath:originalIndexPath];
}

- (void)collectionViewWrappedCellDidDeselected:(nonnull UICollectionView *)collectionView forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    NSUInteger realItem = item;
    NSUInteger originalSection = originalIndexPath.section;
    if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionSeparatorHeaderDidDeselected:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerHeaderDidDeselected:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    NSUInteger itemCount = [self sectionItemCount:collectionView forOriginalSection:originalSection];
    if (realItem < itemCount) {
        return [self sectionCellDidDeselected:collectionView forItem:realItem originalIndexPath:originalIndexPath];
    }
    realItem -= itemCount;
    if ([self hasSectionInnerFooter:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerFooterDidDeselected:collectionView originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    return [self sectionSeparatorFooterDidDeselected:collectionView originalIndexPath:originalIndexPath];
}

- (void)collectionView:(nonnull UICollectionView *)collectionView wrappedCellWillDisplay:(nonnull UICollectionViewCell *)cell forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    NSUInteger realItem = item;
    NSUInteger originalSection = originalIndexPath.section;
    if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionSeparatorHeaderWillDisplay:collectionView cell:cell originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerHeaderWillDisplay:collectionView cell:cell originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    NSUInteger itemCount = [self sectionItemCount:collectionView forOriginalSection:originalSection];
    if (realItem < itemCount) {
        return [self sectionCellWillDisplay:collectionView cell:cell forItem:realItem originalIndexPath:originalIndexPath];
    }
    realItem -= itemCount;
    if ([self hasSectionInnerFooter:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerFooterWillDisplay:collectionView cell:cell originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    return [self sectionSeparatorFooterWillDisplay:collectionView cell:cell originalIndexPath:originalIndexPath];
}

- (void)collectionView:(nonnull UICollectionView *)collectionView wrappedCellDidEndDisplay:(nonnull UICollectionViewCell *)cell forWrappedItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    NSUInteger realItem = item;
    NSUInteger originalSection = originalIndexPath.section;
    if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionSeparatorHeaderDidEndDisplay:collectionView cell:cell originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerHeaderDidEndDisplay:collectionView cell:cell originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    NSUInteger itemCount = [self sectionItemCount:collectionView forOriginalSection:originalSection];
    if (realItem < itemCount) {
        return [self sectionCellDidEndDisplay:collectionView cell:cell forItem:realItem originalIndexPath:originalIndexPath];
    }
    realItem -= itemCount;
    if ([self hasSectionInnerFooter:collectionView forOriginalSection:originalSection]) {
        if (realItem == 0) {
            return [self sectionInnerFooterDidEndDisplay:collectionView cell:cell originalIndexPath:originalIndexPath];
        }
        realItem--;
    }
    return [self sectionSeparatorFooterDidEndDisplay:collectionView cell:cell originalIndexPath:originalIndexPath];
}

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView shouldInvalidateLayoutForWrappedBoundsChange:(CGRect)wrappedNewBounds originalNewBounds:(CGRect)originalNewBounds forOriginalSection:(NSUInteger)originalSection {
    CGRect sectionItemFrame = [self sectionItemFrame:collectionView forOriginalSection:originalSection];
    CGRect intersectionRect = CGRectIntersection(sectionItemFrame, wrappedNewBounds);
    if (!CGRectIsEmpty(intersectionRect) && !CGRectIsNull(intersectionRect)) {
        return [self shouldInvalidateCellsLayout:collectionView forBoundsChange:intersectionRect wrappedNewBounds:wrappedNewBounds originalNewBounds:originalNewBounds forOriginalSection:originalSection];
    }
    return NO;
}

@end
