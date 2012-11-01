//
//  SegueSlideLeft.h
//
//  Copyright (c) 2012 Alex Moffat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseCustomSegue.h"

@interface UnwindSegueSlide : BaseCustomSegue

// Move the src image, that is the starting image which will be on top of the
// destination image, out of the way to reveal the destination image.
// Subclasses must implement this.
- (CAAnimation *)srcTranslation: (CGRect)bounds;

@end
