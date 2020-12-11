//
//  CJCollectionViewAdapterCell.h
//  CJCollectionViewAdapter
//
//  Created by cj1024 on 2020/10/10.
//  Copyright © 2020 cj1024. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJCollectionViewAdapterCellMacros.h"

// 注意，系统调用的是initWithFrame方法，请子类override此方法做初始化
@interface CJCollectionViewAdapterBaseCell : UICollectionViewCell

@property(nonatomic, strong, readwrite, nullable) UIColor *topSeparatorColor; // 默认[UIColor clearColor]
@property(nonatomic, strong, readwrite, nullable) UIColor *bottomSeparatorColor; // 默认0xE1E1E1
@property(nonatomic, strong, readwrite, nullable) UIColor *leftSeparatorColor; // 默认[UIColor clearColor]
@property(nonatomic, strong, readwrite, nullable) UIColor *rightSeparatorColor; // 默认[UIColor clearColor]
@property(nonatomic, assign, readwrite) UIEdgeInsets topSeparatorInset; // 默认UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)；横向Left、Right控制左右缩进；纵向默认线宽度 1 / [UIScreen mainScreen].scale，贴在最上方，可使用Top控制位置，结合Bottom控制线的宽度
@property(nonatomic, assign, readwrite) UIEdgeInsets bottomSeparatorInset; // 默认UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)；横向Left、Right控制左右缩进；纵向默认线宽度 1 / [UIScreen mainScreen].scale，贴在最下方，可使用Bottom控制位置，结合Top控制线的宽度
@property(nonatomic, assign, readwrite) UIEdgeInsets leftSeparatorInset; // 默认UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)；横向Top、Bottom控制上下缩进；纵向默认线宽度 1 / [UIScreen mainScreen].scale，贴在最左方，可使用Left控制位置，结合Right控制线的宽度
@property(nonatomic, assign, readwrite) UIEdgeInsets rightSeparatorInset; // 默认UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)；横向Top、Bottom控制上下缩进；纵向默认线宽度 1 / [UIScreen mainScreen].scale，贴在最右方，可使用Right控制位置，结合Left控制线的宽度
@property(nonatomic, assign, readwrite) BOOL showRightArrow; // 默认NO
@property(nonatomic, strong, readwrite, nullable) UIImage *rightArrowImage;
@property(nonatomic, assign, readwrite) CJCollectionViewAdapterCellAlignment rightArrowAlignment; // 默认CJCollectionViewAdapterCellAlignmentMake(eCJCollectionViewAdapterCellHorizontalAlignmentRight, eCJCollectionViewAdapterCellVerticalAlignmentCenter)
@property(nonatomic, assign, readwrite) CGPoint rightArrowOffset; // 默认CGPointMake(-15.0, 0.0)
@property(nonatomic, assign, readwrite) BOOL showSummaryLabel; // 认YES
@property(nonatomic, assign, readwrite) UIEdgeInsets summaryLabelInset; // 默认UIEdgeInsetsMake(0, 15.0, 0, 15.0)

@property(nonatomic, assign, readwrite) BOOL enableRippleHighlightStyle; // 默认NO
@property(nonatomic, assign, readwrite) NSTimeInterval rippleDuration; // 默认0.3s
@property(nonatomic, strong, readwrite, nullable) UIColor *rippleColor; // 默认0.3黑度
@property(nonatomic, assign, readonly) CGPoint rippleTouchLocation; // 位置记录

- (void)updateShowRightArrow:(BOOL)showRightArrow
             rightArrowImage:(nullable UIImage *)rightArrowImage
         rightArrowAlignment:(CJCollectionViewAdapterCellAlignment)rightArrowAlignment
            rightArrowOffset:(CGPoint)rightArrowOffset;

- (void)updateShowSummaryLabel:(BOOL)showSummaryLabel
             summaryLabelInset:(UIEdgeInsets)summaryLabelInset;

- (void)updateSummary:(nullable NSString *)summary;

- (void)updateAttributedSummary:(nullable NSAttributedString *)attributedSummary;

@end

@interface CJSeparatorCollectionViewCell : CJCollectionViewAdapterBaseCell // bottomSeparatorInset默认UIEdgeInsetsZero

@end

@interface CJNormalContentCollectionViewCell : CJCollectionViewAdapterBaseCell

@end

@interface CJPlainContentCollectionViewCell : CJCollectionViewAdapterBaseCell

@end
