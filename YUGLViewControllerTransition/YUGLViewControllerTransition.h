//
//  YUGLViewControllerTransition.h
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage/GPUImage.h>
#import "YUGLViewControllerTransitionFilter.h"

@interface YUGLViewControllerTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic,strong) GPUImageFilter<YUGLViewControllerTransitionFilter> *transitionFilter;

@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) BOOL reverse;

@end
