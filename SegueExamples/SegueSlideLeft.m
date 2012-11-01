//
//  SegueSlideLeft.m
//
//  Copyright (c) 2012 Alex Moffat. All rights reserved.
//
//  Segue that slides the destination in from the right, it slides
//  it to the left.

#import <QuartzCore/QuartzCore.h>
#import "SegueSlideLeft.h"

@implementation SegueSlideLeft

// Position the destination image to the right of the source.
- (CATransform3D)initialDestinationImageTransformation:(CGRect)sourceBounds
{
    return CATransform3DMakeTranslation(sourceBounds.size.width, 0, 0);
}

// Translate in the x direction to a final value of 0.0
- (CABasicAnimation *)destinationTranslation
{
    // Move from current position (on the right) to the final position.
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationX.toValue = [NSNumber numberWithFloat:0];
    return translationX;
}

@end
