#YUGLTransition
---
OpenGL based transition for iOS.

##Overview

The YUGLTransition is a library that lets you create GPU-based transition to UIView and UIViewController.

It uses [GPUImage](https://github.com/BradLarson/GPUImage) for the rendering part.

There're some ready-to-use transition effects, like ripple, swap, doorway, flash, flyeye, etc. And it allows you to create your own custom transitions by providing your custom transition filter.

##Usage

###YUGLViewTransition

Use `YUGLViewTransition` to create view transition.

```
[YUGLViewTransition transitionWithView:self.imageView
                              duration:1.0
                      transitionFilter:[[YUGLFlashTransitionFilter alloc] init]
                        timingFunction:nil
                              reversed:NO
                            animations:^{
                                self.imageView.image = nextImage;
                            } completion:^(BOOL finished) {
                                NSLog(@"transition completed.");
                            }];
```

`view` : the UIView object where transition take place.

`duration` : transition duration.

`transitionFilter` : a `GPUImageOutput<GPUImageInput,YUGLTransitionFilter>` (basically a `GPUImageFilter`) object that defines the transition.

`timingFunction` : a `YUMediaTimingFunction` object that controls the transition animation curve. Just like `CAMediaTimingFunction`.

`reversed` : indicates whether the reverse version of a transition should be used.

`animations` : A block object containing the changes to commit to the `view`.

`completion` : A block object to be executed when the transition ends.

###YUGLViewControllerTransition

Use `YUGLViewControllerTransition` to create transitions between view controllers.

`YUGLViewControllerTransition` is just a class that confirms the `UIViewControllerAnimatedTransitioning` protocol. You can use this class in the view controller transition process. [See more about `UIViewControllerAnimatedTransitioning` from Apple](https://developer.apple.com/library/ios/documentation/uikit/reference/UIViewControllerAnimatedTransitioning_Protocol/Reference/Reference.html).