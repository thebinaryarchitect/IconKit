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

NSString *const TBAIconIdentifierCrossMark = @"TBAIconCrossMark";
NSString *const TBAIconIdentifierMinus = @"TBAIconMinus";
NSString *const TBAIconIdentifierPlus = @"TBAIconPlus";
NSString *const TBAIconIdentifierLeftArrow = @"TBAIconLeftArrow";

@implementation TBAIconView

#pragma mark Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        
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

#pragma mark Public

- (void)updateDataSource:(NSString *)identifier {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:identifier ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *version = dict[@"version"];
    if ([version isEqualToString:@"1.0.0"]) {
        NSArray *geometry = dict[@"geometry"];
        NSMutableArray *bezierPaths = [NSMutableArray array];
        for (NSDictionary *infoDict in geometry) {
            NSString *type = infoDict[@"type"];
            UIBezierPath *path = [UIBezierPath bezierPath];
            if ([type isEqualToString:@"points"]) {
                NSArray *pointStrings = infoDict[@"values"];
                for (NSString *pointString in pointStrings) {
                    CGPoint point = CGPointFromString(pointString);
                    if ([pointString isEqual:pointStrings.firstObject]) {
                        [path moveToPoint:point];
                    } else {
                        [path addLineToPoint:point];
                    }
                }
            }
            [bezierPaths addObject:path];
        }
        self.bezierPaths = bezierPaths;
    }
    [self setNeedsDisplay];
}

@end
