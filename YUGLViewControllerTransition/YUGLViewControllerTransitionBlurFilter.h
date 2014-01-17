//
//  YUGLViewControllerTransitionBlurFilter.h
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "GPUImageTwoInputFilter.h"
#import "YUGLViewControllerTransitionFilter.h"

@interface YUGLViewControllerTransitionBlurFilter : GPUImageTwoInputFilter <YUGLViewControllerTransitionFilter>
@property (nonatomic) CGFloat size;
@property (nonatomic) CGFloat progress;
@end
