# CJCollectionViewAdapter

[![CI Status](https://img.shields.io/travis/cj1024/CJCollectionViewAdapter.svg?style=flat)](https://travis-ci.org/cj1024/CJCollectionViewAdapter)
[![Version](https://img.shields.io/cocoapods/v/CJCollectionViewAdapter.svg?style=flat)](https://cocoapods.org/pods/CJCollectionViewAdapter)
[![License](https://img.shields.io/cocoapods/l/CJCollectionViewAdapter.svg?style=flat)](https://cocoapods.org/pods/CJCollectionViewAdapter)
[![Platform](https://img.shields.io/cocoapods/p/CJCollectionViewAdapter.svg?style=flat)](https://cocoapods.org/pods/CJCollectionViewAdapter)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CJCollectionViewAdapter is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CJCollectionViewAdapter'
```

## Basic Usage

1. Init

``` objective-c
- (CJCollectionViewAdapter *)adapter {
    if (_adapter == nil) {
        CJCollectionViewAdapter *adapter = [[CJCollectionViewAdapter alloc] init];
        _adapter = adapter;
    }
    return _adapter;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionView *aView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.adapter.wrappedCollectionViewLayout];
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
```

1. Setup Sections

``` objective-c
- (void)viewControllerReloadData {
    [self.adapter updateSections:@[ [TestSectionDataA new], [TestSectionDataB new], [TestSectionDataC new] ... ]];
}
```

1. Implement DataSource And Delegate Methods If Necessary In SectionData

## ScreenShot

![ScreenShot1](https://ftp.bmp.ovh/imgs/2020/12/a6fc4de3dfcabb6a.png)

## Author

cj1024, jianchen1024@gmail.com

## License

CJCollectionViewAdapter is available under the MIT license. See the LICENSE file for more info.
