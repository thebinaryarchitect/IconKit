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
NSString *const TBAIconIdentifierRightArrow = @"TBAIconRightArrow";
NSString *const TBAIconIdentifierUpArrow = @"TBAIconUpArrow";
NSString *const TBAIconIdentifierDownArrow = @"TBAIconDownArrow";
NSString *const TBAIconIdentifierCheckMark = @"TBAIconCheckMark";

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
    
    CGContextSetLineWidth(context, self.lineWidth);
    [self.strokeColor setStroke];
    
    CGRect bounds = CGRectInset(rect, self.lineWidth, self.lineWidth);
    switch (self.borderType) {
        case TBAIconViewBorderTypeSquare: {
            CGContextStrokeRect(context, bounds);
            break;
        }
        case TBAIconViewBorderTypeCircle: {
            CGContextStrokeEllipseInRect(context, bounds);
            break;
        }
        case TBAIconViewBorderTypeRoundedCorners: {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:0.1*bounds.size.width];
            CGContextAddPath(context, path.CGPath);
            CGContextStrokePath(context);
            break;
        }
        default:
            break;
    }
    
    CGFloat multiplier = 0.5;
    CGFloat scale = rect.size.width;
    if (self.borderType != TBAIconViewBorderTypeNone) {
        scale *= multiplier;
    }

    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    
    if (self.borderType != TBAIconViewBorderTypeNone) {
        multiplier = 0.5*(1.0-multiplier);
        CGAffineTransform translation = CGAffineTransformMakeTranslation(multiplier*rect.size.width, multiplier*rect.size.height);
        transform = CGAffineTransformConcat(transform, translation);
    }
    
    for (UIBezierPath *bPath in self.bezierPaths) {
        UIBezierPath *sPath = [UIBezierPath bezierPathWithCGPath:bPath.CGPath];
        [sPath applyTransform:transform];
        CGPathRef path = sPath.CGPath;
        CGContextAddPath(context, path);
    }
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
