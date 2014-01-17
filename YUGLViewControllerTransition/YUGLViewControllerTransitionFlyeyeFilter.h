//
//  YUGLViewControllerTransitionFlyeyeFilter.h
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "GPUImageTwoInputFilter.h"
#import "YUGLViewControllerTransitionFilter.h"

@interface YUGLViewControllerTransitionFlyeyeFilter : GPUImageTwoInputFilter <YUGLViewControllerTransitionFilter>
@property (nonatomic) CGFloat progress;
@property (nonatomic) CGFloat size;
@property (nonatomic) CGFloat zoom;
@end
