//
//  YUGLViewControllerTransitionFlyeyeFilter.h
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "YUGLTransitionFilter.h"

@interface YUGLFlyeyeTransitionFilter : GPUImageTwoInputFilter <YUGLTransitionFilter>
@property (nonatomic) CGFloat progress;
@property (nonatomic) CGFloat size;
@property (nonatomic) CGFloat zoom;
@end
