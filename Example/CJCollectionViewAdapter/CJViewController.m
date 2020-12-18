//
//  CJViewController.m
//  CJCollectionViewAdapter_Example
//
//  Created by cj1024 on 12/11/2020.
//  Copyright (c) 2020 cj1024. All rights reserved.
//

#import "CJViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <CJCollectionViewAdapter/CJCollectionViewAdapter.h>
#import "CJCollectionView.h"
#import "CJCollectionViewTestSectionData.h"

@interface CJViewController ()

@property(nonatomic, strong, readwrite) UICollectionView *collectionView;
@property(nonatomic, strong, readwrite) CJCollectionViewAdapter *adapter;

@end

@implementation CJViewController

- (void)dealloc {
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self viewControllerReloadData];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    [self layoutCollectionView];
}

- (void)layoutCollectionView {
    if (self.collectionView.superview != self.view) {
        [self.view addSubview:self.collectionView];
    }
    self.collectionView.frame = self.view.bounds;
    if (@available(iOS 11.0, *)) {
        self.adapter.stickyContentInset = [NSValue valueWithUIEdgeInsets:self.view.safeAreaInsets];
        self.collectionView.scrollIndicatorInsets = self.view.safeAreaInsets;
        UIEdgeInsets insets = self.view.safeAreaInsets;
        insets.bottom += ([self.collectionView.mj_footer isKindOfClass:[UIView class]] ? CGRectGetHeight(self.collectionView.mj_footer.frame) : 0.);
        self.collectionView.contentInset = insets;
    }
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionView *aView = [[CJCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.adapter.wrappedCollectionViewLayout];
        [self.adapter attachCollectionView:aView];
        aView.alwaysBounceVertical = YES;
        aView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        if (@available(iOS 11.0, *)) {
            aView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 13.0, *)) {
            aView.automaticallyAdjustsScrollIndicatorInsets = NO;
        }
        aView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(viewControllerShouldReloadData)];
        aView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(viewControllerShouldLoadMoreData)];
        _collectionView = aView;
    }
    return _collectionView;
}

- (CJCollectionViewAdapter *)adapter {
    if (_adapter == nil) {
        CJCollectionViewAdapter *adapter = [[CJCollectionViewAdapter alloc] init];
        _adapter = adapter;
    }
    return _adapter;
}

- (void)viewControllerReloadData {
    [self.adapter updateSections:@[ [[CJCollectionViewTestSectionData alloc] initWithCount:1 carouselViewHeader:YES itemsInOneRow:1 animated:NO],
                                    [[CJCollectionViewTestSectionData alloc] initWithCount:2 carouselViewHeader:YES itemsInOneRow:1 animated:NO],
                                    [[CJCollectionViewTestSectionData alloc] initWithCount:3 carouselViewHeader:YES itemsInOneRow:1 animated:NO],
                                    [[CJCollectionViewTestSectionData alloc] initWithCount:4 carouselViewHeader:YES itemsInOneRow:1 animated:NO],
                                    [[CJCollectionViewTestSectionData alloc] initWithCount:4 itemsInOneRow:2 animated:YES],
                                    [[CJCollectionViewTestSectionData alloc] initWithCount:6 itemsInOneRow:2 animated:NO],
                                    [[CJCollectionViewTestSectionData alloc] initWithCount:9 itemsInOneRow:1 animated:YES],
                                    [[CJCollectionViewTestSectionData alloc] initWithCount:6 itemsInOneRow:2 animated:NO],
                                    [[CJCollectionViewTestSectionData alloc] initWithCount:4 itemsInOneRow:2 animated:YES],
                                    [[CJCollectionViewTestSectionData alloc] initWithCount:2 itemsInOneRow:1 animated:NO] ]];
}

- (void)viewControllerShouldReloadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endReloadDataOnError:NO];
        [self viewControllerReloadData];
    });
}

- (void)endReloadDataOnError:(BOOL)hasError {
    [self.collectionView.mj_header endRefreshing];
}

- (void)viewControllerShouldLoadMoreData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endLoadMoreData:NO];
        NSUInteger itemsInRow = 1 + (arc4random() % 3);
        [self.adapter sectionDataAppend:[[CJCollectionViewTestSectionData alloc] initWithCount:itemsInRow * (1 + (arc4random() % 3)) itemsInOneRow:itemsInRow animated:(arc4random() % 2) == 0] animated:YES];
    });
}

- (void)endLoadMoreData:(BOOL)hasError {
    [self.collectionView.mj_footer endRefreshing];
}

@end
