//
//  YUGLViewTransition.h
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/18/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YUGLTransitionFilter.h"
#import "YUMediaTimingFunction.h"

@interface YUGLViewTransition : NSObject

+ (YUGLViewTransition *)transitionWithView:(UIView *)view
                                  duration:(NSTimeInterval)duration
                          transitionFilter:(YUGLTransitionFilter *)transitionFilter
                            timingFunction:(YUMediaTimingFunction *)timingFunction
                                  reversed:(BOOL)reversed
                                animations:(void (^)(void))animations
                                completion:(void (^)(BOOL finished))completion;

- (void)stop;

@end
