//
//  NJOutputMapping.m
//  Enjoy
//
//  Created by Sam McCall on 6/05/09.
//

#import "NJOutputMapping.h"

#import "ApplicationController.h"
#import "NJMapping.h"
#import "NJMappingsController.h"

@implementation NJOutputMapping

+ (NSString *)serializationCode {
    return @"mapping";
}

- (NSDictionary *)serialize {
    return _mapping
        ? @{ @"type": @"mapping", @"name": _mapping.name }
        : nil;
}

+ (NJOutputMapping *)outputDeserialize:(NSDictionary *)serialization
                        withMappings:(NSArray *)mappings {
    NSString *name = serialization[@"name"];
    NJOutputMapping *output = [[NJOutputMapping alloc] init];
    for (NJMapping *mapping in mappings) {
        if ([mapping.name isEqualToString:name]) {
            output.mapping = mapping;
            return output;
        }
    }
    return nil;
}

- (void)trigger {
    ApplicationController *ctrl = NSApplication.sharedApplication.delegate;
    [ctrl.mappingsController activateMapping:_mapping];
}

@end