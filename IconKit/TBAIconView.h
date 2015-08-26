//
//  TBAIconView.h
//  IconKit
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

@import UIKit;

#pragma mark - TBAIconView

/**
 *  The borders applied to the icon view.
 */
typedef NS_ENUM(NSInteger, TBAIconViewBorderType){
    /**
     *  No border.
     */
    TBAIconViewBorderTypeNone
};

extern NSString *const TBAIconIdentifierCrossMark;
extern NSString *const TBAIconIdentifierMinus;
extern NSString *const TBAIconIdentifierPlus;

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
 *  The border type. Defaults to TBAIconViewBorderTypeNone.
 */
@property (nonatomic, assign, readwrite) TBAIconViewBorderType borderType;

/**
 *  The color of the stroke. Defaults to black.
 */
@property (nonatomic, strong, readwrite) UIColor *strokeColor;

/**
 *  The width of the line stroked. Defaults to 2.0.
 */
@property (nonatomic, assign, readwrite) CGFloat lineWidth;

/**
 *  Tracks if the icon is filled. Defaults to NO.
 */
@property (nonatomic, assign, readwrite) BOOL applyFill;

/**
 *  The fill color. Defaults to white.
 */
@property (nonatomic, strong, readwrite) UIColor *fillColor;

/**
 *  Causes the view to redraw with the icon associated with the identifier.
 *
 *  @param identifier The identifier.
 */
- (void)updateDataSource:(NSString *)identifier;

@end
