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
@property(nonatomic, strong, readwrite) NSNumber *sectionSeparatorHeaderHeightRecorder;
@property(nonatomic, assign, readwrite) NSInteger sectionInnerHeaderIndexRecorder;
@property(nonatomic, strong, readwrite) NSNumber *sectionInnerHeaderHeightRecorder;
@property(nonatomic, assign, readwrite) CGFloat sectionBottomInsetRecorder;
@property(nonatomic, strong, readwrite) NSNumber *sectionStickyFooterHeightRecorder;
@property(nonatomic, assign, readwrite) NSInteger sectionSeparatorFooterIndexRecorder;
@property(nonatomic, strong, readwrite) NSNumber *sectionSeparatorFooterHeightRecorder;
@property(nonatomic, assign, readwrite) NSInteger sectionInnerFooterIndexRecorder;
@property(nonatomic, strong, readwrite) NSNumber *sectionInnerFooterHeightRecorder;
@property(nonatomic, assign, readwrite) NSRange sectionItemsRangeRecorder;
@property(nonatomic, assign, readwrite) NSInteger sectionWrappedItemsCountRecorder;

@property(nonatomic, copy, readwrite, nullable) NSArray <UICollectionViewLayoutAttributes *> *cachedLayoutAttributes;

@property(nonatomic, weak, readwrite, nullable) UICollectionReusableView <ICJCollectionViewSectionBackground> *attachedBackgroundContainer;

@end

@implementation CJCollectionViewSectionData

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sectionSeparatorHeaderIndexRecorder = -1;
        self.sectionInnerHeaderIndexRecorder = -1;
        self.sectionSeparatorFooterIndexRecorder = -1;
        self.sectionInnerFooterIndexRecorder = -1;
        self.sectionItemsRangeRecorder = NSMakeRange(0, 0);
        self.sectionWrappedItemsCountRecorder = 0;
    }
    return self;
}

- (void)registerReuseIndentifer:(UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCJCollectionViewSectionDataDefaultCellReuseIndentifer];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCJCollectionViewSectionDataDefaultSeparatorHeaderFooterReuseIndentifer];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCJCollectionViewSectionDataDefaultInnerHeaderFooterReuseIndentifer];
}

- (void)prepareData:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    
}

- (void)prepareLayout:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    
}

- (void)setSectionGlobalYOffset:(CGFloat)sectionGlobalYOffset {
    BOOL changed = _sectionGlobalYOffset != sectionGlobalYOffset;
    if (changed) {
        [self willChangeValueForKey:@"globalOffset"];
        _sectionGlobalYOffset = sectionGlobalYOffset;
        [self didChangeValueForKey:@"globalOffset"];
    }
}

- (CGFloat)sectionTopInset {
    return 0.0;
}

- (CGFloat)sectionBottomInset {
    return 0.0;
}

- (CGFloat)sectionLeftInset {
    return 0.0;
}

- (CGFloat)sectionRightInset {
    return 0.0;
}

@end

@implementation CJCollectionViewSectionData (SectionHeader)

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
    attributes.originalFrame = CGRectMake(self.sectionLeftInset, 0, CGRectGetWidth(collectionView.frame) - self.sectionLeftInset - self.sectionRightInset, [self sectionInnerHeaderHeight:collectionView originalIndexPath:originalIndexPath]);
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
    attributes.originalFrame = CGRectMake(self.sectionLeftInset, item * kCJCollectionViewSectionDefaultCellHeight, CGRectGetWidth(collectionView.frame) - self.sectionLeftInset - self.sectionRightInset, kCJCollectionViewSectionDefaultCellHeight);
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
    attributes.originalFrame = CGRectMake(self.sectionLeftInset, 0, CGRectGetWidth(collectionView.frame) - self.sectionLeftInset - self.sectionRightInset, [self sectionInnerFooterHeight:collectionView originalIndexPath:originalIndexPath]);
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

@implementation CJCollectionViewSectionData (SectionBackground)

- (void)sectionBackground:(nonnull UICollectionView *)collectionView configBackgroundView:(nonnull UICollectionReusableView <ICJCollectionViewSectionBackground> *)backgroundViewContainer forOriginalSection:(NSUInteger)originalSection {
    
}

@end

@implementation CJCollectionViewSectionData (PositionValue)

- (CGFloat)globalOffset {
    return self.sectionGlobalYOffset;
}

@end

@implementation CJCollectionViewFlowLayoutSectionData

- (BOOL)useGridLayout {
    return [self layoutType] == CJCollectionViewFlowLayoutTypeGrid;
}

- (BOOL)useFlexLayout {
    return [self layoutType] == CJCollectionViewFlowLayoutTypeFlex;
}

- (CJCollectionViewFlowLayoutType)layoutType {
    return CJCollectionViewFlowLayoutTypeNormal;
}

- (CGFloat)sectionCellTopSeparatorHeight:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return 0.0;
}

- (CGFloat)sectionCellHeight:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(NSIndexPath *)originalIndexPath {
    return kCJCollectionViewSectionDefaultCellHeight;
}

- (CGFloat)sectionCellBottomSeparatorHeight:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return kCJCollectionViewSectionDefaultSeparatorHeaderFooterHeight;
}

- (UIEdgeInsets)gridInset:(nonnull UICollectionView *)collectionView {
    return UIEdgeInsetsZero;
}

- (CGSize)gridItemSize:(nonnull UICollectionView *)collectionView {
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - self.sectionLeftInset - self.sectionRightInset, kCJCollectionViewSectionDefaultCellHeight);
}

- (CGFloat)gridItemHorizontalGap:(nonnull UICollectionView *)collectionView {
    return 0;
}

- (CGFloat)gridItemVerticalGap:(nonnull UICollectionView *)collectionView {
    return kCJCollectionViewSectionDefaultSeparatorHeaderFooterHeight;
}

- (UIEdgeInsets)flexInset:(nonnull UICollectionView *)collectionView {
    return UIEdgeInsetsZero;
}

- (CGSize)flexItemSize:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item {
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - self.sectionLeftInset - self.sectionRightInset, kCJCollectionViewSectionDefaultCellHeight);
}

- (CGFloat)flexItemGap:(nonnull UICollectionView *)collectionView {
    return 0;
}

- (CJCollectionViewFlowLayoutFlexAlignItems)flexItemAlign:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item {
    return CJCollectionViewFlowLayoutFlexAlignItemsTop;
}

- (CGFloat)flexRowGap:(nonnull UICollectionView *)collectionView {
    return kCJCollectionViewSectionDefaultSeparatorHeaderFooterHeight;
}

- (CJCollectionViewFlowLayoutFlexAlignContent)flexContentAlign:(UICollectionView *)collectionView {
    return CJCollectionViewFlowLayoutFlexAlignContentLeft;
}

- (void)adjustFlexRowLayout:(NSArray <UICollectionViewLayoutAttributes *> *)rowLayouts
             collectionView:(UICollectionView *)collectionView
                  cellRange:(NSRange)cellRange
                maxRowWidth:(CGFloat)maxRowWidth
                   rowWidth:(CGFloat)rowWidth
                  rowHeight:(CGFloat)rowHeight {
    if (rowLayouts.count == 0) {
        return;
    }
    // 换行
    if (rowLayouts.count > 1) {
        // 超过一个，重新计算纵向布局
        for (UICollectionViewLayoutAttributes *itemLayout in rowLayouts) {
            NSUInteger item = itemLayout.indexPath.item - cellRange.location;
            CJCollectionViewFlowLayoutFlexAlignItems align = [self flexItemAlign:collectionView forItem:item];
            switch (align) {
                case CJCollectionViewFlowLayoutFlexAlignItemsCenter: {
                    itemLayout.originalFrame = CGRectOffset(itemLayout.originalFrame, 0., (rowHeight - itemLayout.originalFrame.size.height) / 2.);
                }
                    break;
                    
                case CJCollectionViewFlowLayoutFlexAlignItemsBottom: {
                    itemLayout.originalFrame = CGRectOffset(itemLayout.originalFrame, 0., (rowHeight - itemLayout.originalFrame.size.height));
                }
                    break;
                case CJCollectionViewFlowLayoutFlexAlignItemsStretch: {
                    itemLayout.originalFrame = CGRectMake(itemLayout.originalFrame.origin.x, itemLayout.originalFrame.origin.y, itemLayout.originalFrame.size.width, rowHeight);
                }
                    break;
                case CJCollectionViewFlowLayoutFlexAlignItemsTop:
                default: {
                    // 不用动
                }
                    break;
            }
        }
    }
    CGFloat widthGap = maxRowWidth - rowWidth;
    switch ([self flexContentAlign:collectionView]) {
        case CJCollectionViewFlowLayoutFlexAlignContentCenter: {
            CGFloat adjustX = widthGap / 2.;
            for (UICollectionViewLayoutAttributes *itemLayout in rowLayouts) {
                itemLayout.originalFrame = CGRectOffset(itemLayout.originalFrame, adjustX, 0.);
            }
        }
            break;
        case CJCollectionViewFlowLayoutFlexAlignContentRight: {
            for (UICollectionViewLayoutAttributes *itemLayout in rowLayouts) {
                itemLayout.originalFrame = CGRectOffset(itemLayout.originalFrame, widthGap, 0.);
            }
            
        }
            break;
        case CJCollectionViewFlowLayoutFlexAlignContentStretchGap: {
            if (rowLayouts.count <= 1) {
                // 单个的当居中处理
                CGFloat adjustX = widthGap / 2.;
                for (UICollectionViewLayoutAttributes *itemLayout in rowLayouts) {
                    itemLayout.originalFrame = CGRectOffset(itemLayout.originalFrame, adjustX, 0.);
                }
            } else {
                CGFloat adjustXUnit = widthGap / (CGFloat)(rowLayouts.count - 1);
                for (NSUInteger i = 1; i < rowLayouts.count; i++) {
                    UICollectionViewLayoutAttributes *itemLayout = rowLayouts[i];
                    itemLayout.originalFrame = CGRectOffset(itemLayout.originalFrame, adjustXUnit * i, 0.);
                }
            }
        }
            break;
    case CJCollectionViewFlowLayoutFlexAlignContentLeft:
    default: {
            // 不用动
        }
            break;
    }
}

- (void)prepareLayout:(UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    [super prepareLayout:collectionView forOriginalSection:originalSection];
    NSRange cellRange = [self sectionItemRange:collectionView forOriginalSection:originalSection];
    NSMutableArray *itemsAttributes = [NSMutableArray arrayWithCapacity:cellRange.length];
    if (self.useGridLayout) {
        UIEdgeInsets gridInset = [self gridInset:collectionView];
        CGSize itemSize = [self gridItemSize:collectionView];
        CGFloat gapX = [self gridItemHorizontalGap:collectionView];
        CGFloat gapY = [self gridItemVerticalGap:collectionView];
        CGFloat offsetX = 0.0;
        CGFloat maxWidth = CGRectGetWidth(collectionView.frame) - self.sectionLeftInset - self.sectionRightInset - gridInset.left - gridInset.right;
        CGFloat offsetY = 0.0;
        NSUInteger xCount = 0;
        CGFloat totalHeight = 0.0;
        for (NSUInteger i = 0; i < cellRange.length; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cellRange.location + i inSection:originalSection];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            if (xCount > 0 && offsetX + itemSize.width > maxWidth) {
                // 换行
                offsetX = 0.0;
                offsetY += (itemSize.height + gapY);
                xCount = 0;
            }
            attributes.originalFrame = CGRectMake(self.sectionLeftInset + gridInset.left + offsetX, gridInset.top + offsetY, itemSize.width, itemSize.height);
            offsetX += (itemSize.width + gapX);
            xCount++;
            totalHeight = MAX(totalHeight, CGRectGetMaxY(attributes.originalFrame));
            [itemsAttributes addObject:attributes];
        }
        _totalCellHeight = totalHeight + gridInset.bottom;
    } else if (self.useFlexLayout) {
        UIEdgeInsets flexInset = [self flexInset:collectionView];
        CGFloat gapX = [self flexItemGap:collectionView];
        CGFloat gapY = [self flexRowGap:collectionView];
        CGFloat offsetX = 0.0;
        CGFloat maxWidth = CGRectGetWidth(collectionView.frame) - self.sectionLeftInset - self.sectionRightInset - flexInset.left - flexInset.right;
        CGFloat offsetY = 0.0;
        NSUInteger xCount = 0;
        CGFloat totalHeight = 0.0;
        CGFloat rowHeight = 0.0;
        NSMutableArray <UICollectionViewLayoutAttributes *> *rowLayouts = [NSMutableArray array];
        for (NSUInteger i = 0; i < cellRange.length; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cellRange.location + i inSection:originalSection];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGSize itemSize = [self flexItemSize:collectionView forItem:i];
            if (xCount > 0 && offsetX + itemSize.width > maxWidth) {
                [self adjustFlexRowLayout:rowLayouts.copy
                           collectionView:collectionView
                                cellRange:cellRange
                              maxRowWidth:maxWidth
                                 rowWidth:(offsetX - gapX)
                                rowHeight:rowHeight];
                offsetX = 0.0;
                offsetY += (rowHeight + gapY);
                xCount = 0;
                rowHeight = 0.0;
                [rowLayouts removeAllObjects];
            }
            rowHeight = MAX(rowHeight, itemSize.height);
            attributes.originalFrame = CGRectMake(self.sectionLeftInset + flexInset.left + offsetX, flexInset.top + offsetY, itemSize.width, itemSize.height);
            offsetX += (itemSize.width + gapX);
            xCount++;
            totalHeight = MAX(totalHeight, CGRectGetMaxY(attributes.originalFrame));
            [itemsAttributes addObject:attributes];
            [rowLayouts addObject:attributes];
        }
        [self adjustFlexRowLayout:rowLayouts.copy
                   collectionView:collectionView
                        cellRange:cellRange
                      maxRowWidth:maxWidth
                         rowWidth:(offsetX - gapX)
                        rowHeight:rowHeight];
        _totalCellHeight = totalHeight + flexInset.bottom;
    } else {
        CGFloat offset = 0.0;
        for (NSUInteger i = 0; i < cellRange.length; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cellRange.location + i inSection:originalSection];
            CGFloat topInset = [self sectionCellTopSeparatorHeight:collectionView forItem:i originalIndexPath:indexPath];
            CGFloat cellHeight = [self sectionCellHeight:collectionView forItem:i originalIndexPath:indexPath];
            CGFloat bottomInset = [self sectionCellBottomSeparatorHeight:collectionView forItem:i originalIndexPath:indexPath];
            offset += topInset;
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.originalFrame = CGRectMake(self.sectionLeftInset, offset, CGRectGetWidth(collectionView.frame) - self.sectionLeftInset - self.sectionRightInset, cellHeight);
            [itemsAttributes addObject:attributes];
            offset += cellHeight;
            offset += bottomInset;
        }
        _totalCellHeight = offset;
    }
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
