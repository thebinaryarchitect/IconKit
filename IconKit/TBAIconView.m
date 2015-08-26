//
//  TBAIconView.m
//  IconKit
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

#import "TBAIconView.h"

#pragma mark - TBAIconView

#pragma mark - Private Interface

@interface TBAIconView()
@property (nonatomic, strong, readwrite) NSMutableArray *bezierPaths;
@end

#pragma mark - Public Implementation

@implementation TBAIconView

#pragma mark Class Methods

+ (TBAIconView *)crossMarkIconView {
    TBAIconView *iconView = [[TBAIconView  alloc] initWithCenter:CGPointZero radius:0.0];
    [iconView updateDataSource:@"TBAIconCrossMark"];
    return iconView;
}

#pragma mark Lifecycle

- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius {
    CGRect frame = [self calculateFrameWithCenter:center radius:radius];
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        
        _radius = radius;
        _borderType = TBAIconViewBorderTypeNone;
        _fillColor = [UIColor whiteColor];
        _strokeColor = [UIColor blackColor];
        _lineWidth = 2.0;
        _applyFill = NO;
    }
    return self;
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat scale = rect.size.width;
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    for (UIBezierPath *bPath in self.bezierPaths) {
        UIBezierPath *sPath = [UIBezierPath bezierPathWithCGPath:bPath.CGPath];
        [sPath applyTransform:transform];
        CGPathRef path = sPath.CGPath;
        CGContextAddPath(context, path);
    }
    CGContextSetLineWidth(context, self.lineWidth);
    [self.strokeColor setStroke];
    CGContextStrokePath(context);
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

- (void)updateDataSource:(NSString *)identifier {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:identifier ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *version = dict[@"version"];
    if ([version isEqualToString:@"1.0.0"]) {
        NSArray *geometry = dict[@"geometry"];
        NSMutableArray *bezierPaths = [NSMutableArray array];
        for (NSArray *pointStrings in geometry) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            for (NSString *pointString in pointStrings) {
                CGPoint point = CGPointFromString(pointString);
                if ([pointString isEqual:pointStrings.firstObject]) {
                    [path moveToPoint:point];
                } else {
                    [path addLineToPoint:point];
                }
            }
            [bezierPaths addObject:path];
        }
        self.bezierPaths = bezierPaths;
    }
    [self setNeedsDisplay];
}

@end
