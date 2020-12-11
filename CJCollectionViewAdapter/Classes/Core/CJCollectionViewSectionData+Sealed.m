//
//  CJCollectionViewSectionData+Sealed.m
//  CJCollectionViewAdapter
//
//  Created by cj1024 on 2020/10/10.
//  Copyright © 2020 cj1024. All rights reserved.
//

#import "CJCollectionViewSectionData.h"
#import "CJCollectionViewSectionData+Sealed.h"

@implementation CJCollectionViewSectionData (SectionHeaderSealed)

- (NSInteger)sectionSeparatorHeaderIndex:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return [self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection] ? 0 : -1;
}

- (NSInteger)sectionInnerHeaderIndex:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return [self hasSectionInnerHeader:collectionView forOriginalSection:originalSection] ? ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection] ? 1 : 0) : -1;
}

@end

@implementation CJCollectionViewSectionData (SectionItemSealed)

- (NSRange)sectionItemRange:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    NSUInteger index = 0;
    if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
        index++;
    }
    if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
        index++;
    }
    return NSMakeRange(index, [self sectionItemCount:collectionView forOriginalSection:originalSection]);
}

- (CGRect)sectionItemFrame:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    CGFloat offsetY = 0.0;
    NSUInteger index = 0;
    if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
        offsetY += [self sectionSeparatorHeaderHeight:collectionView originalIndexPath:[NSIndexPath indexPathForItem:index inSection:originalSection]];
        index++;
    }
    if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
        offsetY += [self sectionInnerHeaderHeight:collectionView originalIndexPath:[NSIndexPath indexPathForItem:index inSection:originalSection]];
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
    CGFloat height = [self sectionCellsHeight:collectionView forOriginalSection:originalSection forItems:items originalIndexPaths:originalIndexPaths];
    return CGRectMake(0.0, offsetY, 0.0, height);
}

@end

@implementation CJCollectionViewSectionData (SectionFooterSealed)

- (NSInteger)sectionSeparatorFooterIndex:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    if ([self hasSectionSeparatorFooter:collectionView forOriginalSection:originalSection]) {
        NSUInteger itemCount = [self sectionItemCount:collectionView forOriginalSection:originalSection];
        if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
            itemCount++;
        }
        if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
            itemCount++;
        }
        if ([self hasSectionInnerFooter:collectionView forOriginalSection:originalSection]) {
            itemCount++;
        }
        return itemCount;
    } else {
        return -1;
    }
}

- (NSInteger)sectionInnerFooterIndex:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    if ([self hasSectionInnerFooter:collectionView forOriginalSection:originalSection]) {
        NSUInteger itemCount = [self sectionItemCount:collectionView forOriginalSection:originalSection];
        if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
            itemCount++;
        }
        if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
            itemCount++;
        }
        return itemCount;
    } else {
        return -1;
    }
}

@end
