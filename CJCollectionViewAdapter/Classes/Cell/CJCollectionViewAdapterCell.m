//
//  CJCollectionViewAdapterCell.m
//  CJCollectionViewAdapter
//
//  Created by cj1024 on 2020/10/10.
//  Copyright © 2020 cj1024. All rights reserved.
//

#import "CJCollectionViewAdapterCell.h"

static const CGFloat kCJCollectionViewAdapterBaseCellDefaultHorizontalInset = 15.0;

#define kOnePixelLineWidth (1.0 / [UIScreen mainScreen].scale)

@interface CJCollectionViewAdapterCellSeparatorView : UIView

@end

@implementation CJCollectionViewAdapterCellSeparatorView

@end

@interface CJCollectionViewAdapterCellImageView : UIImageView

@end

@implementation CJCollectionViewAdapterCellImageView

@end

@interface CJCollectionViewAdapterCellLabel : UILabel

@end

@implementation CJCollectionViewAdapterCellLabel

@end

@interface CJCollectionViewAdapterBaseCell () <CAAnimationDelegate>

@property(nonatomic, strong, readwrite) UIView *topSeparatorView;
@property(nonatomic, strong, readwrite) UIView *bottomSeparatorView;
@property(nonatomic, strong, readwrite) UIView *leftSeparatorView;
@property(nonatomic, strong, readwrite) UIView *rightSeparatorView;
@property(nonatomic, strong, readwrite) UIImageView *rightArrowView;
@property(nonatomic, strong, readwrite) UILabel *summaryLabel;

@property(nonatomic, strong, readwrite) UIView *rippleHolder;
@property(nonatomic, assign, readwrite) CGPoint rippleTouchLocation;

+ (nonnull NSDictionary<NSString *, id> *)defaultSummaryAttributes;
- (CGRect)desiredRightArrowViewFrame;

@end

@implementation CJCollectionViewAdapterBaseCell

#pragma mark -
#pragma mark Init & Layout

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _topSeparatorColor = [UIColor clearColor];
        _bottomSeparatorColor = [UIColor colorWithRed:(225.0 / 255.0) green:(225.0 / 255.0) blue:(225.0 / 255.0) alpha:1.0];
        _leftSeparatorColor = [UIColor clearColor];
        _rightSeparatorColor = [UIColor clearColor];
        _topSeparatorInset = UIEdgeInsetsMake(0.0, kCJCollectionViewAdapterBaseCellDefaultHorizontalInset, 0.0, 0.0);
        _bottomSeparatorInset = UIEdgeInsetsMake(0.0, kCJCollectionViewAdapterBaseCellDefaultHorizontalInset, 0.0, 0.0);
        _leftSeparatorInset = UIEdgeInsetsZero;
        _rightSeparatorInset = UIEdgeInsetsZero;
        _showRightArrow = NO;
        _rightArrowAlignment = CJCollectionViewAdapterCellAlignmentMake(CJCollectionViewAdapterCellHorizontalAlignmentRight, CJCollectionViewAdapterCellVerticalAlignmentCenter);
        _rightArrowOffset = CGPointMake(-kCJCollectionViewAdapterBaseCellDefaultHorizontalInset, 0.0);
        _showSummaryLabel = YES;
        _summaryLabelInset = UIEdgeInsetsMake(0, kCJCollectionViewAdapterBaseCellDefaultHorizontalInset, 0, kCJCollectionViewAdapterBaseCellDefaultHorizontalInset);
        _enableRippleHighlightStyle = NO;
        _rippleDuration = 0.3;
        _rippleColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutTopSeparatorView];
    [self layoutBottomSeparatorView];
    [self layoutLeftSeparatorView];
    [self layoutRightSeparatorView];
    [self layoutRightArrowView];
    [self layoutSummaryLabel];
    [self layoutAndroidStyleHighlightHolder];
}

- (void)layoutTopSeparatorView {
    CGFloat lineHeight = MAX(0, kOnePixelLineWidth - (self.topSeparatorInset.top - self.topSeparatorInset.bottom));
    self.topSeparatorView.frame = CGRectMake(self.topSeparatorInset.left,
                                             self.topSeparatorInset.top,
                                             MAX(0, CGRectGetWidth(self.contentView.bounds) - (self.topSeparatorInset.left + self.topSeparatorInset.right)),
                                             lineHeight);
    if (self.topSeparatorView.superview != self.contentView) {
        [self.contentView addSubview:self.topSeparatorView];
    }
}

- (void)layoutBottomSeparatorView {
    CGFloat lineHeight = MAX(0, kOnePixelLineWidth - (self.bottomSeparatorInset.bottom - self.bottomSeparatorInset.top));
    self.bottomSeparatorView.frame = CGRectMake(self.bottomSeparatorInset.left,
                                                CGRectGetHeight(self.contentView.bounds) - lineHeight,
                                                MAX(0, CGRectGetWidth(self.contentView.bounds) - (self.bottomSeparatorInset.left + self.bottomSeparatorInset.right)),
                                                lineHeight);
    if (self.bottomSeparatorView.superview != self.contentView) {
        [self.contentView addSubview:self.bottomSeparatorView];
    }
}

- (void)layoutLeftSeparatorView {
    CGFloat lineHeight = MAX(0, kOnePixelLineWidth - (self.leftSeparatorInset.left - self.leftSeparatorInset.right));
    self.leftSeparatorView.frame = CGRectMake(self.leftSeparatorInset.left,
                                             self.leftSeparatorInset.top,
                                             lineHeight,
                                             MAX(0, CGRectGetHeight(self.contentView.bounds) - (self.leftSeparatorInset.top + self.leftSeparatorInset.bottom)));
    if (self.leftSeparatorView.superview != self.contentView) {
        [self.contentView addSubview:self.leftSeparatorView];
    }
}

- (void)layoutRightSeparatorView {
    CGFloat lineHeight = MAX(0, kOnePixelLineWidth - (self.rightSeparatorInset.right - self.rightSeparatorInset.left));
    self.rightSeparatorView.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) - lineHeight,
                                              self.rightSeparatorInset.top,
                                              lineHeight,
                                              MAX(0, CGRectGetHeight(self.contentView.bounds) - (self.rightSeparatorInset.top + self.rightSeparatorInset.bottom)));
    if (self.rightSeparatorView.superview != self.contentView) {
        [self.contentView addSubview:self.rightSeparatorView];
    }
}

- (void)layoutRightArrowView {
    self.rightArrowView.frame = [self desiredRightArrowViewFrame];
    if (self.rightArrowView.superview != self.contentView) {
        [self.contentView addSubview:self.rightArrowView];
    }
}

- (void)layoutSummaryLabel {
    CGRect frame = self.contentView.bounds;
    frame.origin.x += self.summaryLabelInset.left;
    frame.size.width -= (self.summaryLabelInset.left + self.summaryLabelInset.right);
    frame.origin.y += self.summaryLabelInset.top;
    frame.size.height -= (self.summaryLabelInset.top + self.summaryLabelInset.bottom);
    if (self.showRightArrow) {
        frame.size.width -= (CGRectGetWidth(self.contentView.bounds) - CGRectGetMinX([self desiredRightArrowViewFrame]));
    }
    self.summaryLabel.frame = frame;
    if (self.summaryLabel.superview != self.contentView) {
        [self.contentView addSubview:self.summaryLabel];
    }
}

- (void)layoutAndroidStyleHighlightHolder {
    if (self.rippleHolder == nil) {
        self.rippleHolder = [[UIView alloc] initWithFrame:self.contentView.bounds];
        self.rippleHolder.backgroundColor = [UIColor clearColor];
        self.rippleHolder.clipsToBounds = YES;
        self.rippleHolder.userInteractionEnabled = NO;
        [self.contentView addSubview:self.rippleHolder];
    }
    self.rippleHolder.frame = self.contentView.bounds;
}

#pragma mark -
#pragma mark Lazy Load Properties

- (UIView *)topSeparatorView {
    if (_topSeparatorView == nil) {
        UIView *aView = [[CJCollectionViewAdapterCellSeparatorView alloc] init];
        aView.backgroundColor = self.topSeparatorColor;
        aView.layer.zPosition = 2;
        _topSeparatorView = aView;
    }
    return _topSeparatorView;
}

- (UIView *)bottomSeparatorView {
    if (_bottomSeparatorView == nil) {
        UIView *aView = [[CJCollectionViewAdapterCellSeparatorView alloc] init];
        aView.backgroundColor = self.bottomSeparatorColor;
        aView.layer.zPosition = 2;
        _bottomSeparatorView = aView;
    }
    return _bottomSeparatorView;
}

- (UIView *)leftSeparatorView {
    if (_leftSeparatorView == nil) {
        UIView *aView = [[CJCollectionViewAdapterCellSeparatorView alloc] init];
        aView.backgroundColor = self.leftSeparatorColor;
        aView.layer.zPosition = 2;
        _leftSeparatorView = aView;
    }
    return _leftSeparatorView;
}

- (UIView *)rightSeparatorView {
    if (_rightSeparatorView == nil) {
        UIView *aView = [[CJCollectionViewAdapterCellSeparatorView alloc] init];
        aView.backgroundColor = self.rightSeparatorColor;
        aView.layer.zPosition = 2;
        _rightSeparatorView = aView;
    }
    return _rightSeparatorView;
}

- (UIImageView *)rightArrowView {
    if (_rightArrowView == nil) {
        UIImageView *aView = [[CJCollectionViewAdapterCellImageView alloc] init];
        aView.backgroundColor = [UIColor clearColor];
        aView.hidden = !self.showRightArrow;
        aView.layer.zPosition = 1;
        _rightArrowView = aView;
    }
    return _rightArrowView;
}

- (UILabel *)summaryLabel {
    if (_summaryLabel == nil) {
        UILabel *aView = [[CJCollectionViewAdapterCellLabel alloc] init];
        aView.backgroundColor = [UIColor clearColor];
        aView.numberOfLines = 0;
        aView.hidden = !self.showSummaryLabel;
        _summaryLabel = aView;
    }
    return _summaryLabel;
}

#pragma mark -
#pragma mark Properties

- (void)setTopSeparatorColor:(UIColor *)topSeparatorColor {
    _topSeparatorColor = topSeparatorColor;
    self.topSeparatorView.backgroundColor = topSeparatorColor;
}

- (void)setBottomSeparatorColor:(UIColor *)bottomSeparatorColor {
    _bottomSeparatorColor = bottomSeparatorColor;
    self.bottomSeparatorView.backgroundColor = bottomSeparatorColor;
}

- (void)setLeftSeparatorColor:(UIColor *)leftSeparatorColor {
    _leftSeparatorColor = leftSeparatorColor;
    self.leftSeparatorView.backgroundColor = leftSeparatorColor;
}

- (void)setRightSeparatorColor:(UIColor *)rightSeparatorColor {
    _rightSeparatorColor = rightSeparatorColor;
    self.rightSeparatorView.backgroundColor = rightSeparatorColor;
}

- (void)setTopSeparatorInset:(UIEdgeInsets)topSeparatorInset {
    _topSeparatorInset = topSeparatorInset;
    [self setNeedsLayout];
}

- (void)setBottomSeparatorInset:(UIEdgeInsets)bottomSeparatorInset {
    _bottomSeparatorInset = bottomSeparatorInset;
    [self setNeedsLayout];
}

- (void)setLeftSeparatorInset:(UIEdgeInsets)leftSeparatorInset {
    _leftSeparatorInset = leftSeparatorInset;
    [self setNeedsLayout];
}

- (void)setRightSeparatorInset:(UIEdgeInsets)rightSeparatorInset {
    _rightSeparatorInset = rightSeparatorInset;
    [self setNeedsLayout];
}

- (void)setShowRightArrow:(BOOL)showRightArrow {
    _showRightArrow = showRightArrow;
    self.rightArrowView.hidden = !showRightArrow;
}

- (void)setRightArrowImage:(UIImage *)rightArrowImage {
    _rightArrowImage = rightArrowImage;
    self.rightArrowView.image = rightArrowImage;
    [self setNeedsLayout];
}

- (void)setRightArrowAlignment:(CJCollectionViewAdapterCellAlignment)rightArrowAlignment {
    _rightArrowAlignment = rightArrowAlignment;
    [self setNeedsLayout];
}

- (void)setRightArrowOffset:(CGPoint)rightArrowOffset {
    _rightArrowOffset = rightArrowOffset;
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark Override Methods

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch) {
        self.rippleTouchLocation = [touch locationInView:self];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch) {
        self.rippleTouchLocation = [touch locationInView:self];
    }
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch) {
        self.rippleTouchLocation = [touch locationInView:self];
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch) {
        self.rippleTouchLocation = [touch locationInView:self];
    }
    [super touchesCancelled:touches withEvent:event];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted && self.enableRippleHighlightStyle) {
        CGFloat maxX = MAX(fabs(self.rippleTouchLocation.x), fabs(CGRectGetWidth(self.frame) - self.rippleTouchLocation.x));
        CGFloat maxY = MAX(fabs(self.rippleTouchLocation.y), fabs(CGRectGetHeight(self.frame) - self.rippleTouchLocation.y));
        UIBezierPath *path0 = [UIBezierPath bezierPathWithArcCenter:self.rippleTouchLocation
                                                             radius:10.0
                                                         startAngle:-M_PI
                                                           endAngle:M_PI
                                                          clockwise:YES];
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:self.rippleTouchLocation
                                                             radius:ceilf(sqrt(maxX * maxX + maxY * maxY))
                                                         startAngle:-M_PI
                                                           endAngle:M_PI
                                                          clockwise:YES];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path0.CGPath;
        layer.opacity = 1.0;
        layer.fillColor = self.rippleColor.CGColor;
        self.clipsToBounds = YES;
        [self.rippleHolder.layer insertSublayer:layer atIndex:0];
        CABasicAnimation *animationPath = [CABasicAnimation animation];
        [animationPath setKeyPath:@"path"];
        [animationPath setFromValue:(id)path0.CGPath];
        [animationPath setToValue:(id)path1.CGPath];
        CABasicAnimation *animationOpacity = [CABasicAnimation animation];
        [animationOpacity setKeyPath:@"opacity"];
        [animationOpacity setFromValue:@(1.0)];
        [animationOpacity setToValue:@(0.1)];
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[ animationPath, animationOpacity ];
        group.duration = self.rippleDuration;
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        [layer addAnimation:group forKey:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [layer removeFromSuperlayer];
        });
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    NSArray <CALayer *> *sublayers = [self.rippleHolder.layer.sublayers copy];
    [sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
}

#pragma mark -
#pragma mark Private Methods

+ (nonnull NSDictionary<NSString *, id> *)defaultSummaryAttributes {
    static NSDictionary<NSString *, id> * __defaultSummaryAttributes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        defaultParagraphStyle.alignment = NSTextAlignmentLeft;
        defaultParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        __defaultSummaryAttributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:16],
                                        NSForegroundColorAttributeName: [UIColor blackColor],
                                        NSParagraphStyleAttributeName: defaultParagraphStyle };
    });
    return __defaultSummaryAttributes;
}

- (CGRect)desiredRightArrowViewFrame {
    CGFloat rightArrowViewX = 0.0, rightArrowViewY = 0.0;
    CGSize rightImageSize = self.rightArrowView.image ? self.rightArrowView.image.size : CGSizeZero;
    switch (self.rightArrowAlignment.horizontalAlignment) {
        case CJCollectionViewAdapterCellHorizontalAlignmentLeft:
            rightArrowViewX = 0.0;
            break;
        case CJCollectionViewAdapterCellHorizontalAlignmentCenter:
            rightArrowViewX = (CGRectGetWidth(self.bounds) - rightImageSize.width) / 2;
            break;
        case CJCollectionViewAdapterCellHorizontalAlignmentRight:
            rightArrowViewX = CGRectGetWidth(self.bounds) - rightImageSize.width;
            break;
    }
    switch (self.rightArrowAlignment.verticalAlignment) {
        case CJCollectionViewAdapterCellVerticalAlignmentTop:
            rightArrowViewY = 0.0;
            break;
        case CJCollectionViewAdapterCellVerticalAlignmentCenter:
            rightArrowViewY = (CGRectGetHeight(self.bounds) - rightImageSize.height) / 2;
            break;
        case CJCollectionViewAdapterCellVerticalAlignmentBottom:
            rightArrowViewY = CGRectGetHeight(self.bounds) - rightImageSize.height;
            break;
    }
    return CGRectMake(rightArrowViewX + self.rightArrowOffset.x, rightArrowViewY + self.rightArrowOffset.y, rightImageSize.width, rightImageSize.height);
}

#pragma mark -
#pragma mark Public Methods

- (void)updateShowRightArrow:(BOOL)showRightArrow
             rightArrowImage:(nullable UIImage *)rightArrowImage
         rightArrowAlignment:(CJCollectionViewAdapterCellAlignment)rightArrowAlignment
            rightArrowOffset:(CGPoint)rightArrowOffset {
    self.showRightArrow = showRightArrow;
    self.rightArrowImage = rightArrowImage;
    self.rightArrowAlignment = rightArrowAlignment;
    self.rightArrowOffset = rightArrowOffset;
}

- (void)updateShowSummaryLabel:(BOOL)showSummaryLabel
             summaryLabelInset:(UIEdgeInsets)summaryLabelInset {
    self.showSummaryLabel = showSummaryLabel;
    self.summaryLabelInset = summaryLabelInset;
}

- (void)updateSummary:(nullable NSString *)summary {
    if ([summary isKindOfClass:[NSString class]]) {
        NSAttributedString *attributedSummary = [[NSAttributedString alloc] initWithString:summary attributes:[CJCollectionViewAdapterBaseCell defaultSummaryAttributes]];
        [self updateAttributedSummary:attributedSummary];
    } else {
        [self updateAttributedSummary:nil];
    }
}

- (void)updateAttributedSummary:(nullable NSAttributedString *)attributedSummary {
    self.summaryLabel.attributedText = attributedSummary;
}

@end

@implementation CJSeparatorCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        self.bottomSeparatorInset = UIEdgeInsetsZero;
    }
    return self;
}

@end

@implementation CJNormalContentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:(246.0 / 255.0) green:(246.0 / 255.0) blue:(246.0 / 255.0) alpha:1.0];
        self.showRightArrow = YES;
    }
    return self;
}

@end

@implementation CJPlainContentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
