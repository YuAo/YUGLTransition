//
//  YUGLViewControllerTransitionFlashFilter.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUGLFlashTransitionFilter.h"


NSString *const YUGLFlashTransitionFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float progress;
 
 uniform float flashPhase; // if 0.0, the image directly turn grayscale, if 0.9, the grayscale transition phase is very important
 uniform float flashIntensity;
 uniform float flashZoomEffect;
 
 const vec3 flashColor = vec3(1.0, 0.8, 0.3);
 const float flashVelocity = 3.0;
 
 void main() {
     vec2 p = textureCoordinate;
     vec4 fc = texture2D(inputImageTexture, p);
     vec4 tc = texture2D(inputImageTexture2, p);
     float intensity = mix(1.0, 2.0*distance(p, vec2(0.5, 0.5)), flashZoomEffect) * flashIntensity * pow(smoothstep(flashPhase, 0.0, distance(0.5, progress)), flashVelocity);
     vec4 c = mix(texture2D(inputImageTexture, p), texture2D(inputImageTexture2, p), smoothstep(0.5*(1.0-flashPhase), 0.5*(1.0+flashPhase), progress));
     c += intensity * vec4(flashColor, 1.0);
     gl_FragColor = c;
 }
);

@interface YUGLFlashTransitionFilter ()
@property (nonatomic) GLint progressUniform;
@property (nonatomic) GLint flashPhaseUniform;
@property (nonatomic) GLint flashIntensityUniform;
@property (nonatomic) GLint flashZoomEffectUniform;
@end

@implementation YUGLFlashTransitionFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:YUGLFlashTransitionFilterFragmentShaderString]))
    {
		return nil;
    }
    self.progressUniform = [filterProgram uniformIndex:@"progress"];
    self.flashPhaseUniform = [filterProgram uniformIndex:@"flashPhase"];
    self.flashIntensityUniform = [filterProgram uniformIndex:@"flashIntensity"];
    self.flashZoomEffectUniform = [filterProgram uniformIndex:@"flashZoomEffect"];
    self.progress = 0;
    self.flashPhase = 0.6;
    self.flashIntensity = 3.0;
    self.flashZoomEffect = 0.5;
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setFloat:progress forUniform:self.progressUniform program:filterProgram];
}

- (void)setFlashPhase:(CGFloat)flashPhase {
    _flashPhase = flashPhase;
    [self setFloat:flashPhase forUniform:self.flashPhaseUniform program:filterProgram];
}

- (void)setFlashIntensity:(CGFloat)flashIntensity {
    _flashIntensity = flashIntensity;
    [self setFloat:flashIntensity forUniform:self.flashIntensityUniform program:filterProgram];
}

- (void)setFlashZoomEffect:(CGFloat)flashZoomEffect {
    _flashZoomEffect = flashZoomEffect;
    [self setFloat:flashZoomEffect forUniform:self.flashZoomEffectUniform program:filterProgram];
}

@end
