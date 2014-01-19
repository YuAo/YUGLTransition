//
//  YUGLDoorwayTransitionFilter.h
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/19/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "GPUImageTwoInputFilter.h"
#import "YUGLTransitionFilter.h"

@interface YUGLDoorwayTransitionFilter : GPUImageTwoInputFilter <YUGLTransitionFilter>
@property (nonatomic) CGFloat progress;
@property (nonatomic) CGFloat reflection;
@property (nonatomic) CGFloat perspective;
@property (nonatomic) CGFloat depth;
@end
