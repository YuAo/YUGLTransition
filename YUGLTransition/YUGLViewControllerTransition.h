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

@interface YUGLViewControllerTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic,strong) YUGLTransitionFilter *transitionFilter;

@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) BOOL reverse;

@property (nonatomic,strong) YUMediaTimingFunction *timingFunction;

@end
