//
//  CJCollectionViewTestSectionData.m
//  CJCollectionViewAdapter_Example
//
//  Created by cj1024 on 2020/12/11.
//  Copyright © 2020 cj1024. All rights reserved.
//

#import "CJCollectionViewTestSectionData.h"
#import <CJCollectionViewAdapter/CJCollectionViewAdapterCell.h>
#import <CJCarouselView/CJCarouselView.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

static NSString * const kCollectionViewTestSectionDataCellReuseIndetifier = @"collectionviewtestsectiondata.reuseindentifier.cell";
static NSString * const kCollectionViewTestSectionDataSeparatorHeaderFooterReuseIndetifier = @"collectionviewtestsectiondata.reuseindentifier.separatorheaderfooter";
static NSString * const kCollectionViewTestSectionDataInnerHeaderFooterReuseIndetifier = @"collectionviewtestsectiondata.reuseindentifier.innerheaderfooter";
static NSString * const kCollectionViewTestSectionDataCarouselCellReuseIndetifier = @"collectionviewtestsectiondata.reuseindentifier.carousel";

@interface CollectionViewTestSectionDataCellLayoutAttributes : UICollectionViewLayoutAttributes

@end

@implementation CollectionViewTestSectionDataCellLayoutAttributes

@end

@interface CollectionViewTestSectionDataSystemHeaderFooterView : UILabel

@end

@implementation CollectionViewTestSectionDataSystemHeaderFooterView

@end

@interface CJCarouselViewCollectionViewCell : CJNormalContentCollectionViewCell

@property(nonatomic, strong, readonly) CJCarouselView *carouselView;

@end

@interface CJCollectionViewTestSectionData () <CJCarouselViewDataSource, CJCarouselViewDelegate>

@property(nonatomic, copy, readonly, nullable) NSArray <UIColor *> *colors;
@property(nonatomic, strong, readonly, nullable) __kindof UICollectionViewLayoutAttributes *sectionSeparatorHeaderLayoutAttributes;
@property(nonatomic, strong, readonly, nullable) __kindof UICollectionViewLayoutAttributes *innerHeaderLayoutAttributes;
@property(nonatomic, copy, readonly, nullable) NSArray *itemsLayoutAttributes;
@property(nonatomic, strong, readonly, nullable) __kindof UICollectionViewLayoutAttributes *sectionSeparatorFooterLayoutAttributes;
@property(nonatomic, strong, readonly, nullable) __kindof UICollectionViewLayoutAttributes *innerFooterLayoutAttributes;
@property(nonatomic, strong, readwrite) CollectionViewTestSectionDataSystemHeaderFooterView *stickyHeaderView;
@property(nonatomic, strong, readwrite) CollectionViewTestSectionDataSystemHeaderFooterView *stickyFooterView;

@property(nonatomic, assign, readwrite) NSTimeInterval timestamp;
@property(nonatomic, assign, readwrite) BOOL hideSeparatorHeader;
@property(nonatomic, assign, readwrite) BOOL hideInnerHeader;
@property(nonatomic, assign, readwrite) BOOL hideSeparatorFooter;
@property(nonatomic, assign, readwrite) BOOL hideInnerFooter;

- (nullable CollectionViewTestSectionDataCellLayoutAttributes *)createSectionCellLayoutAttributes:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath;

@end

@implementation CJCollectionViewTestSectionData

- (CollectionViewTestSectionDataSystemHeaderFooterView *)stickyHeaderView {
    if (_stickyHeaderView == nil) {
        _stickyHeaderView = [[CollectionViewTestSectionDataSystemHeaderFooterView alloc] init];
        _stickyHeaderView.textAlignment = NSTextAlignmentCenter;
        _stickyHeaderView.textColor = [UIColor blackColor];
        _stickyHeaderView.font = [UIFont systemFontOfSize:14.0];
        _stickyHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _stickyHeaderView;
}

- (CollectionViewTestSectionDataSystemHeaderFooterView *)stickyFooterView {
    if (_stickyFooterView == nil) {
        _stickyFooterView = [[CollectionViewTestSectionDataSystemHeaderFooterView alloc] init];
        _stickyFooterView.textAlignment = NSTextAlignmentCenter;
        _stickyFooterView.textColor = [UIColor whiteColor];
        _stickyFooterView.font = [UIFont systemFontOfSize:14.0];
        _stickyFooterView.backgroundColor = [UIColor blackColor];
    }
    return _stickyFooterView;
}

- (instancetype)initWithCount:(NSUInteger)count itemsInOneRow:(NSUInteger)itemsInOneRow animated:(BOOL)animated {
    return [self initWithCount:count carouselViewHeader:NO itemsInOneRow:itemsInOneRow animated:animated];
}

- (instancetype)initWithCount:(NSUInteger)count carouselViewHeader:(BOOL)carouselViewHeader itemsInOneRow:(NSUInteger)itemsInOneRow animated:(BOOL)animated {
    self = [super init];
    if (self) {
        _count = count;
        _carouselViewHeader = carouselViewHeader;
        _itemsInOneRow = itemsInOneRow;
        _animated = animated;
        _timestamp = [[NSDate date] timeIntervalSince1970];
    }
    return self;
}

- (NSUInteger)safeItemsInOneRow {
    return self.itemsInOneRow == 0 ? 1 : self.itemsInOneRow;
}

- (void)registerReuseIndentifer:(UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    [super registerReuseIndentifer:collectionView forOriginalSection:originalSection];
    [collectionView registerClass:[CJPlainContentCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewTestSectionDataCellReuseIndetifier];
    [collectionView registerClass:[CJSeparatorCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewTestSectionDataSeparatorHeaderFooterReuseIndetifier];
    [collectionView registerClass:[CJPlainContentCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewTestSectionDataInnerHeaderFooterReuseIndetifier];
    [collectionView registerClass:[CJCarouselViewCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewTestSectionDataCarouselCellReuseIndetifier];
}

- (void)prepareData:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    [super prepareData:collectionView forOriginalSection:originalSection];
    NSMutableArray <UIColor *> *colors = [NSMutableArray <UIColor *> arrayWithCapacity:self.count];
    for (NSUInteger i = 0; i < self.count; i++) {
        [colors addObject:[UIColor colorWithRed:((arc4random() % 255) / 255.0) green:((arc4random() % 255) / 255.0) blue:((arc4random() % 255) / 255.0) alpha:1.0]];
    }
    _colors = [colors copy];
}

- (void)prepareLayout:(UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    [super prepareLayout:collectionView forOriginalSection:originalSection];

    if ([self hasSectionSeparatorHeader:collectionView forOriginalSection:originalSection]) {
        _sectionSeparatorHeaderLayoutAttributes = [self sectionSeparatorHeaderLayoutAttributes:collectionView originalIndexPath:[NSIndexPath indexPathForItem:[self sectionSeparatorHeaderIndex:collectionView forOriginalSection:originalSection] inSection:originalSection]];
    }
    if ([self hasSectionInnerHeader:collectionView forOriginalSection:originalSection]) {
        _innerHeaderLayoutAttributes = [self sectionInnerHeaderLayoutAttributes:collectionView originalIndexPath:[NSIndexPath indexPathForItem:[self sectionInnerHeaderIndex:collectionView forOriginalSection:originalSection] inSection:originalSection]];
    }
    if ([self hasSectionSeparatorFooter:collectionView forOriginalSection:originalSection]) {
        _sectionSeparatorFooterLayoutAttributes = [self sectionSeparatorFooterLayoutAttributes:collectionView originalIndexPath:[NSIndexPath indexPathForItem:[self sectionSeparatorFooterIndex:collectionView forOriginalSection:originalSection] inSection:originalSection]];
    }
    if ([self hasSectionInnerFooter:collectionView forOriginalSection:originalSection]) {
        _innerFooterLayoutAttributes = [self sectionInnerFooterLayoutAttributes:collectionView originalIndexPath:[NSIndexPath indexPathForItem:[self sectionInnerFooterIndex:collectionView forOriginalSection:originalSection] inSection:originalSection]];
    }
    NSRange cellRange = [self sectionItemRange:collectionView forOriginalSection:originalSection];
    NSMutableArray *itemsAttributes = [NSMutableArray arrayWithCapacity:self.count];
    for (NSUInteger i = 0; i < self.count; i++) {
        __kindof UICollectionViewLayoutAttributes *attributes = [self createSectionCellLayoutAttributes:collectionView forItem:i originalIndexPath:[NSIndexPath indexPathForItem:cellRange.location + i inSection:originalSection]];
        if (attributes) {
            [itemsAttributes addObject:attributes];
        } else {
            [itemsAttributes addObject:[NSNull null]];
        }
    }
    _itemsLayoutAttributes = [itemsAttributes copy];
}

- (CGFloat)sectionTopInset {
    return 20;
}

- (BOOL)hasSectionStickyHeader:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return YES;
}

- (nullable UIView *)sectionStickyHeader:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    self.stickyHeaderView.text = [NSString stringWithFormat:@"Stick Header For Section: %ld", (long)originalSection];
    return self.stickyHeaderView;
}

- (CGFloat)sectionStickyHeaderHeight:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return 22.0;
}

- (BOOL)hasSectionStickyFooter:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return YES;
}

- (nullable UIView *)sectionStickyFooter:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    self.stickyFooterView.text = [NSString stringWithFormat:@"Stick Footer For Section: %ld", (long)originalSection];
    return self.stickyFooterView;
}

- (CGFloat)sectionStickyFooterHeight:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return 22.0;
}

- (BOOL)hasSectionSeparatorHeader:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    if (!self.carouselViewHeader) {
        return !self.hideSeparatorHeader && self.count > 0;
    }
    return YES;
}

- (CGFloat)sectionSeparatorHeaderHeight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return self.carouselViewHeader ? 88.0 : 33.0;
}

- (nonnull __kindof UICollectionViewCell *)sectionSeparatorHeaderCell:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    if (self.carouselViewHeader) {
        CJCarouselViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewTestSectionDataCarouselCellReuseIndetifier forIndexPath:originalIndexPath];
        cell.carouselView.dataSource = self;
        cell.carouselView.delegate = self;
        cell.carouselView.autoScrollInterval = 3.f;
        [cell.carouselView smartUpdateLayoutInsetForPrePageExposed:30 nextPageExposed:30 pageGap:20];
        return cell;
    } else {
        CJSeparatorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewTestSectionDataSeparatorHeaderFooterReuseIndetifier forIndexPath:originalIndexPath];
        [cell updateAttributedSummary:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Separator Header For Section: %ld", (long)originalIndexPath.section]
                                                                      attributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                    NSFontAttributeName: [UIFont systemFontOfSize:12] }]];
        cell.backgroundView.backgroundColor = [UIColor grayColor];
        return cell;
    }
}

- (BOOL)hasSectionSeparatorFooter:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    if (!self.carouselViewHeader) {
        return !self.hideSeparatorFooter && self.count > 0;
    }
    return YES;
}

- (CGFloat)sectionSeparatorFooterHeight:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return 33.0;
}

- (nonnull __kindof UICollectionViewCell *)sectionSeparatorFooterCell:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    CJSeparatorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewTestSectionDataSeparatorHeaderFooterReuseIndetifier forIndexPath:originalIndexPath];
    [cell updateAttributedSummary:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Separator Footer For Section: %ld", (long)originalIndexPath.section]
                                                                  attributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                NSFontAttributeName: [UIFont systemFontOfSize:12] }]];
    cell.backgroundView.backgroundColor = [UIColor grayColor];
    return cell;
}

- (BOOL)hasSectionInnerHeader:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    if (!self.carouselViewHeader) {
        return !self.hideInnerHeader && self.count > 0;
    }
    return YES;
}

- (nonnull __kindof UICollectionViewCell *)sectionInnerHeaderCell:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    CJPlainContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewTestSectionDataInnerHeaderFooterReuseIndetifier forIndexPath:originalIndexPath];
    [cell updateSummary:[NSString stringWithFormat:@"Inner Header For Section: %ld", (long)originalIndexPath.section]];
    [cell updateShowRightArrow:YES
               rightArrowImage:[UIImage imageNamed:@"arrow_right_gray"]
           rightArrowAlignment:CJCollectionViewAdapterCellAlignmentMake(CJCollectionViewAdapterCellHorizontalAlignmentRight, CJCollectionViewAdapterCellVerticalAlignmentCenter)
              rightArrowOffset:CGPointMake(-15.0, 0.0)];
    cell.bottomSeparatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0);
    return cell;
}

- (BOOL)hasSectionInnerFooter:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    if (!self.carouselViewHeader) {
        return !self.hideInnerFooter && self.count > 0;
    }
    return YES;
}

- (nonnull __kindof UICollectionViewCell *)sectionInnerFooterCell:(nonnull UICollectionView *)collectionView originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    CJPlainContentCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewTestSectionDataInnerHeaderFooterReuseIndetifier forIndexPath:originalIndexPath];
    [cell updateSummary:[NSString stringWithFormat:@"Inner Footer For Section: %ld", (long)originalIndexPath.section]];
    [cell updateShowRightArrow:YES
               rightArrowImage:[UIImage imageNamed:@"arrow_right_gray"]
           rightArrowAlignment:CJCollectionViewAdapterCellAlignmentMake(CJCollectionViewAdapterCellHorizontalAlignmentRight, CJCollectionViewAdapterCellVerticalAlignmentCenter)
              rightArrowOffset:CGPointMake(-15.0, 0.0)];
    cell.bottomSeparatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0);
    return cell;
}

- (NSUInteger)sectionItemCount:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection {
    return self.count;
}

- (CGFloat)heightForItem {
    return self.animated ? 66.0 : kCJCollectionViewSectionDefaultCellHeight;
}

- (CGFloat)sectionCellsHeight:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection forItems:(nonnull NSArray <NSNumber *> *)items originalIndexPaths:(nonnull NSArray <NSIndexPath *> *)originalIndexPaths {
    if (self.safeItemsInOneRow == 1) {
        return [super sectionCellsHeight:collectionView forOriginalSection:originalSection forItems:items originalIndexPaths:originalIndexPaths];
    }
    NSUInteger rows = (self.count % self.safeItemsInOneRow == 0) ? self.count / self.safeItemsInOneRow : ceilf((CGFloat)self.count / (CGFloat)self.safeItemsInOneRow);
    return [self heightForItem] * rows;
}

- (CGFloat)sectionCellTopSeparatorHeight:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return 0.0;
}

- (CGFloat)sectionCellHeight:(UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(NSIndexPath *)originalIndexPath {
    return [self heightForItem];
}

- (CGFloat)sectionCellBottomSeparatorHeight:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    return 10.0;
}

- (nullable CollectionViewTestSectionDataCellLayoutAttributes *)createSectionCellLayoutAttributes:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    CollectionViewTestSectionDataCellLayoutAttributes *attributes = [CollectionViewTestSectionDataCellLayoutAttributes layoutAttributesForCellWithIndexPath:originalIndexPath];
    NSUInteger currentRow = (item % self.safeItemsInOneRow == 0) ? item / self.safeItemsInOneRow : floorf((CGFloat)item / (CGFloat)self.safeItemsInOneRow);
    attributes.originalFrame = CGRectMake(CGRectGetWidth(collectionView.bounds) * (item % self.safeItemsInOneRow) / self.safeItemsInOneRow, currentRow * [self heightForItem], CGRectGetWidth(collectionView.bounds) / self.safeItemsInOneRow, [self heightForItem]);
    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)sectionCellLayoutAttributes:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    if (self.safeItemsInOneRow == 1) {
        return [super sectionCellLayoutAttributes:collectionView forItem:item originalIndexPath:originalIndexPath];
    }
    if (item < self.itemsLayoutAttributes.count) {
        id attributes = self.itemsLayoutAttributes[item];
        if ([attributes isKindOfClass:[CollectionViewTestSectionDataCellLayoutAttributes class]]) {
            return attributes;
        }
    }
    return [self createSectionCellLayoutAttributes:collectionView forItem:item originalIndexPath:originalIndexPath];
}

- (nonnull __kindof UICollectionViewCell *)sectionCell:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    CJPlainContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewTestSectionDataCellReuseIndetifier forIndexPath:originalIndexPath];
    UIColor *color = self.colors.count > item ? self.colors[item] : nil;
    cell.backgroundView.backgroundColor = [color colorWithAlphaComponent:0.5];
    cell.selectedBackgroundView.backgroundColor = [color colorWithAlphaComponent:0.3];
    cell.bottomSeparatorColor = color;
    cell.topSeparatorColor = [UIColor clearColor];
    cell.rightSeparatorColor = color;
    cell.leftSeparatorColor = [UIColor clearColor];
    [cell updateAttributedSummary:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Section: %ld, Item: %ld", (long)originalIndexPath.section, (long)item]
                                                                  attributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                NSFontAttributeName: [UIFont systemFontOfSize:12.0] }]];
    NSUInteger rows = (self.count % self.safeItemsInOneRow == 0) ? self.count / self.safeItemsInOneRow : ceilf((CGFloat)self.count / (CGFloat)self.safeItemsInOneRow);
    NSUInteger currentRow = (item % self.safeItemsInOneRow == 0) ? item / self.safeItemsInOneRow : floorf((CGFloat)item / (CGFloat)self.safeItemsInOneRow);
    NSUInteger currentColumn = item % self.safeItemsInOneRow;
    if (currentRow == rows - 1) {
        cell.bottomSeparatorInset = UIEdgeInsetsZero;
    } else {
        if (self.safeItemsInOneRow == 1) {
            cell.bottomSeparatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0);
        } else {
            cell.bottomSeparatorInset = UIEdgeInsetsMake(0.0, (currentColumn == 0) ? 15.0 : 0.0, 0.0, (currentColumn == self.safeItemsInOneRow - 1) ? 15.0 : 0.0);
        }
    }
    if (currentColumn == self.safeItemsInOneRow - 1) {
        cell.rightSeparatorColor = [UIColor clearColor];
    } else {
        if (rows == 1) {
            cell.rightSeparatorColor = [UIColor clearColor];
        } else {
            cell.rightSeparatorInset = UIEdgeInsetsMake((currentRow == 0) ? 15.0 : 0.0, 0.0, (currentRow == rows - 1) ? 15.0 : 0.0, 0.0);
        }
    }
    cell.enableRippleHighlightStyle = YES;
    return cell;
}

- (void)sectionSeparatorHeaderDidSelected:(UICollectionView *)collectionView originalIndexPath:(NSIndexPath *)originalIndexPath {
    [collectionView deselectItemAtIndexPath:originalIndexPath animated:NO];
    if (self.carouselViewHeader) {
        return;
    }
    self.hideInnerHeader = !self.hideInnerHeader;
    if (self.animated) {
        [self.adapter sectionDataReloadInnerHeader:self animated:YES];
    } else {
        if (self.hideInnerHeader) {
            [self.adapter sectionDataDeleteInnerHeader:self animated:YES];
        } else {
            [self.adapter sectionDataInsertInnerHeader:self animated:YES];
        }
    }
}

- (void)sectionInnerHeaderDidSelected:(UICollectionView *)collectionView originalIndexPath:(NSIndexPath *)originalIndexPath {
    [collectionView deselectItemAtIndexPath:originalIndexPath animated:NO];
    if (self.carouselViewHeader) {
        [self.adapter scrollToSectionDataSeparatorHeaderTop:self animated:YES];
        return;
    }
    self.hideSeparatorHeader = !self.hideSeparatorHeader;
    if (self.animated) {
        [self.adapter sectionDataReloadSeparatorHeader:self animated:YES];
    } else {
        if (self.hideSeparatorHeader) {
            [self.adapter sectionDataDeleteSeparatorHeader:self animated:YES];
        } else {
            [self.adapter sectionDataInsertSeparatorHeader:self animated:YES];
        }
    }
}

- (void)sectionSeparatorFooterDidSelected:(UICollectionView *)collectionView originalIndexPath:(NSIndexPath *)originalIndexPath {
    [collectionView deselectItemAtIndexPath:originalIndexPath animated:NO];
    if (self.carouselViewHeader) {
        [self.adapter scrollToSectionDataInnerFooterTop:self animated:YES];
        return;
    }
    self.hideInnerFooter = !self.hideInnerFooter;
    if (self.animated) {
        [self.adapter sectionDataReloadInnerFooter:self animated:YES];
    } else {
        if (self.hideInnerFooter) {
            [self.adapter sectionDataDeleteInnerFooter:self animated:YES];
        } else {
            [self.adapter sectionDataInsertInnerFooter:self animated:YES];
        }
    }
}

- (void)sectionInnerFooterDidSelected:(UICollectionView *)collectionView originalIndexPath:(NSIndexPath *)originalIndexPath {
    [collectionView deselectItemAtIndexPath:originalIndexPath animated:NO];
    if (self.carouselViewHeader) {
        [self.adapter scrollToSectionDataSeparatorFooterTop:self animated:YES];
        return;
    }
    self.hideSeparatorFooter = !self.hideSeparatorFooter;
    if (self.animated) {
        [self.adapter sectionDataReloadSeparatorFooter:self animated:YES];
    } else {
        if (self.hideSeparatorFooter) {
            [self.adapter sectionDataDeleteSeparatorFooter:self animated:YES];
        } else {
            [self.adapter sectionDataInsertSeparatorFooter:self animated:YES];
        }
    }
}

- (BOOL)sectionCellShouldHighlight:(UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(NSIndexPath *)originalIndexPath {
    return item % 2 == 0;
}

- (BOOL)sectionCellShouldSelect:(UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(NSIndexPath *)originalIndexPath {
    return item % 2 == 0;
}

- (void)sectionCellDidSelected:(nonnull UICollectionView *)collectionView forItem:(NSUInteger)item originalIndexPath:(nonnull NSIndexPath *)originalIndexPath {
    [collectionView deselectItemAtIndexPath:originalIndexPath animated:NO];
    [self.adapter scrollToSectionDataTop:self item:item animated:YES];
}

- (void)sectionSeparatorHeaderWillDisplay:(UICollectionView *)collectionView cell:(CJCarouselViewCollectionViewCell *)cell originalIndexPath:(NSIndexPath *)originalIndexPath {
    if ([cell isKindOfClass:[CJCarouselViewCollectionViewCell class]]) {
        [cell.carouselView reloadData];
        [cell.carouselView startAutoScroll];
    }
}

- (void)sectionSeparatorHeaderDidEndDisplay:(UICollectionView *)collectionView cell:(CJCarouselViewCollectionViewCell *)cell originalIndexPath:(NSIndexPath *)originalIndexPath {
    if ([cell isKindOfClass:[CJCarouselViewCollectionViewCell class]]) {
        [cell.carouselView stopAutoScroll];
    }
}

- (CJCarouselViewPage *)carouselView:(CJCarouselView *)carouselView pageViewAtIndex:(NSUInteger)index reuseableView:(CJCarouselViewPage *)reuseableView {
    if (![reuseableView isKindOfClass:[CJCarouselViewPage class]]) {
        reuseableView = [[CJCarouselViewPage alloc] init];
    }
    reuseableView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [reuseableView.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://uploadbeta.com/api/pictures/random/?i=%@&t=%lld", @(index).stringValue, (long long)self.timestamp]]];
    return reuseableView;
}

- (NSUInteger)carouselViewNumberOfPages:(CJCarouselView *)carouselView {
    return self.count;
}

@end

@implementation CJCarouselViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _carouselView = [[CJCarouselView alloc] init];
        [self.contentView addSubview:self.carouselView];
        [self.carouselView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

@end
