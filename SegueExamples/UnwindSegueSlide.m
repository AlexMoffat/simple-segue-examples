//
//  SegueSlideLeft.m
//
//  Copyright (c) 2012 Alex Moffat. All rights reserved.
//
//  Base class for unwind segues that slide the source
//  image out of the way to reveal the destination.

#import <QuartzCore/QuartzCore.h>
#import "UnwindSegueSlide.h"

@implementation UnwindSegueSlide

// On starting the animation hide the source view so that it doesn't show
// through the image of the destination view which starts out semitransparent.
- (void)firstAnimationDidStart
{
    [super firstAnimationDidStart];
    
    ((UIViewController *)[self sourceViewController]).view.hidden = YES;
}

// On completing the animation show the new controller
// and remove the two layers that were animated.
- (void)lastAnimationDidStop
{        
    // The destination view controller was the one that presented the source
    // view controler so must dismiss it.
    [[self destinationViewController] dismissViewControllerAnimated:NO completion:NULL];
        
    [self removeSrcAndDstLayers];
    
    [super lastAnimationDidStop];
}

// Move the src image, that is the starting image which will be on top of the
// destination image, out of the way to reveal the destination image.
- (CAAnimation *)srcTranslation: (CGRect)bounds
{
    // Move from current position to the final position.
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translation.toValue = [NSNumber numberWithFloat:bounds.size.width];
    
    return translation;
}

// Create the animation to use for the source image.
- (CAAnimation *)createSlideAnimation: (CGRect)srcBounds withDuration: (CGFloat)duration
{
    // See "SegueSlide createSourceAnimationWithDuration" for comments on
    // animation properties that have no comments here.

    // Going to use two animations so group them.
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.delegate = self;
    animations.fillMode = kCAFillModeForwards;
    animations.removedOnCompletion = NO;
    animations.duration = duration;
    animations.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    // Fade out from fully opaque to fadedOpacity.
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = [NSNumber numberWithFloat:1.0f];
    opacity.toValue = [NSNumber numberWithFloat:fadedOpacity];
    
    // Add the fade animation and the src translation animation
    // provided by a subclass to the group.
    animations.animations = [NSArray arrayWithObjects:[self srcTranslation:srcBounds], opacity, nil];
    
    return animations;
}

// Create the animation to use for the destination image.
- (CAAnimation *)createDestinationAnimationWithDuration: (CGFloat)duration
{
    // See "SegueSlide createSourceAnimationWithDuration" for comments on
    // animation properties that have no comments here.
    
    // Fade in from fadedOpacity to fully opaque.
    CABasicAnimation *dstOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    dstOpacity.delegate = self;
    dstOpacity.fillMode = kCAFillModeForwards;
    dstOpacity.removedOnCompletion = NO;
    dstOpacity.duration = duration;
    dstOpacity.fromValue = [NSNumber numberWithFloat:fadedOpacity];
    dstOpacity.toValue = [NSNumber numberWithFloat:1.0f];
    dstOpacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return dstOpacity;
}

// Slide the source out of the way to reveal the destination.
- (void)slideAndFade
{
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dst = (UIViewController *)self.destinationViewController;
    
    // hostView is the view that contains the source view and will contain the destination view.
    UIView *hostView = src.view.superview;
    
    // Create the image of the source view.
    self.srcLayer = [self createLayerFromView:src.view transformedBy:CATransform3DIdentity];
    
    // Create the image of the destination view and place it in the same location as the source.
    self.dstLayer = [self createLayerFromView:dst.view transformedBy:CATransform3DIdentity];
    
    [CATransaction begin];
    // Turn off the default animations that happen when layer modifications are made.
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    // Add image of destination view before srcLayer so it appears underneath. The
    // srcLayer will slide out of the way to reveal it.
    [hostView.layer addSublayer: self.dstLayer];
    // Add image of source view after the destination image so that it obscures it.
    // It will be slid off to the right.
    [hostView.layer addSublayer: self.srcLayer];
            
    // Perform the animations. They start when the transaction commits and the next run loop starts.
    [self.srcLayer addAnimation:[self createSlideAnimation: src.view.bounds withDuration:longAnimationDuration] forKey:kAnimationKey];
    [self.dstLayer addAnimation:[self createDestinationAnimationWithDuration:shortAnimationDuration] forKey:kAnimationKey];
    [CATransaction commit];
}

// Standard UIStoryboardSegue perform
- (void)perform
{
    [self slideAndFade];
}

@end
