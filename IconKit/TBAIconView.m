//
//  TBAIconView.m
//  IconKit
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

#import "TBAIconView.h"

#pragma mark - TBAIconView

#pragma mark - Public Implementation

@implementation TBAIconView

#pragma mark Lifecycle

- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius {
    CGRect frame = [self calculateFrameWithCenter:center radius:radius];
    self = [super initWithFrame:frame];
    if (self) {
        _radius = radius;
        _borderType = TBAIconViewBorderTypeNone;
        _fillColor = [UIColor whiteColor];
        _strokeColor = [UIColor blackColor];
        _lineWidth = 2.0;
        _applyFill = NO;
    }
    return self;
}

#pragma mark Property Overrides

- (void)setRadius:(CGFloat)radius {
    if (_radius != radius) {
        _radius = radius;
        CGRect frame = [self calculateFrameWithCenter:self.center radius:_radius];
        self.frame = frame;
    }
}

#pragma mark Private

- (CGRect)calculateFrameWithCenter:(CGPoint)center radius:(CGFloat)radius {
    return CGRectMake(center.x-radius, center.y-radius, 2*radius, 2*radius);
}

@end
