//
//  YUGLPowDistortionTransitionFilter.h
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 10/8/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "YUGLTransitionFilter.h"

@interface YUGLPowDistortionTransitionFilter : GPUImageTwoInputFilter <YUGLTransitionFilter>
@property (nonatomic) CGFloat progress;
@end
