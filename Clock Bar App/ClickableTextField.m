//
//  ClickableTextField.m
//  Clock Bar
//
//  Created by nihalsharma on 11/03/18.
//  Copyright © 2018 Nihalsharma. All rights reserved.
//

#import "ClickableTextField.h"

@interface ClickableTextField()

@end

@implementation ClickableTextField

- (void)mouseDown:(NSEvent *)theEvent
{
    [self sendAction:[self action] to:[self target]];
}

@end
