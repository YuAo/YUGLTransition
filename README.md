#YUGLTransition
---
OpenGL based transition for iOS. Based on [GPUImage](https://github.com/BradLarson/GPUImage).

##Overview

The YUGLTransition is a library that lets you create GPU-based transition to UIView and UIViewController.

It uses [GPUImage](https://github.com/BradLarson/GPUImage) for the rendering part.

There're some ready-to-use transition effects, like ripple, swap, doorway, flash, flyeye, etc. And it allows you to create your own custom transitions by providing your custom transition filter.

##Transitions

###Preset

There're six preset transition filters currently.
`YUGLCrossDissolveTransitionFilter` `YUGLFlashTransitionFilter` `YUGLFlyeyeTransitionFilter` `YUGLRippleTransitionFilter` `YUGLSwapTransitionFilter` `YUGLDoorwayTransitionFilter`

Most of the preset filters are ported from [glsl-transtion](https://github.com/gre/glsl-transition) (A javascript library that uses WebGL Shaders to perform transition). You can see demos of the transitions [here](https://gre.github.com/glsl-transition/example).

###Custom

You can create your own transition filter by subclassing `GPUImageFilter`, providing your transition shaders and confirming to the `YUGLTransitionFilter` protocol which only have one property: `progress`. All the preset filters are great examples.

Pull requests for new transition filters are welcome.

##Performance

Performance varies with devices and the filter you choose (the custom shader you write).

For instance, iPhone 4 is capable of performing a full-screen transition with flash transition filter, but it's hard for it to perform the transition with swap filter.

In general, __iPhone 4s__ is capable of playing with all the transition filters currently in this project.

*Note:* The performance of a transition on a real device usually improves, compared to that on the simulator.

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

`view` : The UIView object where the transition take place.

`duration` : Transition duration.

`transitionFilter` : A `GPUImageOutput<GPUImageInput,YUGLTransitionFilter>` (basically a `GPUImageFilter`) object which is used for rendering the transition.

`timingFunction` : A `YUMediaTimingFunction` object that controls the transition animation curve. Just like `CAMediaTimingFunction`.

`reversed` : Indicates whether the reverse version of the transition should be used.

`animations` : A block object containing the changes to commit to the `view`.

`completion` : A block object to be executed when the transition ends.

###YUGLViewControllerTransition

Use `YUGLViewControllerTransition` to create transitions between view controllers.

`YUGLViewControllerTransition` is just a class that confirms the `UIViewControllerAnimatedTransitioning` protocol. You can use this class in the view controller transition process. [See more about `UIViewControllerAnimatedTransitioning` from Apple](https://developer.apple.com/library/ios/documentation/uikit/reference/UIViewControllerAnimatedTransitioning_Protocol/Reference/Reference.html).

##Requirements

* Automatic Reference Counting (ARC)
* iOS 7.0+
* Xcode 5.0+
* Demo project requires [cocoapods](http://cocoapods.org/): `pod install`

##Contributing

If you find a bug and know exactly how to fix it, please open a pull request. If you can't make the change yourself, please open an issue after making sure that one isn't already logged.
