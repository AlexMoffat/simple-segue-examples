//
//  SegueSlideLeft.m
//
//  Copyright (c) 2012 Alex Moffat. All rights reserved.
//
//  Base class for all of the segues that slide a destination
//  image into place obscuring the source. The corresponding
//  unwind segues use UnwindSegueSlide

#import <QuartzCore/QuartzCore.h>
#import "SegueSlide.h"

@implementation SegueSlide

// Transformation to position the destination image in its initial location.
// The default implementation returns the identity transform so you'll need
// to override it.
- (CATransform3D)initialDestinationImageTransformation:(CGRect)sourceBounds
{
    return CATransform3DIdentity;
}

// Animation to move the destination image into position.
- (CABasicAnimation *)destinationTranslation
{
    // Move from current position (on the right) to the final position.
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationX.toValue = [NSNumber numberWithFloat:0];
    return translationX;
}

// On completing the animation show the new controller
// and remove the two layers that were animated.
- (void)lastAnimationDidStop
{
    // Present the new destination controller.
    [[self sourceViewController] presentViewController:[self destinationViewController] animated:NO completion:NULL];
    
    [self removeSrcAndDstLayers];
    
    [super lastAnimationDidStop];
}

// Create the animation to use for the source image.
- (CAAnimation *)createSourceAnimationWithDuration: (CGFloat)duration
{
    // Change the opacity of the source image.
    CABasicAnimation *srcOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    // Call back to this object when the animations finishes.
    srcOpacity.delegate = self;
    // Setting fillMode and removedOnCompletion prevents "flashing" at the
    // end of the animation becaue the presentation layers don't revert to
    // their previous values from the layer tree.
    srcOpacity.fillMode = kCAFillModeForwards;
    srcOpacity.removedOnCompletion = NO;
    // Length of the animation.
    srcOpacity.duration = duration;
    // Final value for the animated property.
    srcOpacity.toValue = [NSNumber numberWithFloat:fadedOpacity];
    // Ease out the animation.
    srcOpacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return srcOpacity;
}

// Create the animation to use for the destination image.
- (CAAnimation *)createDestinationAnimationWithDuration: (CGFloat)duration
{
    // See "createSourceAnimationWithDuration" for comments on
    // animation properties that have no comments here.
    // Going to use two animations so group them.
    CAAnimationGroup *dstAnimations = [CAAnimationGroup animation];
    dstAnimations.delegate = self;    dstAnimations.fillMode = kCAFillModeForwards;
    dstAnimations.removedOnCompletion = NO;
    dstAnimations.duration = duration;
    dstAnimations.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];        
    
    // Fade in from faded value to fully opaque.
    CABasicAnimation *dstOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    dstOpacity.fromValue = [NSNumber numberWithFloat:fadedOpacity];
    dstOpacity.toValue = [NSNumber numberWithFloat:1.0f];
    
    // Add the opacity animation and the translation animation provided by a subclass to the group.
    dstAnimations.animations = [NSArray arrayWithObjects:[self destinationTranslation], dstOpacity, nil];
    
    return dstAnimations;
}

// Slide in the destination and fade out the source.
- (void)slideAndFade
{
    UIViewController *src = (UIViewController *)super.sourceViewController;
    UIViewController *dst = (UIViewController *)super.destinationViewController;
    
    // hostView is the view that contains the source view and will contain the destination view.
    UIView *hostView = src.view.superview;
    
    // Create the image of the source view.
    self.srcLayer = [self createLayerFromView:src.view transformedBy:CATransform3DIdentity];
    
    // Create the image of the destination view and place it in the correct position relation to the source.
    self.dstLayer = [self createLayerFromView:dst.view transformedBy:[self initialDestinationImageTransformation:src.view.bounds]];
    
    [CATransaction begin];
    // Turn off the default animations that happen when layer modifications are made.
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    // Add image of source view.
    [hostView.layer addSublayer: self.srcLayer];
    // Add image of destination view after srcLayer so it appears on top.
    // It's to the right so is not currently visbile.
    [hostView.layer addSublayer: self.dstLayer];
            
    // Perform the animations. They start when the transaction commits and the next run loop starts.
    [self.srcLayer addAnimation:[self createSourceAnimationWithDuration:shortAnimationDuration] forKey:kAnimationKey];
    [self.dstLayer addAnimation:[self createDestinationAnimationWithDuration:longAnimationDuration] forKey:kAnimationKey];
    [CATransaction commit];

}

// Standard UIStoryboardSegue perform
- (void)perform
{
    [self slideAndFade];
}

@end
