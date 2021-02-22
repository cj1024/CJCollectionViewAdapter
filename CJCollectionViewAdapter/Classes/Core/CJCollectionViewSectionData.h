//
//  CJCollectionViewSectionData.h
//  CJCollectionViewAdapter
//
//  Created by cj1024 on 2020/10/10.
//  Copyright © 2020 cj1024. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat kCJCollectionViewSectionDefaultSeparatorHeaderFooterHeight;
extern const CGFloat kCJCollectionViewSectionDefaultInnerHeaderFooterHeight;
extern const CGFloat kCJCollectionViewSectionDefaultCellHeight;

@class CJCollectionViewAdapter;

@protocol ICJCollectionViewSectionBackground <NSObject>

@required
@property(nonatomic, strong, readwrite, null_resettable) UIView *contentView;
@property(nonatomic, assign, readwrite) BOOL excludeSeparatorHeader;
@property(nonatomic, assign, readwrite) BOOL excludeInnerHeader;
@property(nonatomic, assign, readwrite) BOOL excludeInnerFooter;
@property(nonatomic, assign, readwrite) BOOL excludeSeparatorFooter;
@property(nonatomic, assign, readwrite) UIEdgeInsets contentViewInset;

@end

/**
 *  顺序从上到下依次为
 *  StickyHeader（类似于TableView中驻留的Header）
 *  SeparatorHeader（一般用于做分割）
 *  InnerHeader（一般用于做标题）
 *  Cell Cell Cell
 *  Cell Cell Cell
 *  InnerFooter（一般用于做标题）
 *  SeparatorFooter（一般用于做分割）
 *  StickyFooter（类似于TableView中驻留的Footer）
 */
@interface CJCollectionViewSectionData : NSObject

@property(nonatomic, weak, readwrite, nullable) CJCollectionViewAdapter *adapter;

- (void)registerReuseIndentifer:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (void)prepareData:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (void)prepareLayout:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;

- (CGFloat)sectionTopInset;
- (CGFloat)sectionBottomInset;
- (CGFloat)sectionLeftInset; // Sticky|Separator 默认不生效
- (CGFloat)sectionRightInset; // Sticky|Separator 默认不生效

@property(nonatomic, assign, readwrite) BOOL stickyAllContentAsHeader;

@end

@interface CJCollectionViewSectionData (SectionHeader)

- (BOOL)hasSectionStickyHeader:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (nullable UIView *)sectionStickyHeader:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (CGFloat)sectionStickyHeaderHeight:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;

- (BOOL)hasSectionSeparatorHeader:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (CGFloat)sectionSeparatorHeaderHeight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (nonnull __kindof UICollectionViewCell *)sectionSeparatorHeaderCell:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (nullable UICollectionViewLayoutAttributes *)sectionSeparatorHeaderLayoutAttributes:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath; // Y坐标会被父类自动调整，默认是0
- (BOOL)sectionSeparatorHeaderShouldHighlight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (BOOL)sectionSeparatorHeaderShouldSelect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (BOOL)sectionSeparatorHeaderShouldDeselect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionSeparatorHeaderDidSelected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionSeparatorHeaderDidDeselected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionSeparatorHeaderWillDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionSeparatorHeaderDidEndDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;

- (BOOL)hasSectionInnerHeader:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (CGFloat)sectionInnerHeaderHeight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (nonnull __kindof UICollectionViewCell *)sectionInnerHeaderCell:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (nullable UICollectionViewLayoutAttributes *)sectionInnerHeaderLayoutAttributes:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath; // Y坐标会被父类自动调整，默认是0
- (BOOL)sectionInnerHeaderShouldHighlight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (BOOL)sectionInnerHeaderShouldSelect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (BOOL)sectionInnerHeaderShouldDeselect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionInnerHeaderDidSelected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionInnerHeaderDidDeselected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionInnerHeaderWillDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionInnerHeaderDidEndDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;

@end

@interface CJCollectionViewSectionData (SectionItem)

- (NSUInteger)sectionItemCount:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (CGFloat)sectionCellsHeight:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection forItems:(nonnull NSArray <NSNumber *> *)items originalIndexPaths:(nonnull NSArray <NSIndexPath *> *)originalIndexPaths;
- (nonnull __kindof UICollectionViewCell *)sectionCell:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (nullable UICollectionViewLayoutAttributes *)sectionCellLayoutAttributes:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath; // Y坐标会被父类自动调整，第0项默认是0，第1项默认是第0项Y的最大值，第2项默认是第1项Y的最大值，以此类推
- (BOOL)sectionCellShouldHighlight:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (BOOL)sectionCellShouldSelect:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (BOOL)sectionCellShouldDeselect:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionCellDidSelected:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionCellDidDeselected:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionCellWillDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionCellDidEndDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;

- (BOOL)shouldInvalidateCellsLayout:(nonnull UICollectionView *)collectionView forBoundsChange:(CGRect)fixedNewBounds wrappedNewBounds:(CGRect)wrappedNewBounds originalNewBounds:(CGRect)originalNewBounds forOriginalSection:(NSUInteger)originalSection;

@end

@interface CJCollectionViewSectionData (SectionFooter)

- (BOOL)hasSectionStickyFooter:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (nullable UIView *)sectionStickyFooter:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (CGFloat)sectionStickyFooterHeight:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;

- (BOOL)hasSectionSeparatorFooter:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (CGFloat)sectionSeparatorFooterHeight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (nonnull __kindof UICollectionViewCell *)sectionSeparatorFooterCell:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (nullable UICollectionViewLayoutAttributes *)sectionSeparatorFooterLayoutAttributes:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath; // Y坐标会被父类自动调整，默认是0
- (BOOL)sectionSeparatorFooterShouldHighlight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (BOOL)sectionSeparatorFooterShouldSelect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (BOOL)sectionSeparatorFooterShouldDeselect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionSeparatorFooterDidSelected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionSeparatorFooterDidDeselected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionSeparatorFooterWillDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionSeparatorFooterDidEndDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;

- (BOOL)hasSectionInnerFooter:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (CGFloat)sectionInnerFooterHeight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (nonnull __kindof UICollectionViewCell *)sectionInnerFooterCell:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (nullable UICollectionViewLayoutAttributes *)sectionInnerFooterLayoutAttributes:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath; // Y坐标会被父类自动调整，默认是0
- (BOOL)sectionInnerFooterShouldHighlight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (BOOL)sectionInnerFooterShouldSelect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (BOOL)sectionInnerFooterShouldDeselect:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionInnerFooterDidSelected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionInnerFooterDidDeselected:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionInnerFooterWillDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (void)sectionInnerFooterDidEndDisplay:(nonnull UICollectionView *)collectionView cell:(nonnull UICollectionViewCell *)cell originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;

@end

@interface CJCollectionViewSectionData (SectionBackground)

- (void)sectionBackground:(nonnull UICollectionView *)collectionView configBackgroundView:(nonnull UICollectionReusableView <ICJCollectionViewSectionBackground> *)backgroundViewContainer forOriginalSection:(NSUInteger)originalSection;

@end

@interface CJCollectionViewSectionData (PositionValue)

@property(nonatomic, assign, readonly) CGFloat globalOffset; // 可KVO

@end

/**
 *  像 TableView 一样只需提供每行 Cell 的高度，自动计算纵向布局 LayoutAttributes，单列布局支持给每一行增加上下边距
 */
@interface CJCollectionViewFlowLayoutSectionData : CJCollectionViewSectionData

@property(nonatomic, copy, readonly, nullable) NSArray <__kindof UICollectionViewLayoutAttributes *> *preparedCellsLayout;
@property(nonatomic, assign, readonly) CGFloat totalCellHeight;

- (BOOL)useGridLayout; // 是否启用多列布局

// 单列布局
- (CGFloat)sectionCellTopSeparatorHeight:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (CGFloat)sectionCellHeight:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;
- (CGFloat)sectionCellBottomSeparatorHeight:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;

// 多列布局
- (UIEdgeInsets)gridInset:(nonnull UICollectionView *)collectionView;
- (CGSize)gridItemSize:(nonnull UICollectionView *)collectionView;
- (CGFloat)gridItemHorizontalGap:(nonnull UICollectionView *)collectionView;
- (CGFloat)gridItemVerticalGap:(nonnull UICollectionView *)collectionView;

@end
