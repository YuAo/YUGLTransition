//
//  YUGLViewTransition.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/18/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUGLViewTransition.h"
#import "YUGLTransitionRenderer.h"

@interface YUMediaTimingFunction (Private)
@property (nonatomic) NSTimeInterval duration;
@end

@interface YUGLViewTransition ()

@property (nonatomic,weak)   GPUImageView           *renderSurface;
@property (nonatomic,strong) YUMediaTimingFunction  *timingFunction;
@property (nonatomic)        NSTimeInterval         duration;

@property (nonatomic,strong) YUGLTransitionRenderer *transitionRenderer;
@property (nonatomic,weak)   CADisplayLink          *displayLink;
@property (nonatomic)        NSTimeInterval         transitionStartTimestamp;

@property (nonatomic,copy)   void  (^completionBlock)(BOOL);

@end

@implementation YUGLViewTransition

+ (UIImage *)snapshotImageForView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (YUGLViewTransition *)transitionWithView:(UIView *)view
                                  duration:(NSTimeInterval)duration
                          transitionFilter:(YUGLTransitionFilter *)transitionFilter
                            timingFunction:(YUMediaTimingFunction *)timingFunction
                                animations:(void (^)(void))animations
                                completion:(void (^)(BOOL))completion
{
    YUGLViewTransition *transition = [[YUGLViewTransition alloc] initWithReferenceView:view duration:duration transitionFilter:transitionFilter timingFunction:timingFunction animations:animations completion:completion];
    return transition;
}

- (id)initWithReferenceView:(UIView *)view
                   duration:(NSTimeInterval)duration
           transitionFilter:(YUGLTransitionFilter *)transitionFilter
             timingFunction:(YUMediaTimingFunction *)timingFunction
                 animations:(void (^)(void))animations
                 completion:(void (^)(BOOL))completion
{
    if (self = [super init]) {
        self.duration = duration;
        self.completionBlock = completion;
        
        UIImage *inputImage = [YUGLViewTransition snapshotImageForView:view];
        if (animations) animations();
        UIImage *targetImage = [YUGLViewTransition snapshotImageForView:view];
        
        GPUImageView *renderSurface = [[GPUImageView alloc] initWithFrame:view.bounds];
        renderSurface.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [view addSubview:renderSurface];
        self.renderSurface = renderSurface;
        
        self.timingFunction = timingFunction;
        
        self.transitionRenderer = [[YUGLTransitionRenderer alloc] initWithTransitionFilter:transitionFilter inputImage:inputImage inputTargetImage:targetImage];
        self.transitionRenderer.renderTarget = renderSurface;
        
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTransition:)];
        self.displayLink = displayLink;
        self.transitionStartTimestamp = 0;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)stop {
    if (self.displayLink && self.transitionRenderer.progress < 1) {
        [self.displayLink invalidate];
        [self.renderSurface removeFromSuperview];
        if (self.completionBlock) self.completionBlock(NO);
    }
}

- (void)updateTransition:(CADisplayLink *)sender {
    if (!self.transitionStartTimestamp) self.transitionStartTimestamp = sender.timestamp;
    
    double progress = MAX(0, MIN((sender.timestamp - self.transitionStartTimestamp) / self.duration, 1));
    
    if (self.timingFunction) {
        self.timingFunction.duration = self.duration;
        progress = [self.timingFunction valueForInput:progress];
    }
    
    if (progress >= 1) {
        [self.displayLink invalidate];
        [self.renderSurface removeFromSuperview];
        if (self.completionBlock) self.completionBlock(YES);
    } else {
        self.transitionRenderer.progress = progress;
    }
}

@end
