//
//  CJCollectionViewSectionData+Sealed.h
//  CJCollectionViewAdapter
//
//  Created by cj1024 on 2020/10/10.
//  Copyright © 2020 cj1024. All rights reserved.
//

#import "CJCollectionViewSectionData.h"

@interface CJCollectionViewSectionData (SectionHeaderSealed)

- (NSInteger)sectionSeparatorHeaderIndex:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (NSInteger)sectionInnerHeaderIndex:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;

@end

@interface CJCollectionViewSectionData (SectionItemSealed)

- (NSRange)sectionItemRange:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (CGRect)sectionItemFrame:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection; //仅Y轴有效

@end

@interface CJCollectionViewSectionData (SectionFooterSealed)

- (NSInteger)sectionSeparatorFooterIndex:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;
- (NSInteger)sectionInnerFooterIndex:(nonnull UICollectionView *)collectionView forOriginalSection:(NSUInteger)originalSection;

@end
