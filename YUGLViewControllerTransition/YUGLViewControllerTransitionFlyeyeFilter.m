//
//  YUGLViewControllerTransitionFlyeyeFilter.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUGLViewControllerTransitionFlyeyeFilter.h"

NSString *const YUGLViewControllerTransitionFlyeyeFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float progress;
 
 // Custom parameters
 uniform float size;
 uniform float zoom;
 
 void main() {
     vec2 p = textureCoordinate;
     float inv = 1. - progress;
     vec2 disp = size*vec2(cos(zoom*p.x), sin(zoom*p.y));
     vec4 texTo = texture2D(inputImageTexture2, p + inv*disp);
     vec4 texFrom = texture2D(inputImageTexture, p + progress*disp);
     gl_FragColor = texTo*progress + texFrom*inv;
 }
);

@interface YUGLViewControllerTransitionFlyeyeFilter ()
@property (nonatomic) GLint progressUniform;
@property (nonatomic) GLint sizeUniform;
@property (nonatomic) GLint zoomUniform;
@end

@implementation YUGLViewControllerTransitionFlyeyeFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:YUGLViewControllerTransitionFlyeyeFilterFragmentShaderString]))
    {
		return nil;
    }
    self.progressUniform = [filterProgram uniformIndex:@"progress"];
    self.sizeUniform = [filterProgram uniformIndex:@"size"];
    self.zoomUniform = [filterProgram uniformIndex:@"zoom"];

    self.progress = 0;
    self.size = 0.1;
    self.zoom = 40.0;
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setFloat:progress forUniform:self.progressUniform program:filterProgram];
}

- (void)setSize:(CGFloat)size {
    _size = size;
    [self setFloat:size forUniform:self.sizeUniform program:filterProgram];
}

- (void)setZoom:(CGFloat)zoom {
    _zoom = zoom;
    [self setFloat:zoom forUniform:self.zoomUniform program:filterProgram];
}

@end
