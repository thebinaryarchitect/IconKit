//
//  RootViewController.m
//  IconCatalog
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

#import "RootViewController.h"

#pragma mark - RootViewController

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

@end
