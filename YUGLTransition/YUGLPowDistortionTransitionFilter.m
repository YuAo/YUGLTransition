//
//  YUGLPowDistortionTransitionFilter.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 10/8/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUGLPowDistortionTransitionFilter.h"

NSString *const YUGLPowDistortionTransitionFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;

 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;

 uniform float progress;
 
 void main() {
     vec2 p = textureCoordinate;
     vec4 t1=texture2D(inputImageTexture,vec2(pow(p.x,1.-progress),pow(p.y,1.-progress)));
     vec4 t2=texture2D(inputImageTexture2,vec2(pow(p.x,progress),pow(p.y,progress)));
     gl_FragColor = mix(t1, t2, progress);
 }
);

@interface YUGLPowDistortionTransitionFilter ()
@property (nonatomic) GLint progressUniform;
@end

@implementation YUGLPowDistortionTransitionFilter


- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:YUGLPowDistortionTransitionFilterFragmentShaderString]))
    {
        return nil;
    }
    
    self.progressUniform = [filterProgram uniformIndex:@"progress"];
    self.progress = 0;
    
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setFloat:progress forUniform:self.progressUniform program:filterProgram];
}


@end
