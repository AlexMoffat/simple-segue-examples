//
//  SegueSlideLeft.m
//
//  Copyright (c) 2012 Alex Moffat. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UnwindSegueSlideRight.h"

@implementation UnwindSegueSlideRight

// Move the source off to the right to reveal the destination.
- (CAAnimation *)srcTranslation: (CGRect)bounds
{
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translation.toValue = [NSNumber numberWithFloat:bounds.size.width];
    
    return translation;
}

@end
