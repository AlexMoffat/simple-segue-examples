//
//  SegueExamplesViewController.m
//
//  Copyright (c) 2012 Alex Moffat. All rights reserved.
//

#import "SegueExamplesViewController.h"
#import "UnwindSegueSlideRight.h"
#import "UnwindSegueSlideDown.h"

@interface SegueExamplesViewController ()

@end

@implementation SegueExamplesViewController

// Used as a target for the unwind segue link.
-(IBAction)returned:(UIStoryboardSegue *)segue {
}

// Choose the correct segue to do the unwind based on the identifier provided.
- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier
{
    
    if ([@"UnwindSegueSlideRight" isEqualToString:identifier]) {
        return [[UnwindSegueSlideRight alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
    } else if ([@"UnwindSegueSlideDown" isEqualToString:identifier]) {
        return [[UnwindSegueSlideDown alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
    } else {
        return [super segueForUnwindingToViewController:toViewController fromViewController:fromViewController identifier:identifier];
    }
}

@end
