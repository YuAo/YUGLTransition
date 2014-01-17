//
//  YUViewController.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUDemoViewController.h"

@interface YUDemoViewControllerBackgroundImageManager : NSObject
@property (nonatomic) NSUInteger index;
@property (nonatomic) NSUInteger totalNumberOfImages;
+ (instancetype)sharedManager;
@end

@implementation YUDemoViewControllerBackgroundImageManager

+ (instancetype)sharedManager {
    static YUDemoViewControllerBackgroundImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YUDemoViewControllerBackgroundImageManager alloc] init];
    });
    return manager;
}

- (id)init {
    if (self = [super init]) {
        self.totalNumberOfImages = 4;
        self.index = 0;
    }
    return self;
}

- (void)prepareNextBackgroundImage {
    self.index = (self.index + 1) % self.totalNumberOfImages;
}

- (UIImage *)backgroundImage {
    NSString *imageName = [NSString stringWithFormat:@"%lu.jpg",(unsigned long)self.index];
    return [UIImage imageNamed:imageName];
}

@end

@interface YUDemoViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic,weak) UIImageView *imageView;
@end

@implementation YUDemoViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIImageView *imageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.userInteractionEnabled = YES;
        imageView;
    });
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = [[YUDemoViewControllerBackgroundImageManager sharedManager] backgroundImage];
    [[YUDemoViewControllerBackgroundImageManager sharedManager] prepareNextBackgroundImage];
}

- (void)imageViewTapped:(id)sender {
    YUDemoViewController *nextViewController = [[YUDemoViewController alloc] init];
    nextViewController.transitioningDelegate = self;
    [self presentViewController:nextViewController animated:YES completion:nil];
}

@end
