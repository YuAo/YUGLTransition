//
//  YUGLViewControllerTransition.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUGLViewControllerTransition.h"

@interface YUGLViewControllerTransition ()
@property (nonatomic,weak) CADisplayLink *displayLink;
@property (nonatomic,weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic,strong) GPUImagePicture *fromViewControllerViewSnapshot;
@property (nonatomic,strong) GPUImagePicture *toViewControllerViewSnapshot;
@property (nonatomic) NSTimeInterval animationStartTimestamp;
@end

@implementation YUGLViewControllerTransition

- (id)init {
    if (self = [super init]) {
        self.duration = 0.3;
    }
    return self;
}

- (UIImage *)snapshotImageForView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    UIView *sandboxView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    GPUImageView *renderView = [[GPUImageView alloc] initWithFrame:sandboxView.bounds];
    renderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [sandboxView addSubview:renderView];
    
    self.fromViewControllerViewSnapshot = [[GPUImagePicture alloc] initWithImage:[self snapshotImageForView:fromViewController.view]];
    self.toViewControllerViewSnapshot = [[GPUImagePicture alloc] initWithImage:[self snapshotImageForView:toViewController.view]];
    
    [self.transitionFilter removeAllTargets];
    
    if (self.reverse) {
        [self.fromViewControllerViewSnapshot addTarget:self.transitionFilter atTextureLocation:1];
        [self.toViewControllerViewSnapshot addTarget:self.transitionFilter];
        self.transitionFilter.progress = 1;
    } else {
        [self.fromViewControllerViewSnapshot addTarget:self.transitionFilter];
        [self.toViewControllerViewSnapshot addTarget:self.transitionFilter atTextureLocation:1];
        self.transitionFilter.progress = 0;
    }

    [self.transitionFilter addTarget:renderView];
    [self.fromViewControllerViewSnapshot processImage];
    [self.toViewControllerViewSnapshot processImage];
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    self.displayLink = displayLink;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.animationStartTimestamp = 0;
}

double QuadraticEaseInOut(double p)
{
	if(p < 0.5)
	{
		return 2 * p * p;
	}
	else
	{
		return (-2 * p * p) + (4 * p) - 1;
	}
}

- (void)update:(CADisplayLink *)sender {
    if (!self.animationStartTimestamp) self.animationStartTimestamp = sender.timestamp;
    
    double progress = MAX(0, MIN((sender.timestamp - self.animationStartTimestamp) / self.duration, 1));
    progress = QuadraticEaseInOut(progress);
    
    if (self.reverse) progress = 1 - progress;
    
    if ( (!self.reverse && progress >= 1) || (self.reverse && progress <= 0)) {
        [self.displayLink invalidate];
        [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    } else {
        self.transitionFilter.progress = progress;
        [self.fromViewControllerViewSnapshot processImage];
        [self.toViewControllerViewSnapshot processImage];
    }
}

@end
