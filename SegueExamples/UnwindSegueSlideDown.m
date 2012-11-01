//
//  SegueSlideLeft.m
//
//  Copyright (c) 2012 Alex Moffat. All rights reserved.
//
//  Slide the source down to reveal the destination.

#import <QuartzCore/QuartzCore.h>
#import "UnwindSegueSlideDown.h"

@implementation UnwindSegueSlideDown

// Change the y value so that the src moves downwards to
// below the destination.
- (CAAnimation *)srcTranslation: (CGRect)bounds
{
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    translation.toValue = [NSNumber numberWithFloat:bounds.size.height];
    
    return translation;
}

@end
