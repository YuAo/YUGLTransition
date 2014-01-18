//
//  YUMediaTimingFunction.h
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef double (*YUMediaTimingCFunctionPointer)(double);

extern NSString * const YUMediaTimingFunctionDefault;
extern NSString * const YUMediaTimingFunctionLinear;
extern NSString * const YUMediaTimingFunctionEaseIn;
extern NSString * const YUMediaTimingFunctionEaseOut;
extern NSString * const YUMediaTimingFunctionEaseInEaseOut;

@interface YUMediaTimingFunction : NSObject

+ (id)functionWithCFunctionPointer:(YUMediaTimingCFunctionPointer)functionPointer;

/* A convenience method for creating common timing functions. The
 * currently supported names are `linear', `easeIn', `easeOut' and
 * `easeInEaseOut' and `default' (the curve used by implicit animations
 * created by Core Animation). */

+ (id)functionWithName:(NSString *)name;

/* Creates a timing function modelled on a cubic Bezier curve. The end
 * points of the curve are at (0,0) and (1,1), the two points 'c1' and
 * 'c2' defined by the class instance are the control points. Thus the
 * points defining the Bezier curve are: '[(0,0), c1, c2, (1,1)]' */

+ (id)functionWithControlPoints:(float)c1x :(float)c1y :(float)c2x :(float)c2y;

- (id)initWithControlPoints:(float)c1x :(float)c1y :(float)c2x :(float)c2y;

/* 'idx' is a value from 0 to 3 inclusive. */

- (void)getControlPointAtIndex:(size_t)idx values:(float[2])ptr;

- (double)valueForInput:(double)input;

@end
