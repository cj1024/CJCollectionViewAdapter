//
//  CJCollectionViewAdapter.h
//  CJCollectionViewAdapter
//
//  Created by cj1024 on 2020/10/10.
//  Copyright © 2020 cj1024. All rights reserved.
//

#import "CJCollectionViewSectionData.h"
#import "CJCollectionViewSectionData+Sealed.h"
#import "UICollectionViewLayoutAttributes+CJCollectionViewAdapter.h"

extern const CGFloat kCJCollectionViewAdapterStickyHeaderFooterZIndex;

@interface CJCollectionViewAdapter : NSObject

@property(nonatomic, weak, readonly, nullable) UICollectionView *bridgedCollectionView;
@property(nonatomic, strong, readonly, nonnull) UICollectionViewLayout *wrappedCollectionViewLayout; // 可以在init collectionview时直接传此layout，attach时也会替换为此layout
@property(nonatomic, copy, readonly, nonnull) NSArray <__kindof CJCollectionViewSectionData *> *sections;
@property(nonatomic, strong, readwrite, nullable) NSValue *stickyContentInset; // UIEdgeInset，有些刷新控件会改ContentInset造成sticky位置计算错误，这时需要指定一下
@property(nonatomic, weak, readwrite, nullable) id <UIScrollViewDelegate> scrollViewDelegate; // 指定接收UIScrollViewDelegate事件的对象

- (void)attachCollectionView:(nonnull UICollectionView *)collectionView;
- (void)deattachCollectionView:(nonnull UICollectionView *)collectionView;
- (void)updateSections:(nullable NSArray <__kindof CJCollectionViewSectionData *> *)sections;
- (nullable NSArray <__kindof CJCollectionViewSectionData *> *)sectionsInRect:(CGRect)rect;

@end

@interface CJCollectionViewAdapter (UICollectionViewLayoutBridge)

- (CGSize)collectionViewContentSize;
- (nullable NSArray <__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(nonnull NSIndexPath *)indexPath;
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath;
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;
- (void)prepareLayout;

@end

@interface CJCollectionViewAdapter (SectionUpdate)

- (void)collectionViewAdapterReload;

- (void)collectionViewPerformBatchUpdates:(void (^ __nullable)(void))updates completion:(void (^ __nullable)(BOOL finished))completion; // without animation
- (void)collectionViewPerformBatchUpdates:(void (^ __nullable)(void))updates completion:(void (^ __nullable)(BOOL finished))completion animated:(BOOL)animated;

- (void)sectionDataReload:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)sectionDataAtSectionReload:(NSUInteger)section animated:(BOOL)animated;

- (void)sectionDataDelete:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)sectionDataAtSectionDelete:(NSUInteger)section animated:(BOOL)animated;

- (void)sectionDataAppend:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)sectionDataInsert:(nonnull CJCollectionViewSectionData *)sectionData atSection:(NSUInteger)section animated:(BOOL)animated;

- (void)sectionDataDeleteSections:(nonnull NSArray <CJCollectionViewSectionData *> *)sectionDataList animated:(BOOL)animated;
- (void)sectionDataAtSectionsDelete:(nonnull NSArray <NSNumber *> *)sections animated:(BOOL)animated;

- (void)sectionDataAppendSections:(nonnull NSArray <CJCollectionViewSectionData *> *)sectionDataList animated:(BOOL)animated;
- (void)sectionDataInsertSections:(nonnull NSArray <CJCollectionViewSectionData *> *)sectionDataList atSection:(NSUInteger)section animated:(BOOL)animated;

@end

@interface CJCollectionViewAdapter (SectionChildrenUpdate)

- (void)sectionDataReloadSeparatorHeader:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)sectionDataInsertSeparatorHeader:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)sectionDataDeleteSeparatorHeader:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)sectionDataReloadInnerHeader:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)sectionDataInsertInnerHeader:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)sectionDataDeleteInnerHeader:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)sectionDataReload:(nonnull CJCollectionViewSectionData *)sectionData items:(nonnull NSArray <NSNumber *> *)items animated:(BOOL)animated;
- (void)sectionDataInsert:(nonnull CJCollectionViewSectionData *)sectionData items:(nonnull NSArray <NSNumber *> *)items animated:(BOOL)animated;
- (void)sectionDataDelete:(nonnull CJCollectionViewSectionData *)sectionData items:(nonnull NSArray <NSNumber *> *)items animated:(BOOL)animated;
- (void)sectionDataReloadAllItems:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)sectionDataReloadSeparatorFooter:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)sectionDataInsertSeparatorFooter:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)sectionDataDeleteSeparatorFooter:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)sectionDataReloadInnerFooter:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)sectionDataInsertInnerFooter:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)sectionDataDeleteInnerFooter:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;

@end

@interface CJCollectionViewAdapter (SectionChildrenFrame)

- (CGRect)sectionDataRecommendedSeparatorHeaderFrame:(nonnull CJCollectionViewSectionData *)sectionData;
- (CGRect)sectionDataRecommendedInnerHeaderFrame:(nonnull CJCollectionViewSectionData *)sectionData;
- (CGRect)sectionDataRecommendedFrame:(nonnull CJCollectionViewSectionData *)sectionData item:(NSUInteger)item;
- (CGRect)sectionDataRecommendedSeparatorFooterFrame:(nonnull CJCollectionViewSectionData *)sectionData;
- (CGRect)sectionDataRecommendedInnerFooterFrame:(nonnull CJCollectionViewSectionData *)sectionData;

@end

@interface CJCollectionViewAdapter (SectionChildrenScroll)

/**
 *  以下函数的滚动不会自动空出StickyHeader的位置（用的是UICollectionView的ScrollTo）
 */
- (void)scrollToSectionDataSeparatorHeader:(nonnull CJCollectionViewSectionData *)sectionData atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToSectionDataInnerHeader:(nonnull CJCollectionViewSectionData *)sectionData atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToSectionData:(nonnull CJCollectionViewSectionData *)sectionData item:(NSUInteger)item atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToSectionDataSeparatorFooter:(nonnull CJCollectionViewSectionData *)sectionData atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToSectionDataInnerFooter:(nonnull CJCollectionViewSectionData *)sectionData atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;

/**
 *  以下函数的滚动会自动空出StickyHeader的位置，但只支持Top
 */
- (void)scrollToSectionDataSeparatorHeaderTop:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)scrollToSectionDataInnerHeaderTop:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)scrollToSectionDataTop:(nonnull CJCollectionViewSectionData *)sectionData item:(NSUInteger)item animated:(BOOL)animated;
- (void)scrollToSectionDataSeparatorFooterTop:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;
- (void)scrollToSectionDataInnerFooterTop:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated;

/**
 *  以下函数的滚动会自动空出StickyHeader的位置，并增加指定偏移量，但只支持Top
 */
- (void)scrollToSectionDataSeparatorHeaderTop:(nonnull CJCollectionViewSectionData *)sectionData offset:(CGFloat)offset animated:(BOOL)animated;
- (void)scrollToSectionDataInnerHeaderTop:(nonnull CJCollectionViewSectionData *)sectionData offset:(CGFloat)offset animated:(BOOL)animated;
- (void)scrollToSectionDataTop:(nonnull CJCollectionViewSectionData *)sectionData item:(NSUInteger)item offset:(CGFloat)offset animated:(BOOL)animated;
- (void)scrollToSectionDataSeparatorFooterTop:(nonnull CJCollectionViewSectionData *)sectionData offset:(CGFloat)offset animated:(BOOL)animated;
- (void)scrollToSectionDataInnerFooterTop:(nonnull CJCollectionViewSectionData *)sectionData offset:(CGFloat)offset animated:(BOOL)animated;

@end
