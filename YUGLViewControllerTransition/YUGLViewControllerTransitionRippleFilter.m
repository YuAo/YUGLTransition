//
//  YUGLViewControllerTransitionRippleFilter.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUGLViewControllerTransitionRippleFilter.h"

NSString *const YUGLViewControllerTransitionRippleFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float progress;
 
 uniform float amplitude;
 uniform float speed;
 
 void main()
{
    vec2 p = textureCoordinate;
    vec2 dir = p - vec2(.5);
    float dist = length(dir);
    vec2 offset = dir * (sin(progress * dist * amplitude - progress * speed) + .5) / 30.;
    gl_FragColor = mix(texture2D(inputImageTexture, p + offset), texture2D(inputImageTexture2, p), smoothstep(0.2, 1.0, progress));
}
);


@interface YUGLViewControllerTransitionRippleFilter()
@property (nonatomic) GLint progressUniform;
@property (nonatomic) GLint amplitudeUniform;
@property (nonatomic) GLint speedUniform;
@end

@implementation YUGLViewControllerTransitionRippleFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:YUGLViewControllerTransitionRippleFilterFragmentShaderString]))
    {
		return nil;
    }
    self.progressUniform = [filterProgram uniformIndex:@"progress"];
    self.amplitudeUniform = [filterProgram uniformIndex:@"amplitude"];
    self.speedUniform = [filterProgram uniformIndex:@"speed"];
    
    self.progress = 0;
    self.amplitude = 100;
    self.speed = 50.0;
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setFloat:progress forUniform:self.progressUniform program:filterProgram];
}

- (void)setAmplitude:(CGFloat)amplitude {
    _amplitude = amplitude;
    [self setFloat:amplitude forUniform:self.amplitudeUniform program:filterProgram];
}

- (void)setSpeed:(CGFloat)speed {
    _speed = speed;
    [self setFloat:speed forUniform:self.speedUniform program:filterProgram];
}

@end
