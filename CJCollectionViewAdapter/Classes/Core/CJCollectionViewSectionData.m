//
//  CJCollectionViewSectionData.m
//  CJCollectionViewAdapter
//
//  Created by cj1024 on 2020/10/10.
//  Copyright © 2020 cj1024. All rights reserved.
//

#import "CJCollectionViewSectionData.h"
#import "CJCollectionViewSectionData+Sealed.h"
#import "CJCollectionViewSectionData+Private.h"
#import "UICollectionViewLayoutAttributes+CJCollectionViewAdapter.h"

const CGFloat kCJCollectionViewSectionDefaultSeparatorHeaderFooterHeight = 8.0;
const CGFloat kCJCollectionViewSectionDefaultInnerHeaderFooterHeight = 44.0;
const CGFloat kCJCollectionViewSectionDefaultCellHeight = 44.0;

static NSString * const kCJCollectionViewSectionDataDefaultCellReuseIndentifer = @"collectionviewsectiondata.reuseindentifier.cell";
static NSString * const kCJCollectionViewSectionDataDefaultSeparatorHeaderFooterReuseIndentifer = @"collectionviewsectiondata.reuseindentifier.separatorheaderfooter";
static NSString * const kCJCollectionViewSectionDataDefaultInnerHeaderFooterReuseIndentifer = @"collectionviewsectiondata.reuseindentifier.innerheaderfooter";

@interface CJCollectionViewSectionData ()

@property(nonatomic, assign, readwrite) CGFloat sectionGlobalYOffset;
@property(nonatomic, assign, readwrite) CGFloat sectionHeightRecorder;

@property(nonatomic, assign, readwrite) CGFloat sectionTopInsetRecorder;
@property(nonatomic, strong, readwrite) NSNumber *sectionStickyHeaderHeightRecorder;
@property(nonatomic, assign, readwrite) NSInteger sectionSeparatorHeaderIndexRecorder;
@property(nonatomic, assign, readwrite) NSInteger sectionInnerHeaderIndexRecorder;
@property(nonatomic, assign, readwrite) CGFloat sectionBottomInsetRecorder;
@property(nonatomic, strong, readwrite) NSNumber *sectionStickyFooterHeightRecorder;
@property(nonatomic, assign, readwrite) NSInteger sectionSeparatorFooterIndexRecorder;
@property(nonatomic, assign, readwrite) NSInteger sectionInnerFooterIndexRecorder;

@property(nonatomic, copy, readwrite, nullable) NSArray <UICollectionViewLayoutAttributes *> *cachedLayoutAttributes;

@end

@implementation CJCollectionViewSectionData

- (void)registerReuseIndentifer:(UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCJCollectionViewSectionDataDefaultCellReuseIndentifer];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCJCollectionViewSectionDataDefaultSeparatorHeaderFooterReuseIndentifer];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCJCollectionViewSectionDataDefaultInnerHeaderFooterReuseIndentifer];
}

- (void)prepareData:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    
}

- (void)prepareLayout:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    
}

@end

@implementation CJCollectionViewSectionData (SectionHeader)

- (CGFloat)sectionTopInset {
    return 0.0;
}

- (BOOL)hasSectionStickyHeader:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return NO;
}

- (nullable UIView *)sectionStickyHeader:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return nil;
}

- (CGFloat)sectionStickyHeaderHeight:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return 0.0;
}

- (BOOL)hasSectionSeparatorHeader:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return NO;
}

- (CGFloat)sectionSeparatorHeaderHeight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return kCJCollectionViewSectionDefaultSeparatorHeaderFooterHeight;
}

- (nonnull __kindof UICollectionViewCell *)sectionSeparatorHeaderCell:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    UICollectionViewCell *result = [collectionView dequeueReusableCellWithReuseIdentifier:kCJCollectionViewSectionDataDefaultSeparatorHeaderFooterReuseIndentifer forIndexPath:originalIndexPath];
    result.backgroundColor = [UIColor clearColor];
    result.backgroundView = [[UIView alloc] init];
    result.backgroundView.backgroundColor = [UIColor clearColor];
    result.selectedBackgroundView = [[UIView alloc] init];
    result.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    return result;
}

- (nullable UICollectionViewLayoutAttributes *)sectionSeparatorHeaderLayoutAttributes:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:originalIndexPath];
    attributes.originalFrame = CGRectMake(0, 0, CGRectGetWidth(collectionView.frame), [self sectionSeparatorHeaderHeight:collectionView originalIndexPath:originalIndexPath]);
    return attributes;
}

- (BOOL)sectionSeparatorHeaderShouldHighlight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return YES;
}

- (BOOL)sectionSeparatorHeaderShouldSelect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return YES;
}

- (BOOL)sectionSeparatorHeaderShouldDeselect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return YES;
}

- (void)sectionSeparatorHeaderDidSelected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (void)sectionSeparatorHeaderDidDeselected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (void)sectionSeparatorHeaderWillDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (void)sectionSeparatorHeaderDidEndDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (BOOL)hasSectionInnerHeader:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return NO;
}

- (CGFloat)sectionInnerHeaderHeight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return kCJCollectionViewSectionDefaultInnerHeaderFooterHeight;
}

- (nonnull __kindof UICollectionViewCell *)sectionInnerHeaderCell:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    UICollectionViewCell *result = [collectionView dequeueReusableCellWithReuseIdentifier:kCJCollectionViewSectionDataDefaultInnerHeaderFooterReuseIndentifer forIndexPath:originalIndexPath];
    result.backgroundColor = [UIColor whiteColor];
    result.backgroundView = [[UIView alloc] init];
    result.backgroundView.backgroundColor = [UIColor clearColor];
    result.selectedBackgroundView = [[UIView alloc] init];
    result.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    return result;
}

- (nullable UICollectionViewLayoutAttributes *)sectionInnerHeaderLayoutAttributes:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:originalIndexPath];
    attributes.originalFrame = CGRectMake(0, 0, CGRectGetWidth(collectionView.frame), [self sectionInnerHeaderHeight:collectionView originalIndexPath:originalIndexPath]);
    return attributes;
}

- (BOOL)sectionInnerHeaderShouldHighlight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return YES;
}

- (BOOL)sectionInnerHeaderShouldSelect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return YES;
}

- (BOOL)sectionInnerHeaderShouldDeselect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return YES;
}

- (void)sectionInnerHeaderDidSelected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (void)sectionInnerHeaderDidDeselected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (void)sectionInnerHeaderWillDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (void)sectionInnerHeaderDidEndDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

@end

@implementation CJCollectionViewSectionData (SectionItem)

- (NSUInteger)sectionItemCount:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return 0;
}

- (CGFloat)sectionCellsHeight:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection forItems:(nonnull NSArray <NSNumber *> *)items originalIndexPaths:(nonnull NSArray <NSIndexPath *> *)originalIndexPaths {
    return kCJCollectionViewSectionDefaultCellHeight * [self sectionItemCount:collectionView forOriginalSection:originalSection];
}

- (nonnull __kindof UICollectionViewCell *)sectionCell:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:kCJCollectionViewSectionDataDefaultCellReuseIndentifer forIndexPath:originalIndexPath];
}

- (nullable UICollectionViewLayoutAttributes *)sectionCellLayoutAttributes:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:originalIndexPath];
    attributes.originalFrame = CGRectMake(0, item * kCJCollectionViewSectionDefaultCellHeight, CGRectGetWidth(collectionView.frame), kCJCollectionViewSectionDefaultCellHeight);
    return attributes;
}

- (BOOL)sectionCellShouldHighlight:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return YES;
}

- (BOOL)sectionCellShouldSelect:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return YES;
}

- (BOOL)sectionCellShouldDeselect:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return YES;
}

- (void)sectionCellDidSelected:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (void)sectionCellDidDeselected:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (void)sectionCellWillDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (void)sectionCellDidEndDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (BOOL)shouldInvalidateCellsLayout:(nonnull UICollectionView *)collectionView forBoundsChange:(CGRect)fixedNewBounds wrappedNewBounds:(CGRect)wrappedNewBounds originalNewBounds:(CGRect)originalNewBounds forOriginalSection:(NSUInteger)originalSection {
    return NO;
}

@end

@implementation CJCollectionViewSectionData (SectionFooter)

- (CGFloat)sectionBottomInset {
    return 0.0;
}

- (BOOL)hasSectionStickyFooter:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return NO;
}

- (nullable UIView *)sectionStickyFooter:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return nil;
}

- (CGFloat)sectionStickyFooterHeight:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return 0.0;
}

- (BOOL)hasSectionSeparatorFooter:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return NO;
}

- (CGFloat)sectionSeparatorFooterHeight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return kCJCollectionViewSectionDefaultSeparatorHeaderFooterHeight;
}

- (nonnull __kindof UICollectionViewCell *)sectionSeparatorFooterCell:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    UICollectionViewCell *result = [collectionView dequeueReusableCellWithReuseIdentifier:kCJCollectionViewSectionDataDefaultSeparatorHeaderFooterReuseIndentifer forIndexPath:originalIndexPath];
    result.backgroundColor = [UIColor clearColor];
    result.backgroundView = [[UIView alloc] init];
    result.backgroundView.backgroundColor = [UIColor clearColor];
    result.selectedBackgroundView = [[UIView alloc] init];
    result.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    return result;
}

- (nullable UICollectionViewLayoutAttributes *)sectionSeparatorFooterLayoutAttributes:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:originalIndexPath];
    attributes.originalFrame = CGRectMake(0, 0, CGRectGetWidth(collectionView.frame), [self sectionSeparatorFooterHeight:collectionView originalIndexPath:originalIndexPath]);
    return attributes;
}

- (BOOL)sectionSeparatorFooterShouldHighlight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return YES;
}

- (BOOL)sectionSeparatorFooterShouldSelect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return YES;
}

- (BOOL)sectionSeparatorFooterShouldDeselect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return YES;
}

- (void)sectionSeparatorFooterDidSelected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (void)sectionSeparatorFooterDidDeselected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (void)sectionSeparatorFooterWillDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (void)sectionSeparatorFooterDidEndDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (BOOL)hasSectionInnerFooter:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return NO;
}

- (CGFloat)sectionInnerFooterHeight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return kCJCollectionViewSectionDefaultInnerHeaderFooterHeight;
}

- (nonnull __kindof UICollectionViewCell *)sectionInnerFooterCell:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    UICollectionViewCell *result = [collectionView dequeueReusableCellWithReuseIdentifier:kCJCollectionViewSectionDataDefaultInnerHeaderFooterReuseIndentifer forIndexPath:originalIndexPath];
    result.backgroundColor = [UIColor whiteColor];
    result.backgroundView = [[UIView alloc] init];
    result.backgroundView.backgroundColor = [UIColor clearColor];
    result.selectedBackgroundView = [[UIView alloc] init];
    result.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    return result;
}

- (nullable UICollectionViewLayoutAttributes *)sectionInnerFooterLayoutAttributes:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:originalIndexPath];
    attributes.originalFrame = CGRectMake(0, 0, CGRectGetWidth(collectionView.frame), [self sectionInnerFooterHeight:collectionView originalIndexPath:originalIndexPath]);
    return attributes;
}

- (BOOL)sectionInnerFooterShouldHighlight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath{
    return YES;
}

- (BOOL)sectionInnerFooterShouldSelect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return YES;
}

- (BOOL)sectionInnerFooterShouldDeselect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return YES;
}

- (void)sectionInnerFooterDidSelected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (void)sectionInnerFooterDidDeselected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (void)sectionInnerFooterWillDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

- (void)sectionInnerFooterDidEndDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    
}

@end

@implementation CJCollectionViewSectionData (PositionValue)

- (CGFloat)globalOffset {
    return self.sectionGlobalYOffset;
}

@end

@implementation CJCollectionViewFlowLayoutSectionData

- (CGFloat)sectionCellTopSeparatorHeight:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return 0.0;
}

- (CGFloat)sectionCellHeight:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(NSIndexPath *)originalIndexPath {
    return kCJCollectionViewSectionDefaultCellHeight;
}

- (CGFloat)sectionCellBottomSeparatorHeight:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return kCJCollectionViewSectionDefaultSeparatorHeaderFooterHeight;
}

- (void)prepareLayout:(UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    [super prepareLayout:collectionView forOriginalSection:originalSection];
    NSRange cellRange = [self sectionItemRange:collectionView forOriginalSection:originalSection];
    NSMutableArray *itemsAttributes = [NSMutableArray arrayWithCapacity:cellRange.length];
    CGFloat offset = 0.0;
    for (NSUInteger i = 0; i < cellRange.length; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cellRange.location + i inSection:originalSection];
        CGFloat topInset = [self sectionCellTopSeparatorHeight:collectionView forItem:i originalIndexPath:indexPath];
        CGFloat cellHeight = [self sectionCellHeight:collectionView forItem:i originalIndexPath:indexPath];
        CGFloat bottomInset = [self sectionCellBottomSeparatorHeight:collectionView forItem:i originalIndexPath:indexPath];
        offset += topInset;
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.originalFrame = CGRectMake(0, offset, CGRectGetWidth(collectionView.frame), cellHeight);
        [itemsAttributes addObject:attributes];
        offset += cellHeight;
        offset += bottomInset;
    }
    _totalCellHeight = offset;
    _preparedCellsLayout = [itemsAttributes copy];
}

- (CGFloat)sectionCellsHeight:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection forItems:(nonnull NSArray <NSNumber *> *)items originalIndexPaths:(nonnull NSArray <NSIndexPath *> *)originalIndexPaths {
    return _totalCellHeight;
}

- (nullable UICollectionViewLayoutAttributes *)sectionCellLayoutAttributes:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    if (item < self.preparedCellsLayout.count) {
        return self.preparedCellsLayout[item];
    }
    return nil;
}

@end
