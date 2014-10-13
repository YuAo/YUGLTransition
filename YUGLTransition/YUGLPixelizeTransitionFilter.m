//
//  YUGLPixelizeTransitionFilter.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 10/8/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUGLPixelizeTransitionFilter.h"

NSString * const YUGLPixelizeTransitionFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;

 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float progress;
 uniform float squareSizeFactor;
 
 float rand(vec2 co){
     return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
 }
 
 void main() {
     float revProgress = (1.0 - progress);
     float distFromEdges = min(progress, revProgress);
     float squareSize = (squareSizeFactor * distFromEdges) + 1.0;
     
     //textureCoordinate = gl_FragCoord.xy/resolution.xy
     
     vec2 p = (floor((gl_FragCoord.xy + squareSize * 0.5) / squareSize) * squareSize) / (gl_FragCoord.xy/textureCoordinate);
     
     vec4 fromColor = texture2D(inputImageTexture, p);
     vec4 toColor = texture2D(inputImageTexture2, p);
     
     gl_FragColor = mix(fromColor, toColor, progress);
 }
);

@interface YUGLPixelizeTransitionFilter ()
@property (nonatomic) GLint progressUniform;
@property (nonatomic) GLint squareSizeUniform;
@end

@implementation YUGLPixelizeTransitionFilter

- (instancetype)init {
    if (self = [super initWithFragmentShaderFromString:YUGLPixelizeTransitionFilterFragmentShaderString]) {
        self.progressUniform = [filterProgram uniformIndex:@"progress"];
        self.squareSizeUniform = [filterProgram uniformIndex:@"squareSizeFactor"];
        self.progress = 0;
        self.squareSize = 100;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setFloat:progress forUniform:self.progressUniform program:filterProgram];
}

- (void)setSquareSize:(CGFloat)squareSize {
    _squareSize = squareSize;
    [self setFloat:squareSize forUniform:self.squareSizeUniform program:filterProgram];
}

@end
