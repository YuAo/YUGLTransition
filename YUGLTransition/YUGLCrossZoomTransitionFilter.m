//
//  YUGLCrossZoomTransitionFilter.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 10/8/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUGLCrossZoomTransitionFilter.h"

NSString *const YUGLCrossZoomTransitionFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float progress;
 
 uniform float strength;
 
 const float PI = 3.141592653589793;
 
 float Linear_ease(in float begin, in float change, in float duration, in float time) {
     return change * time / duration + begin;
 }
 
 float Exponential_easeInOut(in float begin, in float change, in float duration, in float time) {
     if (time == 0.0)
         return begin;
     else if (time == duration)
         return begin + change;
     time = time / (duration / 2.0);
     if (time < 1.0)
         return change / 2.0 * pow(2.0, 10.0 * (time - 1.0)) + begin;
     return change / 2.0 * (-pow(2.0, -10.0 * (time - 1.0)) + 2.0) + begin;
 }
 
 float Sinusoidal_easeInOut(in float begin, in float change, in float duration, in float time) {
     return -change / 2.0 * (cos(PI * time / duration) - 1.0) + begin;
 }
 
/* random number between 0 and 1 */
 float random(in vec3 scale, in float seed) {
     /* use the fragment position for randomness */
     return fract(sin(dot(gl_FragCoord.xyz + seed, scale)) * 43758.5453 + seed);
 }
 
 vec3 crossFade(in vec2 uv, in float dissolve) {
     return mix(texture2D(inputImageTexture, uv).rgb, texture2D(inputImageTexture2, uv).rgb, dissolve);
 }
 
 void main() {
     
     // Linear interpolate center across center half of the image
     vec2 center = vec2(Linear_ease(0.25, 0.5, 1.0, progress), 0.5);
     float dissolve = Exponential_easeInOut(0.0, 1.0, 1.0, progress);
     
     // Mirrored sinusoidal loop. 0->strength then strength->0
     float strength = Sinusoidal_easeInOut(0.0, strength, 0.5, progress);
     
     vec3 color = vec3(0.0);
     float total = 0.0;
     vec2 toCenter = center - textureCoordinate;
     
     /* randomize the lookup values to hide the fixed number of samples */
     float offset = random(vec3(12.9898, 78.233, 151.7182), 0.0);
     
     for (float t = 0.0; t <= 10.0; t++) {
         float percent = (t + offset) / 10.0;
         float weight = 4.0 * (percent - percent * percent);
         color += crossFade(textureCoordinate + toCenter * percent * strength, dissolve) * weight;
         total += weight;
     }
     gl_FragColor = vec4(color / total, 1.0);
 }
);

@interface YUGLCrossZoomTransitionFilter ()
@property (nonatomic) GLint progressUniform;
@property (nonatomic) GLint strengthUniform;
@end

@implementation YUGLCrossZoomTransitionFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:YUGLCrossZoomTransitionFilterFragmentShaderString]))
    {
        return nil;
    }
    
    self.progressUniform = [filterProgram uniformIndex:@"progress"];
    self.strengthUniform = [filterProgram uniformIndex:@"strength"];
    
    self.progress = 0;
    self.strength = 0.3;
    
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setFloat:progress forUniform:self.progressUniform program:filterProgram];
}

- (void)setStrength:(CGFloat)strength {
    _strength = strength;
    [self setFloat:strength forUniform:self.strengthUniform program:filterProgram];
}

@end
