//
//  RootViewController.m
//  IconCatalog
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

#import "RootViewController.h"

#pragma mark - _IconCell

#pragma mark - Private Interface

@interface _IconCell : UICollectionViewCell
@property (nonatomic, strong, readwrite) TBAIconView *iconView;
@end

#pragma mark - Private Implementation

@implementation _IconCell

#pragma mark Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    
        TBAIconView *iconView = [[TBAIconView alloc] initWithIdentifier:TBAIconIdentifierCrossMark];
        iconView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            [iconView autoCenterInSuperview];
            [iconView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:iconView];
            [iconView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.contentView withMultiplier:0.5];
        }];
    }
    return self;
}

@end

#pragma mark - RootViewController

#pragma mark - Private Interface

@interface RootViewController()
@end

#pragma mark - Public Implementation

@implementation RootViewController

#pragma mark Lifecycle

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    [self.collectionView registerClass:[_IconCell class] forCellWithReuseIdentifier:NSStringFromClass([_IconCell class])];
    [self updateLayout:self.collectionView.frame.size];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self updateLayout:size];
}

#pragma mark Private

- (void)updateLayout:(CGSize)size {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat width = size.width / 4.0;
    layout.itemSize = CGSizeMake(width - 1.0, width - 1.0);
    [self.collectionView reloadData];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _IconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([_IconCell class]) forIndexPath:indexPath];
    return cell;
}

@end
