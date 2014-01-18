//
//  YUGLTransitionRender.h
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/18/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YUGLTransitionFilter.h"

@interface YUGLTransitionRenderer : NSObject

- (id)initWithTransitionFilter:(YUGLTransitionFilter *)transitionFilter
                    inputImage:(UIImage *)inputImage
              inputTargetImage:(UIImage *)inputTargetImage;

@property (nonatomic) double progress;

@property (nonatomic,strong) id<GPUImageInput> renderTarget;

@end
