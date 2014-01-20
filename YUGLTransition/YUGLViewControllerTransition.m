//
//  YUGLViewControllerTransition.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUGLViewControllerTransition.h"
#import "YUGLViewTransition.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0

@implementation YUGLViewControllerTransition

- (id)init {
    if (self = [super init]) {
        self.duration = 0.3;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *sandboxView = [transitionContext containerView];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    
    [YUGLViewTransition transitionWithView:sandboxView
                                  duration:self.duration
                          transitionFilter:self.transitionFilter
                            timingFunction:self.timingFunction
                                  reversed:self.reverse
                                animations:^{
                                    [sandboxView addSubview:toViewController.view];
                                } completion:^(BOOL finished) {
                                    [transitionContext completeTransition:finished];
                                }];
}

@end

#endif
