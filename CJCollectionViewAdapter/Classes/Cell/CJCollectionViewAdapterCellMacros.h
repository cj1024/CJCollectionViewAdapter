//
//  CJCollectionViewAdapterCellMacros.h
//  CJCollectionViewAdapter
//
//  Created by cj1024 on 2020/10/10.
//  Copyright © 2020 cj1024. All rights reserved.
//

#ifndef CJCollectionViewAdapterMacros_h
#define CJCollectionViewAdapterMacros_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CJCollectionViewAdapterCellHorizontalAlignment) {
    CJCollectionViewAdapterCellHorizontalAlignmentLeft = -1,
    CJCollectionViewAdapterCellHorizontalAlignmentCenter = 0,
    CJCollectionViewAdapterCellHorizontalAlignmentRight = 1
};

typedef NS_ENUM(NSInteger, CJCollectionViewAdapterCellVerticalAlignment) {
    CJCollectionViewAdapterCellVerticalAlignmentTop = -1,
    CJCollectionViewAdapterCellVerticalAlignmentCenter = 0,
    CJCollectionViewAdapterCellVerticalAlignmentBottom = 1
};

typedef struct CJCollectionViewAdapterCellAlignment {
    CJCollectionViewAdapterCellHorizontalAlignment horizontalAlignment;
    CJCollectionViewAdapterCellVerticalAlignment verticalAlignment;
} CJCollectionViewAdapterCellAlignment;

UIKIT_STATIC_INLINE CJCollectionViewAdapterCellAlignment CJCollectionViewAdapterCellAlignmentMake(CJCollectionViewAdapterCellHorizontalAlignment horizontalAlignment, CJCollectionViewAdapterCellVerticalAlignment verticalAlignment) {
    CJCollectionViewAdapterCellAlignment alignment;
    alignment.horizontalAlignment = horizontalAlignment;
    alignment.verticalAlignment = verticalAlignment;
    return alignment;
}

#endif /* CJCollectionViewAdapterMacros_h */
