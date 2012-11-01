# Simple Segue Examples

This is a simple demonstration, with many, many comments, of how to implement
a custom segue that uses core animation in iOS 6. There are two segues, each
with a corresponding unwind segue.

The application itself is amazingly simple, there's an initial yellow screen
showing a _Slide Up_ button. If you press the _Slide Up_ button a purple 
view slides up with an accompanying fade in. This has a _Down_ button that
uses the [Exit](http://stackoverflow.com/questions/12416050/xcode-4-5-storyboard-exit)
object to trigger an unwinding segue. If instead you swipe to the left a
green view slides in from the right. This has a _Right_ button that slides
it out to the right using another unwind segue. 

The basic plan for all the segues and unwind segues is the same. 
UIGraphics is used to create images of the source and destination views. 
The image of the destination view is positioned relative to the image
of the source view and animations are used to move the
destination and source while fading in the destination and fading out the
source. For the segue triggered by the swipe, the one that slides to the left,
this is shown graphically in SlideImage.png. 

## Class Hierarchy

                   BaseCustomSegue
                          |
              +-----------+-----------+
              |                       |
         SegueSlide            UnwindSegueSlide
              |                       |
         +-----+-----+           +----+-----+
         |           |           |          |
    SegueSlideLeft SegueSlideUp  |          |
                                 |          |
                     UnwindSegueSlideDown  UnwindSegueSlideUp

## Code Reading Hints

For understanding the code it's best to start with SegueSlide.m. The
perform method is the one that's called to invoke the segue. This uses 
the slideAndFade method to do all the work. The comments should tell
the whole story of what's going on, in excruciating detail. 

## License

Licensed under the BSD 2-Clause License. See LICENSE.md for details.
