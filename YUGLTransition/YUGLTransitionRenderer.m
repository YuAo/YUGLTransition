//
//  YUGLTransitionRender.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/18/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUGLTransitionRenderer.h"

@interface YUGLTransitionRenderer ()
@property (nonatomic,strong) YUGLTransitionFilter *filter;
@property (nonatomic,strong) GPUImagePicture *inputImage;
@property (nonatomic,strong) GPUImagePicture *targetImage;
@end

@implementation YUGLTransitionRenderer

- (id)initWithTransitionFilter:(YUGLTransitionFilter *)transitionFilter
                    inputImage:(UIImage *)inputImage
              inputTargetImage:(UIImage *)inputTargetImage
{
    if (self = [super init]) {
        self.filter = transitionFilter;
        self.filter.progress = 0;
        
        self.inputImage = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:NO];
        self.targetImage = [[GPUImagePicture alloc] initWithImage:inputTargetImage smoothlyScaleOutput:NO];
        
        [self.inputImage addTarget:self.filter];
        [self.targetImage addTarget:self.filter atTextureLocation:1];
    }
    return self;
}

- (void)render {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    BOOL inputImageProcessed = [self.inputImage processImageWithCompletionHandler:^{
        dispatch_semaphore_signal(semaphore);
    }];
    if (!inputImageProcessed) dispatch_semaphore_signal(semaphore);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    BOOL targetImageProcessed = [self.targetImage processImageWithCompletionHandler:^{
        dispatch_semaphore_signal(semaphore);
    }];
    if (!targetImageProcessed) dispatch_semaphore_signal(semaphore);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)setProgress:(double)progress {
    _progress = progress;
    self.filter.progress = progress;
    [self render];
}

- (void)setRenderTarget:(id<GPUImageInput>)renderTarget {
    _renderTarget = renderTarget;
    [self.filter removeAllTargets];
    [self.filter addTarget:renderTarget];
    [self render];
}

@end
