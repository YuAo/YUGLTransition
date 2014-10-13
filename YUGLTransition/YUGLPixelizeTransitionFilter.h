//
//  YUGLPixelizeTransitionFilter.h
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 10/8/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "YUGLTransitionFilter.h"

@interface YUGLPixelizeTransitionFilter : GPUImageTwoInputFilter <YUGLTransitionFilter>
@property (nonatomic) CGFloat progress;
@property (nonatomic) CGFloat squareSize;
@end
