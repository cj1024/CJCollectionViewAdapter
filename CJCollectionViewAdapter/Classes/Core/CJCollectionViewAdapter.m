//
//  CJCollectionViewAdapter.m
//  CJCollectionViewAdapter
//
//  Created by cj1024 on 2020/10/10.
//  Copyright © 2020 cj1024. All rights reserved.
//

#import "CJCollectionViewAdapter.h"
#import "CJCollectionViewSectionData+Private.h"

const CGFloat kCJCollectionViewAdapterStickyHeaderFooterZIndex = NSIntegerMax;

static NSString * const kCJCollectionViewAdapterDefaultCellReuseIndentifer = @"collectionviewadapter.reuseindentifier.cell";
static NSString * const kCJCollectionViewAdapterStickyHeaderKindKey = @"collectionviewadapter.kind.stickyheader";
static NSString * const kCJCollectionViewAdapterStickyHeaderReuseIndentifer = @"collectionviewadapter.reuseindentifier.stickyheader";
static NSString * const kCJCollectionViewAdapterStickyFooterKindKey = @"collectionviewadapter.kind.stickyfooter";
static NSString * const kCJCollectionViewAdapterStickyFooterReuseIndentifer = @"collectionviewadapter.reuseindentifier.stickyfooter";
static NSString * const kCJCollectionViewAdapterSectionBackgroundKindKey = @"collectionviewadapter.kind.sectionbackground";
static NSString * const kCJCollectionViewAdapterSectionBackgroundReuseIndentifer = @"collectionviewadapter.reuseindentifier.sectionbackground";
static NSString * const kCJCollectionViewAdapterDefaultKindKey = @"collectionviewadapter.kind.default";
static NSString * const kCJCollectionViewAdapterDefaultReuseIndentifer = @"collectionviewadapter.reuseindentifier.default";

@interface CJCollectionViewAdapterStickyHeaderFooterCell : UICollectionReusableView

@property(nonatomic, strong, readwrite) UIView *contentView;

@end

@implementation CJCollectionViewAdapterStickyHeaderFooterCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self setContentView:nil];
}

- (void)setContentView:(UIView *)contentView {
    if ([_contentView isKindOfClass:[UIView class]]) {
        [_contentView removeFromSuperview];
    }
    if ([contentView isKindOfClass:[UIView class]]) {
        [self addSubview:contentView];
        [self setNeedsLayout];
    }
    _contentView = contentView;
}

@end

@interface CJCollectionViewAdapterSectionBackgroundCell : UICollectionReusableView <ICJCollectionViewSectionBackground>

@property(nonatomic, weak, readwrite) CJCollectionViewSectionData *attachedSection;
@property(nonatomic, strong, readwrite) UIView *contentView;
@property(nonatomic, assign, readwrite) BOOL excludeSeparatorHeader;
@property(nonatomic, assign, readwrite) BOOL excludeInnerHeader;
@property(nonatomic, assign, readwrite) BOOL excludeInnerFooter;
@property(nonatomic, assign, readwrite) BOOL excludeSeparatorFooter;
@property(nonatomic, assign, readwrite) UIEdgeInsets contentViewInset;

@end

@implementation CJCollectionViewAdapterSectionBackgroundCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentFrame = UIEdgeInsetsInsetRect(self.bounds, self.contentViewInset);
    CGFloat topInset = 0.;
    if (self.excludeInnerHeader) {
        topInset = self.attachedSection.sectionSeparatorHeaderHeightRecorder.doubleValue + self.attachedSection.sectionInnerHeaderHeightRecorder.doubleValue;
    } else if (self.excludeSeparatorHeader) {
        topInset = self.attachedSection.sectionSeparatorHeaderHeightRecorder.doubleValue;
    }
    CGFloat bottomInset = 0.;
    if (self.excludeInnerFooter) {
        bottomInset = self.attachedSection.sectionSeparatorFooterHeightRecorder.doubleValue + self.attachedSection.sectionInnerFooterHeightRecorder.doubleValue;
    } else if (self.excludeSeparatorFooter) {
        bottomInset = self.attachedSection.sectionSeparatorFooterHeightRecorder.doubleValue;
    }
    contentFrame = UIEdgeInsetsInsetRect(contentFrame, UIEdgeInsetsMake(topInset, 0., bottomInset, 0.));
    self.contentView.frame = contentFrame;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self setAttachedSection:nil];
    [self setExcludeSeparatorHeader:NO];
    [self setExcludeInnerHeader:NO];
    [self setExcludeInnerFooter:NO];
    [self setExcludeSeparatorFooter:NO];
    [self setContentView:nil];
    [self setContentViewInset:UIEdgeInsetsZero];
}

- (void)setAttachedSection:(CJCollectionViewSectionData *)attachedSection {
    if (_attachedSection) {
        if (_attachedSection.attachedBackgroundContainer == self) {
            _attachedSection.attachedBackgroundContainer = nil;
        }
    }
    if (attachedSection) {
        attachedSection.attachedBackgroundContainer = self;
    }
    _attachedSection = attachedSection;
}

- (void)setContentView:(UIView *)contentView {
    if ([_contentView isKindOfClass:[UIView class]]) {
        [_contentView removeFromSuperview];
    }
    if ([contentView isKindOfClass:[UIView class]]) {
        [self addSubview:contentView];
        [self setNeedsLayout];
    }
    _contentView = contentView;
}

- (void)setExcludeSeparatorHeader:(BOOL)excludeSeparatorHeader {
    _excludeSeparatorHeader = excludeSeparatorHeader;
    [self setNeedsLayout];
}

- (void)setExcludeInnerHeader:(BOOL)excludeInnerHeader {
    _excludeInnerHeader = excludeInnerHeader;
    [self setNeedsLayout];
}

- (void)setExcludeInnerFooter:(BOOL)excludeInnerFooter {
    _excludeInnerFooter = excludeInnerFooter;
    [self setNeedsLayout];
}

- (void)setExcludeSeparatorFooter:(BOOL)excludeSeparatorFooter {
    _excludeSeparatorFooter = excludeSeparatorFooter;
    [self setNeedsLayout];
}

- (void)setContentViewInset:(UIEdgeInsets)contentViewInset {
    _contentViewInset = contentViewInset;
    [self setNeedsLayout];
}

@end

@interface CJCollectionViewAdapterViewLayout : UICollectionViewLayout

@property(nonatomic, weak, readwrite, nullable) CJCollectionViewAdapter *bridgedAdapter;

@end

@implementation CJCollectionViewAdapterViewLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return [self.bridgedAdapter shouldInvalidateLayoutForBoundsChange:newBounds];
}

- (CGSize)collectionViewContentSize {
    return [self.bridgedAdapter collectionViewContentSize];
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.bridgedAdapter layoutAttributesForElementsInRect:rect];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self.bridgedAdapter layoutAttributesForItemAtIndexPath:indexPath];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self.bridgedAdapter layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}

- (void)prepareLayout {
    [super prepareLayout];
    return [self.bridgedAdapter prepareLayout];
}

@end

@interface CJCollectionViewAdapter ()

@property(nonatomic, weak, readwrite, nullable) UICollectionView *bridgedCollectionView;
@property(nonatomic, strong, readwrite, nonnull) CJCollectionViewAdapterViewLayout *internalWrappedCollectionViewLayout;
@property(nonatomic, strong, readwrite) NSArray <__kindof CJCollectionViewSectionData *> *internalSections;

- (NSUInteger)safeSectionCount;
- (void)attachSectionData:(__kindof CJCollectionViewSectionData *_Null_unspecified)sectionData;
- (void)deattachSectionData:(__kindof CJCollectionViewSectionData *_Null_unspecified)sectionData;

@end

@interface CJCollectionViewAdapter (UICollectionViewDataSource) <UICollectionViewDataSource>

@end

@interface CJCollectionViewAdapter (UICollectionViewDelegate) <UICollectionViewDelegate>

@end

@implementation CJCollectionViewAdapter

- (void)setBridgedCollectionView:(UICollectionView *)bridgedCollectionView {
    _bridgedCollectionView = bridgedCollectionView;
    [bridgedCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCJCollectionViewAdapterDefaultCellReuseIndentifer];
    [bridgedCollectionView registerClass:[CJCollectionViewAdapterStickyHeaderFooterCell class] forSupplementaryViewOfKind:kCJCollectionViewAdapterStickyHeaderKindKey withReuseIdentifier:kCJCollectionViewAdapterStickyHeaderReuseIndentifer];
    [bridgedCollectionView registerClass:[CJCollectionViewAdapterStickyHeaderFooterCell class] forSupplementaryViewOfKind:kCJCollectionViewAdapterStickyFooterKindKey withReuseIdentifier:kCJCollectionViewAdapterStickyFooterReuseIndentifer];
    [bridgedCollectionView registerClass:[CJCollectionViewAdapterSectionBackgroundCell class] forSupplementaryViewOfKind:kCJCollectionViewAdapterSectionBackgroundKindKey withReuseIdentifier:kCJCollectionViewAdapterSectionBackgroundReuseIndentifer];
    [bridgedCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:kCJCollectionViewAdapterDefaultKindKey withReuseIdentifier:kCJCollectionViewAdapterDefaultReuseIndentifer];
}

- (nonnull CJCollectionViewAdapterViewLayout *)internalWrappedCollectionViewLayout {
    if (_internalWrappedCollectionViewLayout == nil) {
        CJCollectionViewAdapterViewLayout *layout = [[CJCollectionViewAdapterViewLayout alloc] init];
        layout.bridgedAdapter = self;
        _internalWrappedCollectionViewLayout = layout;
    }
    return _internalWrappedCollectionViewLayout;
}

- (nonnull UICollectionViewLayout *)wrappedCollectionViewLayout {
    return self.internalWrappedCollectionViewLayout;
}

- (NSArray <__kindof CJCollectionViewSectionData *> *)sections {
    return self.internalSections == nil ? @[] : self.internalSections;
}

- (NSUInteger)safeSectionCount {
    return self.sections.count;
}

- (void)attachSectionData:(__kindof CJCollectionViewSectionData *_Null_unspecified)sectionData {
    sectionData.adapter = self;
}

- (void)deattachSectionData:(__kindof CJCollectionViewSectionData *_Null_unspecified)sectionData {
    if (sectionData.adapter == self) {
        sectionData.adapter = nil;
    }
}

- (void)attachCollectionView:(nonnull UICollectionView *)collectionView {
    if ([collectionView isKindOfClass:[UICollectionView class]]) {
        if (collectionView.collectionViewLayout != self.wrappedCollectionViewLayout) {
            collectionView.collectionViewLayout = self.wrappedCollectionViewLayout;
        }
        collectionView.dataSource = self;
        collectionView.delegate = self;
        self.bridgedCollectionView = collectionView;
    }
}

- (void)deattachCollectionView:(UICollectionView *)collectionView {
    if (self.bridgedCollectionView == collectionView) {
        if (collectionView.dataSource == self) {
            collectionView.dataSource = nil;
        }
        if (collectionView.delegate == self) {
            collectionView.delegate = nil;
        }
        self.bridgedCollectionView = nil;
    }
}

- (void)updateSections:(nullable NSArray <__kindof CJCollectionViewSectionData *> *)sections {
    for (CJCollectionViewSectionData *section in self.internalSections) {
        [self deattachSectionData:section];
    }
    NSArray <__kindof CJCollectionViewSectionData *> *internalSections = [sections copy];
    [internalSections enumerateObjectsUsingBlock:^(__kindof CJCollectionViewSectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self attachSectionData:obj];
        [obj registerReuseIndentifer:self.bridgedCollectionView forOriginalSection:idx];
        [obj prepareData:self.bridgedCollectionView forOriginalSection:idx];
    }];
    self.internalSections = internalSections;
    [self.bridgedCollectionView reloadData];
}

- (nullable NSArray <__kindof CJCollectionViewSectionData *> *)sectionsInRect:(CGRect)rect {
    __block NSMutableArray <__kindof CJCollectionViewSectionData *> *result = [NSMutableArray <__kindof CJCollectionViewSectionData *> arrayWithCapacity:3];
    [self.internalSections enumerateObjectsUsingBlock:^(__kindof CJCollectionViewSectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.bridgedCollectionView.numberOfSections) {
            CGRect sectionRect = CGRectMake(rect.origin.x, obj.sectionGlobalYOffset - obj.sectionTopInsetRecorder - (obj.sectionStickyHeaderHeightRecorder ? obj.sectionStickyHeaderHeightRecorder.doubleValue : 0.0), rect.size.width, obj.sectionHeightRecorder + obj.sectionTopInsetRecorder + obj.sectionBottomInsetRecorder + (obj.sectionStickyHeaderHeightRecorder ? obj.sectionStickyHeaderHeightRecorder.doubleValue : 0.0) + (obj.sectionStickyFooterHeightRecorder ? obj.sectionStickyFooterHeightRecorder.doubleValue : 0.0));
            if (CGRectIntersectsRect(rect, sectionRect)) {
                [result addObject:obj];
            } else {
                if (result.count > 0) {
                    *stop = YES;
                }
            }
        }
    }];
    return result;
}

- (void)setStickyContentInset:(NSValue *)stickyContentInset {
    _stickyContentInset = stickyContentInset;
    [self.internalWrappedCollectionViewLayout invalidateLayout];
}

@end

@implementation CJCollectionViewAdapter (UICollectionViewLayoutBridge)

- (CGSize)collectionViewContentSize {
    CGFloat width = CGRectGetWidth(self.bridgedCollectionView.frame);
    __block CGFloat height = 0.0;
    [self.internalSections enumerateObjectsUsingBlock:^(__kindof CJCollectionViewSectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.sectionTopInsetRecorder > 0.0) {
            height += obj.sectionTopInsetRecorder;
        }
        if (obj.sectionStickyHeaderHeightRecorder) {
            height += obj.sectionStickyHeaderHeightRecorder.doubleValue;
        }
        height += obj.sectionHeightRecorder;
        if (obj.sectionStickyFooterHeightRecorder) {
            height += obj.sectionStickyFooterHeightRecorder.doubleValue;
        }
        if (obj.sectionBottomInsetRecorder > 0.0) {
            height += obj.sectionBottomInsetRecorder;
        }
    }];
    CGRect threshold = UIEdgeInsetsInsetRect(self.bridgedCollectionView.frame, self.bridgedCollectionView.contentInset);
    return CGSizeMake(MAX(width, threshold.size.width), MAX(height, threshold.size.height));
}

- (nullable NSArray <__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    __block NSMutableArray <__kindof UICollectionViewLayoutAttributes *> *attributes = [NSMutableArray <__kindof UICollectionViewLayoutAttributes *> array];
    NSArray <__kindof CJCollectionViewSectionData *> *sectionsInRect = [self sectionsInRect:rect];
    [sectionsInRect enumerateObjectsUsingBlock:^(__kindof CJCollectionViewSectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj.cachedLayoutAttributes isKindOfClass:[NSArray class]]) {
            obj.cachedLayoutAttributes = [self sectionLayoutAttributes:obj];
        }
        for (UICollectionViewLayoutAttributes *attribute in obj.cachedLayoutAttributes) {
            if (CGRectIntersectsRect(attribute.frame, rect)) {
                [attributes addObject:attribute];
            }
        }
    }];
    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section < self.safeSectionCount) {
        __kindof CJCollectionViewSectionData *data = self.internalSections[indexPath.section];
        UICollectionViewLayoutAttributes *attributes = [data collectionViewWrappedLayoutAttributes:self.bridgedCollectionView forWrappedItem:indexPath.item originalIndexPath:indexPath];
        if ([attributes isKindOfClass:[UICollectionViewLayoutAttributes class]]) {
            attributes.frame = CGRectOffset(attributes.frame, 0, data.sectionGlobalYOffset);
            if (data.stickyAllContentAsHeader) {
                attributes.originalFrameForScroll = attributes.frame;
                CGFloat offsetTop = self.bridgedCollectionView.contentOffset.y + self.bridgedCollectionView.contentInset.top;
                CGFloat headerHeight = data.sectionStickyHeaderHeightRecorder.doubleValue;
                if (offsetTop <= data.sectionGlobalYOffset - headerHeight) {
                    // 还未到顶，不需要处理
                } else if (offsetTop <= data.sectionGlobalYOffset + data.sectionHeightRecorder - headerHeight) {
                    attributes.frame = CGRectOffset(attributes.frame, 0, offsetTop - data.sectionGlobalYOffset + headerHeight); // 吸顶
                    attributes.zIndex = self.safeSectionCount * -2 + indexPath.section * 2 + 1;
                } else {
                    attributes.frame = CGRectOffset(attributes.frame, 0, data.sectionHeightRecorder); // 向上移出
                    attributes.zIndex = self.safeSectionCount * -2 + indexPath.section * 2 + 1;
                }
            }
            return attributes;
        }
    }
    return nil;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section < self.safeSectionCount) {
        __kindof CJCollectionViewSectionData *data = self.internalSections[indexPath.section];
        UIEdgeInsets contentInset = [self.stickyContentInset isKindOfClass:[NSValue class]] ? self.stickyContentInset.UIEdgeInsetsValue : self.bridgedCollectionView.contentInset;
        CGFloat offsetTop = self.bridgedCollectionView.contentOffset.y + contentInset.top;
        CGFloat offsetBottom = self.bridgedCollectionView.contentOffset.y + CGRectGetHeight(self.bridgedCollectionView.frame) - contentInset.bottom;
        CGFloat headerHeight = data.sectionStickyHeaderHeightRecorder.doubleValue;
        CGFloat footerHeight = data.sectionStickyFooterHeightRecorder.doubleValue;
        if ([elementKind isEqualToString:kCJCollectionViewAdapterStickyHeaderKindKey]) {
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kCJCollectionViewAdapterStickyHeaderKindKey withIndexPath:indexPath];
            attributes.zIndex = kCJCollectionViewAdapterStickyHeaderFooterZIndex - (self.safeSectionCount - indexPath.section);
            // TODO sticky位置计算需要优化
            if (offsetTop <= data.sectionGlobalYOffset - headerHeight) {
                attributes.frame = CGRectMake(0, data.sectionGlobalYOffset - headerHeight, CGRectGetWidth(self.bridgedCollectionView.frame), headerHeight); // 还未到顶
            } else if (offsetTop <= data.sectionGlobalYOffset + data.sectionHeightRecorder - headerHeight) {
                attributes.frame = CGRectMake(0, offsetTop, CGRectGetWidth(self.bridgedCollectionView.frame), headerHeight); // 钉在顶部
            } else {
                attributes.frame = CGRectMake(0, data.sectionGlobalYOffset + data.sectionHeightRecorder - headerHeight, CGRectGetWidth(self.bridgedCollectionView.frame), headerHeight); // section 向上滚出
            }
            return attributes;
        } else if ([elementKind isEqualToString:kCJCollectionViewAdapterStickyFooterKindKey]) {
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kCJCollectionViewAdapterStickyFooterKindKey withIndexPath:indexPath];
            attributes.zIndex = kCJCollectionViewAdapterStickyHeaderFooterZIndex - (self.safeSectionCount - indexPath.section);
            if (offsetBottom <= data.sectionGlobalYOffset + footerHeight) {
                attributes.frame = CGRectMake(0, data.sectionGlobalYOffset, CGRectGetWidth(self.bridgedCollectionView.frame), footerHeight); // 还未到底
            } else if (offsetBottom <= data.sectionGlobalYOffset + data.sectionHeightRecorder + footerHeight) {
                attributes.frame = CGRectMake(0, offsetBottom - footerHeight, CGRectGetWidth(self.bridgedCollectionView.frame), footerHeight); // 钉在底部
            } else {
                attributes.frame = CGRectMake(0, data.sectionGlobalYOffset + data.sectionHeightRecorder, CGRectGetWidth(self.bridgedCollectionView.frame), footerHeight); // section 向下滚出
            }
            return attributes;
        } else if ([elementKind isEqualToString:kCJCollectionViewAdapterSectionBackgroundKindKey]) {
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kCJCollectionViewAdapterSectionBackgroundKindKey withIndexPath:indexPath];
            attributes.frame = CGRectMake(0, data.sectionGlobalYOffset, CGRectGetWidth(self.bridgedCollectionView.frame), data.sectionHeightRecorder);
            if (data.stickyAllContentAsHeader) {
                attributes.originalFrameForScroll = attributes.frame;
                CGFloat offsetTop = self.bridgedCollectionView.contentOffset.y + self.bridgedCollectionView.contentInset.top;
                if (offsetTop <= data.sectionGlobalYOffset - headerHeight) {
                    // 还未到顶，不需要处理
                } else if (offsetTop <= data.sectionGlobalYOffset + data.sectionHeightRecorder - headerHeight) {
                    attributes.frame = CGRectOffset(attributes.frame, 0, offsetTop - data.sectionGlobalYOffset + headerHeight); // 吸顶
                } else {
                    attributes.frame = CGRectOffset(attributes.frame, 0, data.sectionHeightRecorder); // 向上移出
                }
            }
            attributes.zIndex = self.safeSectionCount * -2 + indexPath.section * 2;
            return attributes;
        }
    }
    return nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect currentFrame = self.bridgedCollectionView.frame;
    __block BOOL result = !CGSizeEqualToSize(newBounds.size, currentFrame.size);
    if (!result) {
        NSArray <__kindof CJCollectionViewSectionData *> *sectionsInRect = [self sectionsInRect:newBounds];
        [sectionsInRect enumerateObjectsUsingBlock:^(__kindof CJCollectionViewSectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger index = [self.internalSections indexOfObject:obj];
            result = result || obj.stickyAllContentAsHeader || [obj hasSectionStickyHeader:self.bridgedCollectionView forOriginalSection:index] || [obj hasSectionStickyFooter:self.bridgedCollectionView forOriginalSection:index] || [obj collectionView:self.bridgedCollectionView shouldInvalidateLayoutForWrappedBoundsChange:CGRectOffset(newBounds, 0, -obj.sectionGlobalYOffset) originalNewBounds:newBounds forOriginalSection:index];
            if (result) {
                *stop = YES;
            }
        }];
    }
    return result;
}

- (NSArray <UICollectionViewLayoutAttributes *> *)sectionLayoutAttributes:(CJCollectionViewSectionData *)section {
    if (![self.internalSections containsObject:section]) {
        return @[];
    }
    NSInteger index = [self.internalSections indexOfObject:section];
    if (index >= self.bridgedCollectionView.numberOfSections) {
        return @[];
    }
    __block NSMutableArray <__kindof UICollectionViewLayoutAttributes *> *attributes = [NSMutableArray <__kindof UICollectionViewLayoutAttributes *> array];
    if (section.sectionStickyHeaderHeightRecorder) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForSupplementaryViewOfKind:kCJCollectionViewAdapterStickyHeaderKindKey atIndexPath:[NSIndexPath indexPathForItem:0 inSection:index]];
        if (attribute && ![attributes containsObject:attribute]) {
            [attributes addObject:attribute];
        }
    }
    NSInteger numberOfItems = [self.bridgedCollectionView numberOfItemsInSection:index];
    for (NSInteger i = 0; i < numberOfItems; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:index];
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        if (attribute && ![attributes containsObject:attribute]) {
            [attributes addObject:attribute];
        }
    }
    if (numberOfItems > 0) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForSupplementaryViewOfKind:kCJCollectionViewAdapterSectionBackgroundKindKey atIndexPath:[NSIndexPath indexPathForItem:0 inSection:index]];
        if (attribute && ![attributes containsObject:attribute]) {
            [attributes addObject:attribute];
        }
    }
    if (section.sectionStickyFooterHeightRecorder) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForSupplementaryViewOfKind:kCJCollectionViewAdapterStickyFooterKindKey atIndexPath:[NSIndexPath indexPathForItem:0 inSection:index]];
        if (attribute && ![attributes containsObject:attribute]) {
            [attributes addObject:attribute];
        }
    }
    return attributes;
}

- (void)prepareLayout {
    __block CGFloat yOffset = 0.0;
    [self.internalSections enumerateObjectsUsingBlock:^(__kindof CJCollectionViewSectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj prepareLayout:self.bridgedCollectionView forOriginalSection:idx];
        CGFloat topInset = [obj sectionTopInset];
        if (topInset > 0.0) {
            yOffset += topInset;
            obj.sectionTopInsetRecorder = topInset;
        } else {
            obj.sectionTopInsetRecorder = 0.0;
        }
        if ([obj hasSectionStickyHeader:self.bridgedCollectionView forOriginalSection:idx]) {
            CGFloat stickyHeaderHeight = MAX(0.0, [obj sectionStickyHeaderHeight:self.bridgedCollectionView forOriginalSection:idx]);
            obj.sectionStickyHeaderHeightRecorder = @(stickyHeaderHeight);
            yOffset += stickyHeaderHeight;
        } else {
            obj.sectionStickyHeaderHeightRecorder = nil;
        }
        obj.sectionGlobalYOffset = yOffset;
        obj.sectionHeightRecorder = [obj sectionHeight:self.bridgedCollectionView forOriginalSection:idx];
        yOffset += obj.sectionHeightRecorder;
        if ([obj hasSectionStickyFooter:self.bridgedCollectionView forOriginalSection:idx]) {
            CGFloat stickyFooterHeight = MAX(0.0, [obj sectionStickyFooterHeight:self.bridgedCollectionView forOriginalSection:idx]);
            obj.sectionStickyFooterHeightRecorder = @(stickyFooterHeight);
            yOffset += stickyFooterHeight;
        } else {
            obj.sectionStickyFooterHeightRecorder = nil;
        }
        CGFloat bottomInset = [obj sectionBottomInset];
        if (bottomInset > 0.0) {
            yOffset += bottomInset;
            obj.sectionBottomInsetRecorder = bottomInset;
        } else {
            obj.sectionBottomInsetRecorder = 0.0;
        }
        obj.cachedLayoutAttributes = nil;
    }];
}

- (void)prepareLayoutForSectionsInsertBeginAtIndex:(NSUInteger)beginIndex length:(NSUInteger)length {
    NSUInteger endIndex = beginIndex + length;
    CGFloat increasedHeight = 0.0;
    CGFloat yOffset = 0.0;
    for (NSUInteger idx = beginIndex; idx < self.internalSections.count; idx++) {
        __kindof CJCollectionViewSectionData * _Nonnull obj = self.internalSections[idx];
        if (idx < endIndex) {
            [obj prepareLayout:self.bridgedCollectionView forOriginalSection:idx];
            CGFloat topInset = [obj sectionTopInset];
            if (topInset > 0.0) {
                yOffset += topInset;
                obj.sectionTopInsetRecorder = topInset;
            } else {
                obj.sectionTopInsetRecorder = 0.0;
            }
            if ([obj hasSectionStickyHeader:self.bridgedCollectionView forOriginalSection:idx]) {
                CGFloat stickyHeaderHeight = MAX(0.0, [obj sectionStickyHeaderHeight:self.bridgedCollectionView forOriginalSection:idx]);
                obj.sectionStickyHeaderHeightRecorder = @(stickyHeaderHeight);
                yOffset += stickyHeaderHeight;
                increasedHeight += stickyHeaderHeight;
            } else {
                obj.sectionStickyHeaderHeightRecorder = nil;
            }
            obj.sectionGlobalYOffset = yOffset;
            obj.sectionHeightRecorder = [obj sectionHeight:self.bridgedCollectionView forOriginalSection:idx];
            yOffset += obj.sectionHeightRecorder;
            increasedHeight += obj.sectionHeightRecorder;
            if ([obj hasSectionStickyFooter:self.bridgedCollectionView forOriginalSection:idx]) {
                CGFloat stickyFooterHeight = MAX(0.0, [obj sectionStickyFooterHeight:self.bridgedCollectionView forOriginalSection:idx]);
                obj.sectionStickyFooterHeightRecorder = @(stickyFooterHeight);
                yOffset += stickyFooterHeight;
                increasedHeight += stickyFooterHeight;
            } else {
                obj.sectionStickyFooterHeightRecorder = nil;
            }
        } else {
            obj.sectionGlobalYOffset = obj.sectionGlobalYOffset + increasedHeight;
        }
        CGFloat bottomInset = [obj sectionBottomInset];
        if (bottomInset > 0.0) {
            yOffset += bottomInset;
            obj.sectionBottomInsetRecorder = bottomInset;
        } else {
            obj.sectionBottomInsetRecorder = 0.0;
        }
        obj.cachedLayoutAttributes = nil;
    }
}

@end

@implementation CJCollectionViewAdapter (UICollectionViewDataSource)

- (NSUInteger)numberOfSectionsInCollectionView:(nonnull UICollectionView *)collectionView {
    return self.safeSectionCount;
}

- (NSUInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSUInteger)section {
    if (section < self.safeSectionCount) {
        CJCollectionViewSectionData *sectionData = self.internalSections[section];
        sectionData.sectionSeparatorHeaderIndexRecorder = [sectionData sectionSeparatorHeaderIndex:collectionView forOriginalSection:section];
        sectionData.sectionInnerHeaderIndexRecorder = [sectionData sectionInnerHeaderIndex:collectionView forOriginalSection:section];
        sectionData.sectionSeparatorFooterIndexRecorder = [sectionData sectionSeparatorFooterIndex:collectionView forOriginalSection:section];
        sectionData.sectionInnerFooterIndexRecorder = [sectionData sectionInnerFooterIndex:collectionView forOriginalSection:section];
        sectionData.sectionItemsRangeRecorder = [sectionData sectionItemRange:collectionView forOriginalSection:section];
        sectionData.sectionWrappedItemsCountRecorder = [sectionData collectionViewWrappedItemCount:collectionView forOriginalSection:section];
        return sectionData.sectionWrappedItemsCountRecorder;
    } else {
        return 0;
    }
}

- (__kindof UICollectionViewCell * _Nonnull)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section < self.safeSectionCount) {
        return [self.internalSections[indexPath.section] collectionViewWrappedCell:collectionView forWrappedItem:indexPath.item originalIndexPath:indexPath];
    } else {
        return [collectionView dequeueReusableCellWithReuseIdentifier:kCJCollectionViewAdapterDefaultCellReuseIndentifer forIndexPath:indexPath];
    }
}

- (nonnull UICollectionReusableView *)collectionView:(nonnull UICollectionView *)collectionView viewForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section < self.safeSectionCount) {
        if ([kind isEqualToString:kCJCollectionViewAdapterStickyHeaderKindKey]) {
            CJCollectionViewAdapterStickyHeaderFooterCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kCJCollectionViewAdapterStickyHeaderKindKey withReuseIdentifier:kCJCollectionViewAdapterStickyHeaderReuseIndentifer forIndexPath:indexPath];
            [cell setContentView:[self.internalSections[indexPath.section] sectionStickyHeader:collectionView forOriginalSection:indexPath.section]];
            return cell;
        } else if ([kind isEqualToString:kCJCollectionViewAdapterStickyFooterKindKey]) {
            CJCollectionViewAdapterStickyHeaderFooterCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kCJCollectionViewAdapterStickyFooterKindKey withReuseIdentifier:kCJCollectionViewAdapterStickyFooterReuseIndentifer forIndexPath:indexPath];
            [cell setContentView:[self.internalSections[indexPath.section] sectionStickyFooter:collectionView forOriginalSection:indexPath.section]];
            return cell;
        } else if ([kind isEqualToString:kCJCollectionViewAdapterSectionBackgroundKindKey]) {
            CJCollectionViewAdapterSectionBackgroundCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kCJCollectionViewAdapterSectionBackgroundKindKey withReuseIdentifier:kCJCollectionViewAdapterSectionBackgroundReuseIndentifer forIndexPath:indexPath];
            cell.attachedSection = [self.internalSections objectAtIndex:indexPath.section];
            [cell.attachedSection sectionBackground:collectionView configBackgroundView:cell forOriginalSection:indexPath.section];
            return cell;
        }
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:kCJCollectionViewAdapterDefaultKindKey withReuseIdentifier:kCJCollectionViewAdapterDefaultReuseIndentifer forIndexPath:indexPath];
}

@end

@implementation CJCollectionViewAdapter (UICollectionViewDelegate)

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section < self.safeSectionCount) {
        return [self.internalSections[indexPath.section] collectionViewWrappedCellShouldHighlight:collectionView forWrappedItem:indexPath.item originalIndexPath:indexPath];
    }
    return YES;
}

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section < self.safeSectionCount) {
        return [self.internalSections[indexPath.section] collectionViewWrappedCellShouldSelect:collectionView forWrappedItem:indexPath.item originalIndexPath:indexPath];
    }
    return YES;
}

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section < self.safeSectionCount) {
        return [self.internalSections[indexPath.section] collectionViewWrappedCellShouldDeselect:collectionView forWrappedItem:indexPath.item originalIndexPath:indexPath];
    }
    return YES;
}

- (void)collectionView:(nonnull UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section < self.safeSectionCount) {
        return [self.internalSections[indexPath.section] collectionViewWrappedCellDidSelected:collectionView forWrappedItem:indexPath.item originalIndexPath:indexPath];
    }
}

- (void)collectionView:(nonnull UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section < self.safeSectionCount) {
        return [self.internalSections[indexPath.section] collectionViewWrappedCellDidDeselected:collectionView forWrappedItem:indexPath.item originalIndexPath:indexPath];
    }
}

- (void)collectionView:(nonnull UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section < self.safeSectionCount) {
        return [self.internalSections[indexPath.section] collectionView:collectionView wrappedCellWillDisplay:cell forWrappedItem:indexPath.item originalIndexPath:indexPath];
    }
}

- (void)collectionView:(nonnull UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section < self.safeSectionCount) {
        return [self.internalSections[indexPath.section] collectionView:collectionView wrappedCellDidEndDisplay:cell forWrappedItem:indexPath.item originalIndexPath:indexPath];
    }
}

- (void)collectionView:(nonnull UICollectionView *)collectionView willDisplaySupplementaryView:(nonnull UICollectionReusableView *)view forElementKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath {
    
}

- (void)collectionView:(nonnull UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollViewDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(nonnull UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.scrollViewDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(nonnull UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.scrollViewDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.scrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(nonnull UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.scrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidZoom:(nonnull UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.scrollViewDelegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(nonnull UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.scrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(nonnull UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.scrollViewDelegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}

- (void)scrollViewWillBeginZooming:(nonnull UIScrollView *)scrollView withView:(nullable UIView *)view {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.scrollViewDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(nonnull UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale; {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.scrollViewDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(nonnull UIScrollView *)scrollView; {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.scrollViewDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(nonnull UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.scrollViewDelegate scrollViewDidScrollToTop:scrollView];
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(nonnull UIScrollView *)scrollView {
    if (@available(iOS 11.0, *)) {
        if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidChangeAdjustedContentInset:)]) {
            [self.scrollViewDelegate scrollViewDidChangeAdjustedContentInset:scrollView];
        }
    }
}

@end

@implementation CJCollectionViewAdapter (SectionUpdate)

- (void)performCollectionViewUpdate:(dispatch_block_t)updateAction withAnimation:(BOOL)animated {
    BOOL oldAnimated = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:animated];
    if (updateAction) {
        updateAction();
    }
    [UIView setAnimationsEnabled:oldAnimated];
}

- (void)collectionViewAdapterReload {
    [self.bridgedCollectionView reloadData];
    [self.wrappedCollectionViewLayout invalidateLayout];
}

- (void)collectionViewPerformBatchUpdates:(void (^ __nullable)(void))updates completion:(void (^ __nullable)(BOOL finished))completion {
    [self.bridgedCollectionView performBatchUpdates:updates completion:completion];
}

- (void)sectionDataReload:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        if (section < self.bridgedCollectionView.numberOfSections) {
            [self sectionDataAtSectionReload:section animated:animated];
        } else {
            [self.bridgedCollectionView reloadData];
        }
    }
}

- (void)sectionDataAtSectionReload:(NSUInteger)section animated:(BOOL)animated {
    if (section < self.internalSections.count) {
        [self prepareLayout];
        [self performCollectionViewUpdate:^{
            [self.bridgedCollectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
        } withAnimation:animated];
    }
}

- (void)sectionDataDelete:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    if ([sectionData isKindOfClass:[CJCollectionViewSectionData class]]) {
        [self sectionDataDeleteSections:@[ sectionData ] animated:animated];
    }
}

- (void)sectionDataAtSectionDelete:(NSUInteger)section animated:(BOOL)animated {
    [self sectionDataAtSectionsDelete:@[ [NSNumber numberWithUnsignedInteger:section] ] animated:animated];
}

- (void)sectionDataAppend:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    if ([sectionData isKindOfClass:[CJCollectionViewSectionData class]]) {
        [self sectionDataAppendSections:@[ sectionData ] animated:animated];
    }
}

- (void)sectionDataInsert:(nonnull CJCollectionViewSectionData *)sectionData atSection:(NSUInteger)section animated:(BOOL)animated {
    if ([sectionData isKindOfClass:[CJCollectionViewSectionData class]]) {
        [self sectionDataInsertSections:@[ sectionData ] atSection:section animated:animated];
    }
}

- (void)sectionDataDeleteSections:(nonnull NSArray <CJCollectionViewSectionData *> *)sectionDataList animated:(BOOL)animated {
    __block NSMutableArray <NSNumber *> *sections = [NSMutableArray <NSNumber *> arrayWithCapacity:sectionDataList.count];
    [sectionDataList enumerateObjectsUsingBlock:^(CJCollectionViewSectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.internalSections containsObject:obj]) {
            [sections addObject:[NSNumber numberWithInteger:[self.internalSections indexOfObject:obj]]];
        }
    }];
    if (sections.count > 0) {
        [self sectionDataAtSectionsDelete:sections animated:animated];
    }
}

- (void)sectionDataAtSectionsDelete:(nonnull NSArray <NSNumber *> *)sections animated:(BOOL)animated {
    __block NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    __block NSMutableArray <__kindof CJCollectionViewSectionData *> *finalSections = [self.internalSections mutableCopy];
    __block BOOL needReloadAll = NO;
    [sections enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger section = [obj integerValue];
        if (section < self.internalSections.count) {
            __kindof CJCollectionViewSectionData *sectionData = self.internalSections[section];
            [finalSections removeObject:sectionData];
            if (section < self.bridgedCollectionView.numberOfSections) {
                [indexSet addIndexes:[NSIndexSet indexSetWithIndex:section]];
            } else {
                needReloadAll = YES;
            }
        }
    }];
    if (needReloadAll) {
        self.internalSections = [finalSections copy];
        [self prepareLayout];
        [self performCollectionViewUpdate:^{
            [self.bridgedCollectionView reloadData];
        } withAnimation:animated];
    } else if (indexSet.count > 0) {
        self.internalSections = [finalSections copy];
        [self prepareLayout];
        [self performCollectionViewUpdate:^{
            [self.bridgedCollectionView deleteSections:indexSet];
        } withAnimation:animated];
    }
}

- (void)sectionDataAppendSections:(nonnull NSArray <CJCollectionViewSectionData *> *)sectionDataList animated:(BOOL)animated {
    [self sectionDataInsertSections:sectionDataList atSection:self.internalSections.count animated:animated];
}

- (void)sectionDataInsertSections:(nonnull NSArray <CJCollectionViewSectionData *> *)sectionDataList atSection:(NSUInteger)section animated:(BOOL)animated {
    if (section <= self.internalSections.count) {
        __block NSMutableArray <__kindof CJCollectionViewSectionData *> *sections = [self.internalSections mutableCopy];
        __block NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        [sectionDataList enumerateObjectsUsingBlock:^(CJCollectionViewSectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger realIndex = idx + section;
            [self attachSectionData:obj];
            [obj registerReuseIndentifer:self.bridgedCollectionView forOriginalSection:realIndex];
            [obj prepareData:self.bridgedCollectionView forOriginalSection:realIndex];
            [sections insertObject:obj atIndex:realIndex];
            [indexSet addIndexes:[NSIndexSet indexSetWithIndex:realIndex]];
        }];
        if (indexSet.count > 0) {
            self.internalSections = [sections copy];
            [self prepareLayoutForSectionsInsertBeginAtIndex:section length:sectionDataList.count];
            [self performCollectionViewUpdate:^{
                [self.bridgedCollectionView insertSections:indexSet];
            } withAnimation:animated];
        }
    }
}

@end

@implementation CJCollectionViewAdapter (SectionChildrenUpdate)

- (void)sectionItemsChanged:(nonnull CJCollectionViewSectionData *)sectionData inCollectionView:(nonnull UICollectionView *)collectionView section:(NSUInteger)section {
    [self updateSectionRecordInfo:sectionData inCollectionView:collectionView section:section];
}

- (void)updateSectionRecordInfo:(nonnull CJCollectionViewSectionData *)sectionData inCollectionView:(nonnull UICollectionView *)collectionView section:(NSUInteger)section {
    sectionData.sectionSeparatorHeaderIndexRecorder = [sectionData sectionSeparatorHeaderIndex:collectionView forOriginalSection:section];
    sectionData.sectionInnerHeaderIndexRecorder = [sectionData sectionInnerHeaderIndex:collectionView forOriginalSection:section];
    sectionData.sectionSeparatorFooterIndexRecorder = [sectionData sectionSeparatorFooterIndex:collectionView forOriginalSection:section];
    sectionData.sectionInnerFooterIndexRecorder = [sectionData sectionInnerFooterIndex:collectionView forOriginalSection:section];
    sectionData.sectionItemsRangeRecorder = [sectionData sectionItemRange:collectionView forOriginalSection:section];
    sectionData.sectionWrappedItemsCountRecorder = [sectionData collectionViewWrappedItemCount:collectionView forOriginalSection:section];
}

- (void)updateItemWithOldIndex:(NSInteger)oldItem index:(NSInteger)item totalItemsCount:(NSInteger)numberOfItems inSection:(NSInteger)section animated:(BOOL)animated {
    if (item < 0 && oldItem >= 0 && numberOfItems > oldItem) {
        // Delete
        [self prepareLayout];
        [self performCollectionViewUpdate:^{
            [self.bridgedCollectionView deleteItemsAtIndexPaths:@[ [NSIndexPath indexPathForItem:oldItem inSection:section] ]];
        } withAnimation:animated];
    } else if (item >= 0 && oldItem < 0 && numberOfItems >= item) {
        // Insert
        [self prepareLayout];
        [self performCollectionViewUpdate:^{
            [self.bridgedCollectionView insertItemsAtIndexPaths:@[ [NSIndexPath indexPathForItem:item inSection:section] ]];
        } withAnimation:animated];
    } else if (item >= 0 && item == oldItem && numberOfItems > item) {
        [self prepareLayout];
        [self performCollectionViewUpdate:^{
            [self.bridgedCollectionView reloadItemsAtIndexPaths:@[ [NSIndexPath indexPathForItem:item inSection:section] ]];
        } withAnimation:animated];
    } else {
        [self sectionDataAtSectionReload:section animated:animated];
    }
}

- (void)sectionDataReloadSeparatorHeader:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    if (self.bridgedCollectionView && [self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger numberOfItems = [self.bridgedCollectionView numberOfItemsInSection:section];
        NSInteger oldNumberOfItems = sectionData.sectionWrappedItemsCountRecorder;
        if (section < self.bridgedCollectionView.numberOfSections && numberOfItems == oldNumberOfItems) {
            NSInteger item = [sectionData sectionSeparatorHeaderIndex:self.bridgedCollectionView forOriginalSection:section];
            NSInteger oldItem = sectionData.sectionSeparatorHeaderIndexRecorder;
            [self updateItemWithOldIndex:oldItem index:item totalItemsCount:numberOfItems inSection:section animated:animated];
        } else {
            [self prepareLayout];
            [self performCollectionViewUpdate:^{
                [self.bridgedCollectionView reloadData];
            } withAnimation:animated];
        }
        [self sectionItemsChanged:sectionData inCollectionView:self.bridgedCollectionView section:section];
    }
}

- (void)sectionDataInsertSeparatorHeader:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    [self sectionDataReloadSeparatorHeader:sectionData animated:animated];
}

- (void)sectionDataDeleteSeparatorHeader:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    [self sectionDataReloadSeparatorHeader:sectionData animated:animated];
}

- (void)sectionDataReloadInnerHeader:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger numberOfItems = [self.bridgedCollectionView numberOfItemsInSection:section];
        NSInteger oldNumberOfItems = sectionData.sectionWrappedItemsCountRecorder;
        if (section < self.bridgedCollectionView.numberOfSections && numberOfItems == oldNumberOfItems) {
            NSInteger item = [sectionData sectionInnerHeaderIndex:self.bridgedCollectionView forOriginalSection:section];
            NSInteger oldItem = sectionData.sectionInnerHeaderIndexRecorder;
            [self updateItemWithOldIndex:oldItem index:item totalItemsCount:numberOfItems inSection:section animated:animated];
        } else {
            [self prepareLayout];
            [self performCollectionViewUpdate:^{
                [self.bridgedCollectionView reloadData];
            } withAnimation:animated];
        }
        [self sectionItemsChanged:sectionData inCollectionView:self.bridgedCollectionView section:section];
    }
}

- (void)sectionDataInsertInnerHeader:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    [self sectionDataReloadInnerHeader:sectionData animated:animated];
}

- (void)sectionDataDeleteInnerHeader:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    [self sectionDataReloadInnerHeader:sectionData animated:animated];
}

- (void)sectionDataReload:(nonnull CJCollectionViewSectionData *)sectionData items:(nonnull NSArray <NSNumber *> *)items animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger numberOfItems = [self.bridgedCollectionView numberOfItemsInSection:section];
        NSInteger oldNumberOfItems = sectionData.sectionWrappedItemsCountRecorder;
        if (section < self.bridgedCollectionView.numberOfSections && numberOfItems == oldNumberOfItems) {
            NSRange itemRange = [sectionData sectionItemRange:self.bridgedCollectionView forOriginalSection:section];
            NSRange oldItemRange = sectionData.sectionItemsRangeRecorder;
            BOOL needReloadAll = NO;
            NSMutableArray <NSIndexPath *> *indexes = [NSMutableArray <NSIndexPath *> arrayWithCapacity:items.count];
            if (oldItemRange.location == itemRange.location && oldItemRange.length == itemRange.length) {
                for (NSNumber *item in items) {
                    if ([item integerValue] >= 0 && [item integerValue] < itemRange.length && numberOfItems > [item integerValue] + itemRange.location) {
                        [indexes addObject:[NSIndexPath indexPathForItem:[item integerValue] + itemRange.location inSection:section]];
                    } else {
                        needReloadAll = YES;
                        break;
                    }
                }
            } else {
                needReloadAll = YES;
            }
            if (needReloadAll) {
                [self prepareLayout];
                [self performCollectionViewUpdate:^{
                    [self.bridgedCollectionView reloadData];
                } withAnimation:animated];
            } else {
                if (indexes.count > 0) {
                    [self prepareLayout];
                    [self performCollectionViewUpdate:^{
                        [self.bridgedCollectionView reloadItemsAtIndexPaths:indexes];
                    } withAnimation:animated];
                }
            }
        } else {
            [self prepareLayout];
            [self performCollectionViewUpdate:^{
                [self.bridgedCollectionView reloadData];
            } withAnimation:animated];
        }
        [self sectionItemsChanged:sectionData inCollectionView:self.bridgedCollectionView section:section];
    }
}

- (void)sectionDataInsert:(nonnull CJCollectionViewSectionData *)sectionData items:(nonnull NSArray <NSNumber *> *)items animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger numberOfItems = [self.bridgedCollectionView numberOfItemsInSection:section];
        NSInteger oldNumberOfItems = sectionData.sectionWrappedItemsCountRecorder;
        if (section < self.bridgedCollectionView.numberOfSections && numberOfItems == oldNumberOfItems) {
            NSRange itemRange = [sectionData sectionItemRange:self.bridgedCollectionView forOriginalSection:section];
            NSRange oldItemRange = sectionData.sectionItemsRangeRecorder;
            BOOL needReloadAll = NO;
            NSMutableArray <NSIndexPath *> *indexes = [NSMutableArray <NSIndexPath *> arrayWithCapacity:items.count];
            if (oldItemRange.location == itemRange.location && oldItemRange.length == itemRange.length) {
                for (NSNumber *item in items) {
                    if ([item integerValue] >= 0 && [item integerValue] < itemRange.length && numberOfItems >= [item integerValue] + itemRange.location) {
                        [indexes addObject:[NSIndexPath indexPathForItem:[item integerValue] + itemRange.location inSection:section]];
                    } else {
                        needReloadAll = YES;
                        break;
                    }
                }
            } else {
                needReloadAll = YES;
            }
            if (needReloadAll) {
                [self prepareLayout];
                [self performCollectionViewUpdate:^{
                    [self.bridgedCollectionView reloadData];
                } withAnimation:animated];
            } else {
                if (indexes.count > 0) {
                    [self prepareLayout];
                    [self performCollectionViewUpdate:^{
                        [self.bridgedCollectionView insertItemsAtIndexPaths:indexes];
                    } withAnimation:animated];
                }
            }
        } else {
            [self prepareLayout];
            [self performCollectionViewUpdate:^{
                [self.bridgedCollectionView reloadData];
            } withAnimation:animated];
        }
        [self sectionItemsChanged:sectionData inCollectionView:self.bridgedCollectionView section:section];
    }
}

- (void)sectionDataDelete:(nonnull CJCollectionViewSectionData *)sectionData items:(nonnull NSArray <NSNumber *> *)items animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger numberOfItems = [self.bridgedCollectionView numberOfItemsInSection:section];
        NSInteger oldNumberOfItems = sectionData.sectionWrappedItemsCountRecorder;
        if (section < self.bridgedCollectionView.numberOfSections && numberOfItems == oldNumberOfItems) {
            NSRange itemRange = [sectionData sectionItemRange:self.bridgedCollectionView forOriginalSection:section];
            NSRange oldItemRange = sectionData.sectionItemsRangeRecorder;
            BOOL needReloadAll = NO;
            NSMutableArray <NSIndexPath *> *indexes = [NSMutableArray <NSIndexPath *> arrayWithCapacity:items.count];
            if (oldItemRange.location == itemRange.location && oldItemRange.length == itemRange.length) {
                for (NSNumber *item in items) {
                    if ([item integerValue] >= 0 && [item integerValue] < itemRange.length && numberOfItems > [item integerValue] + itemRange.location) {
                        [indexes addObject:[NSIndexPath indexPathForItem:[item integerValue] + itemRange.location inSection:section]];
                    } else {
                        needReloadAll = YES;
                        break;
                    }
                }
            } else {
                needReloadAll = YES;
            }
            if (needReloadAll) {
                [self prepareLayout];
                [self performCollectionViewUpdate:^{
                    [self.bridgedCollectionView reloadData];
                } withAnimation:animated];
            } else {
                if (indexes.count > 0) {
                    [self prepareLayout];
                    [self performCollectionViewUpdate:^{
                        [self.bridgedCollectionView deleteItemsAtIndexPaths:indexes];
                    } withAnimation:animated];
                }
            }
        } else {
            [self prepareLayout];
            [self performCollectionViewUpdate:^{
                [self.bridgedCollectionView reloadData];
            } withAnimation:animated];
        }
        [self sectionItemsChanged:sectionData inCollectionView:self.bridgedCollectionView section:section];
    }
}

- (void)sectionDataReloadAllItems:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger numberOfItems = [self.bridgedCollectionView numberOfItemsInSection:section];
        NSInteger oldNumberOfItems = sectionData.sectionWrappedItemsCountRecorder;
        if (section < self.bridgedCollectionView.numberOfSections && numberOfItems == oldNumberOfItems) {
            NSRange itemRange = [sectionData sectionItemRange:self.bridgedCollectionView forOriginalSection:section];
            NSRange oldItemRange = sectionData.sectionItemsRangeRecorder;
            BOOL needReloadAll = NO;
            NSMutableArray <NSIndexPath *> *indexesOld = [NSMutableArray <NSIndexPath *> arrayWithCapacity:oldItemRange.length];
            NSMutableArray <NSIndexPath *> *indexesNew = [NSMutableArray <NSIndexPath *> arrayWithCapacity:itemRange.length];
            if (oldItemRange.location == itemRange.location) {
                for (NSUInteger i = 0; i < oldItemRange.length; i++) {
                    [indexesOld addObject:[NSIndexPath indexPathForItem:(oldItemRange.location + i) inSection:section]];
                }
                for (NSUInteger i = 0; i < itemRange.length; i++) {
                    [indexesNew addObject:[NSIndexPath indexPathForItem:(itemRange.location + i) inSection:section]];
                }
            } else {
                needReloadAll = YES;
            }
            if (needReloadAll) {
                [self prepareLayout];
                [self performCollectionViewUpdate:^{
                    [self.bridgedCollectionView reloadData];
                } withAnimation:animated];
            } else {
                [self prepareLayout];
                [self performCollectionViewUpdate:^{
                    [self.bridgedCollectionView performBatchUpdates:^{
                        [self.bridgedCollectionView deleteItemsAtIndexPaths:indexesOld];
                        [self.bridgedCollectionView insertItemsAtIndexPaths:indexesNew];
                    } completion:^(BOOL finished) {
                        
                    }];
                } withAnimation:animated];
            }
        } else {
            [self prepareLayout];
            [self performCollectionViewUpdate:^{
                [self.bridgedCollectionView reloadData];
            } withAnimation:animated];
        }
        [self sectionItemsChanged:sectionData inCollectionView:self.bridgedCollectionView section:section];
    }
}

- (void)sectionDataReloadSeparatorFooter:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger numberOfItems = [self.bridgedCollectionView numberOfItemsInSection:section];
        NSInteger oldNumberOfItems = sectionData.sectionWrappedItemsCountRecorder;
        if (section < self.bridgedCollectionView.numberOfSections && numberOfItems == oldNumberOfItems) {
            NSInteger item = [sectionData sectionSeparatorFooterIndex:self.bridgedCollectionView forOriginalSection:section];
            NSInteger oldItem = sectionData.sectionSeparatorFooterIndexRecorder;
            [self updateItemWithOldIndex:oldItem index:item totalItemsCount:numberOfItems inSection:section animated:animated];
        } else {
            [self prepareLayout];
            [self performCollectionViewUpdate:^{
                [self.bridgedCollectionView reloadData];
            } withAnimation:animated];
        }
        [self sectionItemsChanged:sectionData inCollectionView:self.bridgedCollectionView section:section];
    }
}

- (void)sectionDataInsertSeparatorFooter:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    [self sectionDataReloadSeparatorFooter:sectionData animated:animated];
}

- (void)sectionDataDeleteSeparatorFooter:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    [self sectionDataReloadSeparatorFooter:sectionData animated:animated];
}

- (void)sectionDataReloadInnerFooter:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger numberOfItems = [self.bridgedCollectionView numberOfItemsInSection:section];
        NSInteger oldNumberOfItems = sectionData.sectionWrappedItemsCountRecorder;
        if (section < self.bridgedCollectionView.numberOfSections && numberOfItems == oldNumberOfItems) {
            NSInteger item = [sectionData sectionInnerFooterIndex:self.bridgedCollectionView forOriginalSection:section];
            NSInteger oldItem = sectionData.sectionInnerFooterIndexRecorder;
            [self updateItemWithOldIndex:oldItem index:item totalItemsCount:numberOfItems inSection:section animated:animated];
        } else {
            [self prepareLayout];
            [self performCollectionViewUpdate:^{
                [self.bridgedCollectionView reloadData];
            } withAnimation:animated];
        }
        [self sectionItemsChanged:sectionData inCollectionView:self.bridgedCollectionView section:section];
    }
}

- (void)sectionDataInsertInnerFooter:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    [self sectionDataReloadInnerFooter:sectionData animated:animated];
}

- (void)sectionDataDeleteInnerFooter:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    [self sectionDataReloadInnerFooter:sectionData animated:animated];
}

@end

@implementation CJCollectionViewAdapter (SectionChildrenFrame)

- (CGRect)sectionDataRecommendedSeparatorHeaderFrame:(nonnull CJCollectionViewSectionData *)sectionData {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger item = [sectionData sectionSeparatorHeaderIndex:self.bridgedCollectionView forOriginalSection:section];
        if (item >= 0) {
            return [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]].frame;
        }
    }
    return CGRectMake(0, sectionData.sectionGlobalYOffset, 0, 0);
}

- (CGRect)sectionDataRecommendedInnerHeaderFrame:(nonnull CJCollectionViewSectionData *)sectionData {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger item = [sectionData sectionInnerHeaderIndex:self.bridgedCollectionView forOriginalSection:section];
        if (item >= 0) {
            return [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]].frame;
        }
    }
    return CGRectMake(0, sectionData.sectionGlobalYOffset, 0, 0);
}

- (CGRect)sectionDataRecommendedFrame:(nonnull CJCollectionViewSectionData *)sectionData item:(NSUInteger)item {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSRange itemRange = [sectionData sectionItemRange:self.bridgedCollectionView forOriginalSection:section];
        if (itemRange.length > item) {
            NSInteger realItem = itemRange.location + item;
            return [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:realItem inSection:section]].frame;
        }
    }
    return CGRectMake(0, sectionData.sectionGlobalYOffset, 0, 0);
}

- (CGRect)sectionDataRecommendedSeparatorFooterFrame:(nonnull CJCollectionViewSectionData *)sectionData {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger item = [sectionData sectionSeparatorFooterIndex:self.bridgedCollectionView forOriginalSection:section];
        if (item >= 0) {
            return [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]].frame;
        }
    }
    return CGRectMake(0, sectionData.sectionGlobalYOffset, 0, 0);
}

- (CGRect)sectionDataRecommendedInnerFooterFrame:(nonnull CJCollectionViewSectionData *)sectionData {
    
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger item = [sectionData sectionInnerFooterIndex:self.bridgedCollectionView forOriginalSection:section];
        if (item >= 0) {
            return [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]].frame;
        }
    }
    return CGRectMake(0, sectionData.sectionGlobalYOffset, 0, 0);
}

@end

@implementation CJCollectionViewAdapter (SectionChildrenScroll)

- (void)scrollToSectionDataSeparatorHeader:(nonnull CJCollectionViewSectionData *)sectionData atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger item = [sectionData sectionSeparatorHeaderIndex:self.bridgedCollectionView forOriginalSection:section];
        if (item >= 0) {
            [self.bridgedCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section] atScrollPosition:scrollPosition animated:animated];
        }
    }
}

- (void)scrollToSectionDataInnerHeader:(nonnull CJCollectionViewSectionData *)sectionData atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger item = [sectionData sectionInnerHeaderIndex:self.bridgedCollectionView forOriginalSection:section];
        if (item >= 0) {
            [self.bridgedCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section] atScrollPosition:scrollPosition animated:animated];
        }
    }
}

- (void)scrollToSectionData:(nonnull CJCollectionViewSectionData *)sectionData item:(NSUInteger)item atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSRange itemRange = [sectionData sectionItemRange:self.bridgedCollectionView forOriginalSection:section];
        if (itemRange.length > item) {
            NSInteger realItem = itemRange.location + item;
            [self.bridgedCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:realItem inSection:section] atScrollPosition:scrollPosition animated:animated];
        }
    }
}

- (void)scrollToSectionDataSeparatorFooter:(nonnull CJCollectionViewSectionData *)sectionData atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger item = [sectionData sectionSeparatorFooterIndex:self.bridgedCollectionView forOriginalSection:section];
        if (item >= 0) {
            [self.bridgedCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section] atScrollPosition:scrollPosition animated:animated];
        }
    }
}

- (void)scrollToSectionDataInnerFooter:(nonnull CJCollectionViewSectionData *)sectionData atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        NSInteger section = [self.internalSections indexOfObject:sectionData];
        NSInteger item = [sectionData sectionInnerFooterIndex:self.bridgedCollectionView forOriginalSection:section];
        if (item >= 0) {
            [self.bridgedCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section] atScrollPosition:scrollPosition animated:animated];
        }
    }
}

- (void)scrollToSectionDataSeparatorHeaderTop:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    [self scrollToSectionDataSeparatorHeaderTop:sectionData offset:0 animated:animated];
}

- (void)scrollToSectionDataInnerHeaderTop:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    [self scrollToSectionDataInnerHeaderTop:sectionData offset:0 animated:animated];
}

- (void)scrollToSectionDataTop:(nonnull CJCollectionViewSectionData *)sectionData item:(NSUInteger)item animated:(BOOL)animated {
    [self scrollToSectionDataTop:sectionData item:item offset:0 animated:animated];
}

- (void)scrollToSectionDataSeparatorFooterTop:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    [self scrollToSectionDataSeparatorFooterTop:sectionData offset:0 animated:animated];
}

- (void)scrollToSectionDataInnerFooterTop:(nonnull CJCollectionViewSectionData *)sectionData animated:(BOOL)animated {
    [self scrollToSectionDataInnerFooterTop:sectionData offset:0 animated:animated];
}

- (void)scrollToSectionDataSeparatorHeaderTop:(nonnull CJCollectionViewSectionData *)sectionData offset:(CGFloat)offset animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        CGRect frame = [self sectionDataRecommendedSeparatorHeaderFrame:sectionData];
        [self tryScrollCollectionViewToOffset:CGPointMake(-self.bridgedCollectionView.contentInset.left, offset - self.bridgedCollectionView.contentInset.top + frame.origin.y - (sectionData.sectionStickyHeaderHeightRecorder ? sectionData.sectionStickyHeaderHeightRecorder.doubleValue : 0.0)) animated:animated];
    }
}

- (void)scrollToSectionDataInnerHeaderTop:(nonnull CJCollectionViewSectionData *)sectionData offset:(CGFloat)offset animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        CGRect frame = [self sectionDataRecommendedInnerHeaderFrame:sectionData];
        [self tryScrollCollectionViewToOffset:CGPointMake(-self.bridgedCollectionView.contentInset.left, offset - self.bridgedCollectionView.contentInset.top + frame.origin.y - (sectionData.sectionStickyHeaderHeightRecorder ? sectionData.sectionStickyHeaderHeightRecorder.doubleValue : 0.0)) animated:animated];
    }
}

- (void)scrollToSectionDataTop:(nonnull CJCollectionViewSectionData *)sectionData item:(NSUInteger)item offset:(CGFloat)offset animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        CGRect frame = [self sectionDataRecommendedFrame:sectionData item:item];
        [self tryScrollCollectionViewToOffset:CGPointMake(-self.bridgedCollectionView.contentInset.left, offset - self.bridgedCollectionView.contentInset.top + frame.origin.y - (sectionData.sectionStickyHeaderHeightRecorder ? sectionData.sectionStickyHeaderHeightRecorder.doubleValue : 0.0)) animated:animated];
    }
}

- (void)scrollToSectionDataSeparatorFooterTop:(nonnull CJCollectionViewSectionData *)sectionData offset:(CGFloat)offset animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        CGRect frame = [self sectionDataRecommendedSeparatorFooterFrame:sectionData];
        [self tryScrollCollectionViewToOffset:CGPointMake(-self.bridgedCollectionView.contentInset.left, offset - self.bridgedCollectionView.contentInset.top + frame.origin.y - (sectionData.sectionStickyHeaderHeightRecorder ? sectionData.sectionStickyHeaderHeightRecorder.doubleValue : 0.0)) animated:animated];
    }
}

- (void)scrollToSectionDataInnerFooterTop:(nonnull CJCollectionViewSectionData *)sectionData offset:(CGFloat)offset animated:(BOOL)animated {
    if ([self.internalSections containsObject:sectionData]) {
        CGRect frame = [self sectionDataRecommendedInnerFooterFrame:sectionData];
        [self tryScrollCollectionViewToOffset:CGPointMake(-self.bridgedCollectionView.contentInset.left, offset - self.bridgedCollectionView.contentInset.top + frame.origin.y - (sectionData.sectionStickyHeaderHeightRecorder ? sectionData.sectionStickyHeaderHeightRecorder.doubleValue : 0.0)) animated:animated];
    }
}

- (void)tryScrollCollectionViewToOffset:(CGPoint)offset animated:(BOOL)animated {
    CGFloat maxOffset = self.bridgedCollectionView.contentSize.height - self.bridgedCollectionView.frame.size.height + self.bridgedCollectionView.contentInset.bottom;
    CGFloat minOffset = -self.bridgedCollectionView.contentInset.top;
    [self.bridgedCollectionView setContentOffset:CGPointMake(offset.x, MAX(MIN(maxOffset, offset.y), minOffset)) animated:animated];
}

@end
