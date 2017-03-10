//
//  NJOutputKeyPress.m
//  Enjoy
//
//  Created by Sam McCall on 5/05/09.
//

#import "NJOutputKeyPress.h"

#import "NJKeyInputField.h"

@implementation NJOutputKeyPress

+ (NSString *)serializationCode {
    return @"key press";
}

- (NSDictionary *)serialize {
    return _keyCode != NJKeyInputFieldEmpty
        ? @{ @"type": self.class.serializationCode, @"key": @(_keyCode) }
        : nil;
}

+ (NJOutput *)outputWithSerialization:(NSDictionary *)serialization {
    NJOutputKeyPress *output = [[NJOutputKeyPress alloc] init];
    output.keyCode = (CGKeyCode)[serialization[@"key"] intValue];
    return output;
}

- (void)trigger {
    if (_keyCode != NJKeyInputFieldEmpty) {
        CGEventSourceRef src =
        CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
        
        CGEventRef cmdd = CGEventCreateKeyboardEvent(src, 0x38, true);
        CGEventRef keyDown = CGEventCreateKeyboardEvent(src, _keyCode, YES);
        CGEventSetFlags(keyDown, kCGEventFlagMaskCommand);
        
        CGEventPost(kCGHIDEventTap, cmdd);
        CGEventPost(kCGHIDEventTap, keyDown);
        
        CFRelease(keyDown);
        CFRelease(cmdd);
        CFRelease(src);

    }
}

- (void)untrigger {
    if (_keyCode != NJKeyInputFieldEmpty) {
        
        CGEventSourceRef src =
        CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
        
        CGEventRef keyUp = CGEventCreateKeyboardEvent(src, _keyCode, NO);
        CGEventRef cmdu = CGEventCreateKeyboardEvent(src, 0x38, false);
        CGEventSetFlags(keyUp, kCGEventFlagMaskCommand);
        CGEventPost(kCGHIDEventTap, keyUp);
        CGEventPost(kCGHIDEventTap, cmdu);
        CFRelease(keyUp);
        CFRelease(cmdu);
        CFRelease(src);

    }
}

@end
