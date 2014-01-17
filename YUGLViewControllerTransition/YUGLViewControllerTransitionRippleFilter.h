//
//  YUGLViewControllerTransitionRippleFilter.h
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "GPUImageTwoInputFilter.h"
#import "YUGLViewControllerTransitionFilter.h"

@interface YUGLViewControllerTransitionRippleFilter : GPUImageTwoInputFilter <YUGLViewControllerTransitionFilter>
@property (nonatomic) CGFloat progress;
@property (nonatomic) CGFloat amplitude;
@property (nonatomic) CGFloat speed;
@end
