//
//  YUMediaTimingFunction.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUMediaTimingFunction.h"

NSString * const YUMediaTimingFunctionDefault       = @"default";
NSString * const YUMediaTimingFunctionLinear        = @"linear";
NSString * const YUMediaTimingFunctionEaseIn        = @"easeIn";
NSString * const YUMediaTimingFunctionEaseOut       = @"easeOut";
NSString * const YUMediaTimingFunctionEaseInEaseOut = @"easeInEaseOut";


static const CGPoint YULinearTimingFunctionControlPoint1        = {0.0,  0.0};
static const CGPoint YULinearTimingFunctionControlPoint2        = {1.0,  1.0};
static const CGPoint YUEaseInTimingFunctionControlPoint1        = {0.42, 0.0};
static const CGPoint YUEaseInTimingFunctionControlPoint2        = {1.0,  1.0};
static const CGPoint YUEaseOutTimingFunctionControlPoint1       = {0.0,  0.0};
static const CGPoint YUEaseOutTimingFunctionControlPoint2       = {0.58, 1.0};
static const CGPoint YUEaseInEaseOutTimingFunctionControlPoint1 = {0.42, 0.0};
static const CGPoint YUEaseInEaseOutTimingFunctionControlPoint2 = {0.58, 1.0};
static const CGPoint YUDefaultTimingFunctionControlPoint1       = {0.25, 0.1};
static const CGPoint YUDefaultTimingFunctionControlPoint2       = {0.25, 1.0};


@interface YUMediaTimingFunction ()
@property (nonatomic) CGPoint controlPoint1;
@property (nonatomic) CGPoint controlPoint2;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) CGFloat ax,bx,cx,ay,by,cy;
@property (nonatomic) YUMediaTimingCFunctionPointer functionPointer;
@end

@implementation YUMediaTimingFunction

+ (CGPoint)normalizedPoint:(CGPoint)point
{
    CGPoint normalizedPoint = CGPointZero;
    
    // Clamp to interval [0..1]
    normalizedPoint.x = MAX(0.0, MIN(1.0, point.x));
    normalizedPoint.y = MAX(0.0, MIN(1.0, point.y));
    
    return normalizedPoint;
}


+ (NSArray *)controlPointsForTimingFunctionWithName:(NSString *)name {
    NSDictionary *map = @{YUMediaTimingFunctionDefault:
                              @[[NSValue valueWithCGPoint:YUDefaultTimingFunctionControlPoint1],[NSValue valueWithCGPoint:YUDefaultTimingFunctionControlPoint2]],
                          YUMediaTimingFunctionLinear:
                              @[[NSValue valueWithCGPoint:YULinearTimingFunctionControlPoint1],[NSValue valueWithCGPoint:YULinearTimingFunctionControlPoint2]],
                          YUMediaTimingFunctionEaseIn:
                              @[[NSValue valueWithCGPoint:YUEaseInTimingFunctionControlPoint1],[NSValue valueWithCGPoint:YUEaseInTimingFunctionControlPoint2]],
                          YUMediaTimingFunctionEaseOut:
                              @[[NSValue valueWithCGPoint:YUEaseOutTimingFunctionControlPoint1],[NSValue valueWithCGPoint:YUEaseOutTimingFunctionControlPoint2]],
                          YUMediaTimingFunctionEaseInEaseOut:
                              @[[NSValue valueWithCGPoint:YUEaseInEaseOutTimingFunctionControlPoint1],[NSValue valueWithCGPoint:YUEaseInEaseOutTimingFunctionControlPoint2]]
                          };
    return map[name];
}


+ (id)functionWithCFunctionPointer:(YUMediaTimingCFunctionPointer)functionPointer {
    YUMediaTimingFunction *timingFunction = [[YUMediaTimingFunction alloc] init];
    timingFunction.functionPointer = functionPointer;
    return timingFunction;
}

+ (id)functionWithName:(NSString *)name {
    NSArray *controlPoints = [YUMediaTimingFunction controlPointsForTimingFunctionWithName:name];
    if (controlPoints.count == 2) {
        CGPoint point1 = [controlPoints.firstObject CGPointValue];
        CGPoint point2 = [controlPoints.lastObject CGPointValue];
        return [self functionWithControlPoints:point1.x :point1.y :point2.x :point2.y];
    }
    return nil;
}

+ (id)functionWithControlPoints:(float)c1x :(float)c1y :(float)c2x :(float)c2y {
    return [[self alloc] initWithControlPoints:c1x :c1y :c2x :c2y];
}

- (id)initWithControlPoints:(float)c1x :(float)c1y :(float)c2x :(float)c2y {
    if (self = [super init]) {
        CGPoint controlPoint1 = CGPointMake(c1x, c1y);
        CGPoint controlPoint2 = CGPointMake(c2x, c2y);
        self.controlPoint1 = [YUMediaTimingFunction normalizedPoint:controlPoint1];
        self.controlPoint2 = [YUMediaTimingFunction normalizedPoint:controlPoint2];
        
        [self calculatePolynomialCoefficients];
    }
    return self;
}

- (void)getControlPointAtIndex:(size_t)idx values:(float [2])ptr {
    CGPoint point;
    if (idx == 0) point = CGPointZero;
    if (idx == 1) point = self.controlPoint1;
    if (idx == 2) point = self.controlPoint2;
    if (idx == 3) point = CGPointMake(1, 1);
    if (ptr) {
        ptr[0] = point.x;
        ptr[1] = point.y;
    }
}

- (double)valueForInput:(double)input {
    if (input == 0 || input == 1) {
        return input;
    }
    if (self.functionPointer) {
        return (*self.functionPointer)(input);
    } else {
        CGFloat epsilon = [self epsilon];
        CGFloat xSolved = [self solveCurveX:input epsilon:epsilon];
        CGFloat y = [self sampleCurveY:xSolved];
        return y;
    }
}

- (CGFloat)epsilon
{
    // Higher precision in the timing function for longer duration to avoid ugly discontinuities
    return 1.0 / (200.0 * self.duration);
}


- (void)calculatePolynomialCoefficients
{
    // Implicit first and last control points are (0,0) and (1,1).
    self.cx = 3.0 * self.controlPoint1.x;
    self.bx = 3.0 * (self.controlPoint2.x - self.controlPoint1.x) - self.cx;
    self.ax = 1.0 - self.cx - self.bx;
    
    self.cy = 3.0 * self.controlPoint1.y;
    self.by = 3.0 * (self.controlPoint2.y - self.controlPoint1.y) - self.cy;
    self.ay = 1.0 - self.cy - self.by;
}


- (CGFloat)sampleCurveX:(CGFloat)t
{
    // 'ax t^3 + bx t^2 + cx t' expanded using Horner's rule.
    return ((self.ax * t + self.bx) * t + self.cx) * t;
}


- (CGFloat)sampleCurveY:(CGFloat)t
{
    return ((self.ay * t + self.by) * t + self.cy) * t;
}


- (CGFloat)sampleCurveDerivativeX:(CGFloat)t
{
    return (3.0 * self.ax * t + 2.0 * self.bx) * t + self.cx;
}


// Given an x value, find a parametric value it came from.
- (CGFloat)solveCurveX:(CGFloat)x epsilon:(CGFloat)epsilon
{
    CGFloat t0;
    CGFloat t1;
    CGFloat t2;
    CGFloat x2;
    CGFloat d2;
    NSUInteger i;
    
    // First try a few iterations of Newton's method -- normally very fast.
    for (t2 = x, i = 0; i < 8; i++) {
        x2 = [self sampleCurveX:t2] - x;
        if (fabs(x2) < epsilon) {
            return t2;
        }
        d2 = [self sampleCurveDerivativeX:t2];
        if (fabs(d2) < 1e-6) {
            break;
        }
        t2 = t2 - x2 / d2;
    }
    
    // Fall back to the bisection method for reliability.
    t0 = 0.0;
    t1 = 1.0;
    t2 = x;
    
    if (t2 < t0) {
        return t0;
    }
    if (t2 > t1) {
        return t1;
    }
    
    while (t0 < t1) {
        x2 = [self sampleCurveX:t2];
        if (fabs(x2 - x) < epsilon) {
            return t2;
        }
        if (x > x2) {
            t0 = t2;
        } else {
            t1 = t2;
        }
        t2 = (t1 - t0) * 0.5 + t0;
    }
    
    // Failure.
    return t2;
}

@end
