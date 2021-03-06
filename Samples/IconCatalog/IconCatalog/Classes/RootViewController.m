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
    
        TBAIconView *iconView = [[TBAIconView alloc] init];
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
@property (nonatomic, readwrite, readwrite) NSArray *iconIDs;
@property (nonatomic, strong, readwrite) UIColor *strokeColor;
@property (nonatomic, assign, readwrite) TBAIconViewBorderType borderType;
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
        self.iconIDs = @[TBAIconIdentifierCrossMark, TBAIconIdentifierPlus, TBAIconIdentifierMinus, TBAIconIdentifierLeftArrow, TBAIconIdentifierRightArrow, TBAIconIdentifierUpArrow, TBAIconIdentifierDownArrow, TBAIconIdentifierCheckMark];
        self.borderType = TBAIconViewBorderTypeNone;
        self.strokeColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    [self.collectionView registerClass:[_IconCell class] forCellWithReuseIdentifier:NSStringFromClass([_IconCell class])];
    [self updateLayout:self.collectionView.frame.size];

    NSArray *colors = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor], [UIColor purpleColor], [UIColor brownColor], [UIColor blackColor]];

    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:flexItem];
    for (UIColor *color in colors) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
        button.backgroundColor = color;
        [button addTarget:self action:@selector(updateColor:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        [items addObject:item];
    }
    [items addObject:flexItem];
    self.toolbarItems = items;
    self.navigationController.toolbarHidden = NO;
    
    NSArray *segItems = @[@"None", @"Square", @"Circle", @"Rounded Corners"];
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:segItems];
    for (NSInteger i=0; i<segControl.numberOfSegments; i++) {
        [segControl setWidth:125.0 forSegmentAtIndex:i];
    }
    [segControl addTarget:self action:@selector(updateBorderType:) forControlEvents:UIControlEventValueChanged];
    segControl.selectedSegmentIndex = self.borderType;
    self.navigationItem.titleView = segControl;
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

- (void)updateColor:(UIButton *)button {
    self.strokeColor = button.backgroundColor;
    [self.collectionView reloadData];
}

- (void)updateBorderType:(UISegmentedControl *)control {
    self.borderType = control.selectedSegmentIndex;
    [self.collectionView reloadData];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.iconIDs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _IconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([_IconCell class]) forIndexPath:indexPath];
    NSString *iconID = self.iconIDs[indexPath.row];
    TBAIconView *iconView = cell.iconView;
    iconView.strokeColor = self.strokeColor;
    iconView.borderType = self.borderType;
    [iconView updateDataSource:iconID];
    return cell;
}

@end
