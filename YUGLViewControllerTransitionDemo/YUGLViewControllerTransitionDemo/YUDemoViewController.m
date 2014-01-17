//
//  YUViewController.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUDemoViewController.h"
#import "YUGLViewControllerTransition.h"
#import "YUGLViewControllerTransitionCrossDissolveFilter.h"
#import "YUGLViewControllerTransitionFlashFilter.h"
#import "YUGLViewControllerTransitionFlyeyeFilter.h"
#import "YUGLViewControllerTransitionBlurFilter.h"
#import "YUGLViewControllerTransitionRippleFilter.h"
#import "YUGLViewControllerTransitionSwapFilter.h"

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
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:NSLocalizedString(@"Back", @"") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    backButton.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 44, CGRectGetWidth(self.view.bounds), 44);
    [self.view addSubview:backButton];
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

- (void)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    YUGLViewControllerTransition *transition = [[YUGLViewControllerTransition alloc] init];
    transition.duration = 1.0;
    transition.transitionFilter = [[YUGLViewControllerTransitionSwapFilter alloc] init];
    return transition;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    YUGLViewControllerTransition *transition = [[YUGLViewControllerTransition alloc] init];
    transition.duration = 1.0;
    transition.transitionFilter = [[YUGLViewControllerTransitionSwapFilter alloc] init];
    transition.reverse = YES;
    return transition;
}

@end
