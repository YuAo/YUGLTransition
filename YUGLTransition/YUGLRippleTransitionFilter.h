//
//  YUGLViewControllerTransitionRippleFilter.h
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "YUGLTransitionFilter.h"

@interface YUGLRippleTransitionFilter : GPUImageTwoInputFilter <YUGLTransitionFilter>
@property (nonatomic) CGFloat progress;
@property (nonatomic) CGFloat amplitude;
@property (nonatomic) CGFloat speed;
@end
