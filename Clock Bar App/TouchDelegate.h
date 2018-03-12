#import <Foundation/Foundation.h>

@protocol TouchDelegate <NSObject>

- (void)onPressed:(NSButton *)sender;

- (void)onLongPressed:(NSButton *)sender;

@end
