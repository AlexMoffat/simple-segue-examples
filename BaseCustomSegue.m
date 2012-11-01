//
//  BaseCustomSegue.m
//
//  Copyright (c) 2012 Alex Moffat. All rights reserved.
//
//  Base class for all of the segues and unwind segues

#import <QuartzCore/QuartzCore.h>
#import "BaseCustomSegue.h"

@interface BaseCustomSegue ()

// Flag set when the first animation starts.
@property BOOL firstAnimationStarted;

// Flag set when the last animation ends.
@property BOOL firstAnimationEnded;

@end

@implementation BaseCustomSegue

@synthesize srcLayer = _srcLayer;
@synthesize dstLayer = _dstLayer;
@synthesize firstAnimationStarted = _firstAnimationStarted;
@synthesize firstAnimationEnded = _firstAnimationEnded;

// Return a image of the given view.
- (UIImage *)screenShot: (UIView *) aView
{
    // Create a new context to draw an image the size of the view.
    UIGraphicsBeginImageContext(aView.bounds.size);
    // Draw the view's layer into the newly created context.
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    // Extract the image from the context.
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // Done with the current context.
    UIGraphicsEndImageContext();
    
    return image;
}

// Return a layer with the view contents.
- (CALayer *)createLayerFromView: (UIView *) aView
                   transformedBy: (CATransform3D) transform
{
    // New layer. Use default anchorPoint of 0.5, 0.5 so no need
    // to set it.
    CALayer *imageLayer = [CALayer layer];
    // The layer is going to be placed in its superlayer in the
    // same way that the view is positioned in its superview so
    // they need the same frame.
    imageLayer.frame = aView.frame;
    // Transform to apply to layer.
    imageLayer.transform = transform;
    // Set the contents to a screen shot of the view.
    UIImage *shot = [self screenShot:aView];
    // __bridge cast because passing a CAFoundation object to
    // cocoa code and we don't need to modify the ownership.
    imageLayer.contents = (__bridge id) shot.CGImage;
    
    return imageLayer;
}

// Remove the src and dst image layers. This is used after the
// animations have finished.
- (void)removeSrcAndDstLayers
{    
    // Transaction so that we can modify default animation behavior.
    [CATransaction begin];
    // Turn off the default animations that happen when layer modifications are made.
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    // Remove the two layers
    [self.srcLayer removeFromSuperlayer];
    [self.dstLayer removeFromSuperlayer];
    // End transaction.
    [CATransaction commit];
}

// Animation delegate method that's called when an
// animation starts.
- (void)animationDidStart:(CAAnimation *)anim
{
    // If this is the first animation then call the
    // firstAnimationDidStart method.
    if (!self.firstAnimationStarted) {
        self.firstAnimationStarted = YES;
        [self firstAnimationDidStart];
    }
}

// Animation delegate method that's called when an
// animation stops. This is coded to depend on there
// only being two animations.
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // When the first animation has already ended and
    // another animation ends we say that the last
    // animation has ended.
    if (self.firstAnimationEnded) {
        [self lastAnimationDidStop];
    } else {
        self.firstAnimationEnded = YES;
    }
}

// Called when the first of the two animations starts. Default
// implementation just disables user interaction with the UI.
// Override to make other changes but make sure you call this
// implementation before your code.
- (void)firstAnimationDidStart
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];    
}

// Called when the last of the two animations ends. Default
// implementation just enables user interaction with the UI.
// Override to make other changes but make sure you call this
// implementation after your code.
- (void)lastAnimationDidStop
{    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

@end
