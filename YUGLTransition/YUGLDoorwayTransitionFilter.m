//
//  YUGLDoorwayTransitionFilter.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/19/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUGLDoorwayTransitionFilter.h"

NSString *const YUGLDoorwayTransitionFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float progress;
 
 uniform float reflection;
 uniform float perspective;
 uniform float depth;
 
 const vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
 const vec2 boundMin = vec2(0.0, 0.0);
 const vec2 boundMax = vec2(1.0, 1.0);
 
 int inBounds (vec2 p) {
     if(all(lessThan(boundMin, p)) && all(lessThan(p, boundMax))){
         return 1;
     } else {
         return 0;
     }
 }
 
 vec2 project (vec2 p) {
     return p * vec2(1.0, -1.0) + vec2(0.0, 2.01);
 }
 
 vec4 bgColor (vec2 p, vec2 pto) {
     vec4 c = black;
     pto = project(pto);
     if (inBounds(pto) > 0) {
         c += mix(black, texture2D(inputImageTexture2, pto), reflection * mix(0.0, 1.0, pto.y));
     }
     return c;
 }
 
 void main() {
     vec2 p = textureCoordinate;
     
     vec2 pfr = vec2(-1.);
     vec2 pto = vec2(-1.);
     
     float middleSlit = 2.0 * abs(p.x-0.5) - progress;
     if (middleSlit > 0.0) {
         pfr = p + (p.x > 0.5 ? -1.0 : 1.0) * vec2(0.5*progress, 0.0);
         float d = 1.0/(1.0+perspective*progress*(1.0-middleSlit));
         pfr.y -= d/2.;
         pfr.y *= d;
         pfr.y += d/2.;
     }
     
     float size = mix(1.0, depth, 1.-progress);
     pto = (p + vec2(-0.5, -0.5)) * vec2(size, size) + vec2(0.5, 0.5);
     
     if (inBounds(pfr) > 0) {
         gl_FragColor = texture2D(inputImageTexture, pfr);
     }
     else if (inBounds(pto) > 0) {
         gl_FragColor = texture2D(inputImageTexture2, pto);
     }
     else {
         gl_FragColor = bgColor(p, pto);
     }
 }
);

@interface YUGLDoorwayTransitionFilter ()
@property (nonatomic) GLint progressUniform;
@property (nonatomic) GLint reflectionUniform;
@property (nonatomic) GLint perspectiveUniform;
@property (nonatomic) GLint depthUniform;
@end

@implementation YUGLDoorwayTransitionFilter


- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:YUGLDoorwayTransitionFilterFragmentShaderString]))
    {
		return nil;
    }
    self.progressUniform = [filterProgram uniformIndex:@"progress"];
    self.reflectionUniform = [filterProgram uniformIndex:@"reflection"];
    self.perspectiveUniform = [filterProgram uniformIndex:@"perspective"];
    self.depthUniform = [filterProgram uniformIndex:@"depth"];
    
    self.progress = 0;
    self.reflection = 0.4;
    self.perspective = 0.4;
    self.depth = 3.0;
    
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setFloat:progress forUniform:self.progressUniform program:filterProgram];
}

- (void)setReflection:(CGFloat)reflection {
    _reflection = reflection;
    [self setFloat:reflection forUniform:self.reflectionUniform program:filterProgram];
}

- (void)setPerspective:(CGFloat)perspective {
    _perspective = perspective;
    [self setFloat:perspective forUniform:self.perspectiveUniform program:filterProgram];
}

- (void)setDepth:(CGFloat)depth{
    _depth = depth;
    [self setFloat:depth forUniform:self.depthUniform program:filterProgram];
}

@end
