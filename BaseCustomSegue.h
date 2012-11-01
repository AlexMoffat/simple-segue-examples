//
//  BaseCustomSegue.h
//
//  Copyright (c) 2012 Alex Moffat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCustomSegue : UIStoryboardSegue

// Used as key to identify animations. Not actually
// "needed" as the animations are not referenced
// by this key after they are created.
#define kAnimationKey @"TransitionViewAnimation"

// Opacity value used when something is faded out.
#define fadedOpacity 0.4f

// How long should the animation for the item
// that is disappearing last?
#define shortAnimationDuration 1.0f

// How long should the animation for the item
// that is appearing last?
#define longAnimationDuration 1.2f

// The layers holding the source and destination images.
@property (strong, nonatomic)  CALayer *srcLayer;
@property (strong, nonatomic)  CALayer *dstLayer;

// Return a layer with the view contents.
- (CALayer *)createLayerFromView: (UIView *) aView
                   transformedBy: (CATransform3D) transform;

// Remove the src and dst image layers. This is used after the
// animations have finished.
- (void)removeSrcAndDstLayers;

// Called when the first of the two animations starts. Default
// implementation just disables user interaction with the UI.
// Override to make other changes but make sure you call this
// implementation before your code.
- (void)firstAnimationDidStart;

// Called when the last of the two animations ends. Default
// implementation just enables user interaction with the UI.
// Override to make other changes but make sure you call this
// implementation after your code.
- (void)lastAnimationDidStop;
@end
