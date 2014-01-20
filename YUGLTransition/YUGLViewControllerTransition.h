//
//  YUGLViewControllerTransition.h
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage/GPUImage.h>
#import "YUGLTransitionFilter.h"
#import "YUMediaTimingFunction.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0

@interface YUGLViewControllerTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic,strong) YUGLTransitionFilter *transitionFilter;

@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) BOOL reverse;

@property (nonatomic,strong) YUMediaTimingFunction *timingFunction;

@end

#endif
