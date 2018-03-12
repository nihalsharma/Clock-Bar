#import <Cocoa/Cocoa.h>
#import "TouchButton.h"

static double LONG_PRESS_TIME = 0.5;

@interface TouchButton ()

@property double touchBeganTime;

@end


@implementation TouchButton

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)touchesBeganWithEvent:(NSEvent *)event
{

        NSSet<NSTouch *> *touches = [event touchesMatchingPhase:NSTouchPhaseBegan inView:self];

        NSTouch *touch = touches.anyObject;
        if (touch != nil)
        {
            if (touch.type == NSTouchTypeDirect)
            {
                self.touchBeganTime = [[NSDate date] timeIntervalSince1970];
            }
        }

    [super touchesBeganWithEvent:event];
}

- (void)touchesMovedWithEvent:(NSEvent *)event
{

        for (NSTouch *touch in [event touchesMatchingPhase:NSTouchPhaseMoved inView:self])
        {
            if (touch.type == NSTouchTypeDirect)
            {
                break;
            }
        }

    [super touchesMovedWithEvent:event];
}

- (void)touchesEndedWithEvent:(NSEvent *)event
{

        for (NSTouch *touch in [event touchesMatchingPhase:NSTouchPhaseEnded inView:self])
        {
            if (touch.type == NSTouchTypeDirect)
            {
                if(self.delegate != nil)
                {
                    double touchTime = [[NSDate date] timeIntervalSince1970] - self.touchBeganTime;
                    if(touchTime >= LONG_PRESS_TIME) {
                        [self.delegate onLongPressed: self];
                    }
                    else
                    {
                        [self.delegate onPressed: self];
                    }
                }
                break;
            }
        }

    [super touchesEndedWithEvent:event];
}

- (void)touchesCancelledWithEvent:(NSEvent *)event
{

        for (NSTouch *touch in [event touchesMatchingPhase:NSTouchPhaseMoved inView:self])
        {
            if (touch.type == NSTouchTypeDirect)
            {
                break;
            }
        }

    [super touchesCancelledWithEvent:event];
}

@end
