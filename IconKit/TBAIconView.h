//
//  TBAIconView.h
//  IconKit
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

@import UIKit;

#pragma mark - TBAIconView

#pragma mark - Public Interface

/**
 *  Renders an icon.
 */
@interface TBAIconView : UIView

/**
 *  The radius of the view. When the radius is changed, the view's frame is updated and is flagged to be redrawn.
 */
@property (nonatomic, assign, readwrite) CGFloat radius;

/**
 *  The designated initializer.
 *
 *  @param center The center of the view.
 *  @param radius The radius of the view.
 *
 *  @return TBAIconView object.
 */
- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius;

@end
