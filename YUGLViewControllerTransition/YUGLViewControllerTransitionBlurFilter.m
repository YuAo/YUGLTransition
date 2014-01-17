//
//  YUGLViewControllerTransitionBlurFilter.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUGLViewControllerTransitionBlurFilter.h"

NSString *const YUGLViewControllerTransitionBlurFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float progress;
 
 // Custom parameters
 uniform float size;
 
 vec4 blur(sampler2D t, vec2 c, float b) {
     vec4 sum = texture2D(t, c);
     sum += texture2D(t, c+b*vec2(-0.326212, -0.405805));
     sum += texture2D(t, c+b*vec2(-0.840144, -0.073580));
     sum += texture2D(t, c+b*vec2(-0.695914,  0.457137));
     sum += texture2D(t, c+b*vec2(-0.203345,  0.620716));
     sum += texture2D(t, c+b*vec2( 0.962340, -0.194983));
     sum += texture2D(t, c+b*vec2( 0.473434, -0.480026));
     sum += texture2D(t, c+b*vec2( 0.519456,  0.767022));
     sum += texture2D(t, c+b*vec2( 0.185461, -0.893124));
     sum += texture2D(t, c+b*vec2( 0.507431,  0.064425));
     sum += texture2D(t, c+b*vec2( 0.896420,  0.412458));
     sum += texture2D(t, c+b*vec2(-0.321940, -0.932615));
     sum += texture2D(t, c+b*vec2(-0.791559, -0.597705));
     return sum / 13.0;
 }
 
 void main()
{
    vec2 p = textureCoordinate;
    float inv = 1.-progress;
    gl_FragColor = inv*blur(inputImageTexture, p, progress*size) + progress*blur(inputImageTexture2, p, inv*size);
}
);

@interface YUGLViewControllerTransitionBlurFilter ()
@property (nonatomic) GLint progressUniform;
@property (nonatomic) GLint sizeUniform;
@end

@implementation YUGLViewControllerTransitionBlurFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:YUGLViewControllerTransitionBlurFilterFragmentShaderString]))
    {
		return nil;
    }
    
    self.progressUniform = [filterProgram uniformIndex:@"progress"];
    self.sizeUniform = [filterProgram uniformIndex:@"size"];
    
    self.progress = 0;
    self.size = 0.03;
    
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

@end
