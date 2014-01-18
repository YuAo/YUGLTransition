//
//  YUGLViewControllerTransitionFilter.h
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage/GPUImage.h>

@protocol YUGLTransitionFilter <NSObject>

@property (nonatomic) CGFloat progress;

@end

typedef GPUImageOutput<GPUImageInput,YUGLTransitionFilter> YUGLTransitionFilter;