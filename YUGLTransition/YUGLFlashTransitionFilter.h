//
//  YUGLViewControllerTransitionFlashFilter.h
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "GPUImageTwoInputFilter.h"
#import "YUGLTransitionFilter.h"

@interface YUGLFlashTransitionFilter : GPUImageTwoInputFilter <YUGLTransitionFilter>
@property (nonatomic) CGFloat progress;

@property (nonatomic) CGFloat flashPhase;
@property (nonatomic) CGFloat flashIntensity;
@property (nonatomic) CGFloat flashZoomEffect;
@end
