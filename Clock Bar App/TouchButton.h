#import <Cocoa/Cocoa.h>
#import "TouchDelegate.h"

@interface TouchButton : NSButton

@property (nonatomic, weak) id<TouchDelegate> delegate;

@end
