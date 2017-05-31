#import "OctSystem.h"

@implementation OctSystem

- (NSString *)convertToDec:(NSString *)currentValue {
    NSString *decimalValue = nil;
    NSString *sign = [NSString stringWithFormat:@"%C",[currentValue characterAtIndex:0]];
    if ([sign isEqualToString:@"-"]) {
        NSString *octValue = [currentValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        decimalValue = [NSString stringWithFormat:@"%ld",strtol(octValue.UTF8String, NULL, 8)];
        decimalValue = [NSString stringWithFormat:@"-%@",decimalValue];
    }
    else {
        decimalValue = [NSString stringWithFormat:@"%ld",strtol(currentValue.UTF8String, NULL, 8)];
    }
    return decimalValue;
}

- (NSString *)decToChoiceSystem:(NSString *)currentValue {
    NSString *octValue = nil;
    NSString *sign = [NSString stringWithFormat:@"%C",[currentValue characterAtIndex:0]];
    if ([sign isEqualToString:@"-"]) {
        NSString *decimalValue = [currentValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        octValue = [NSString stringWithFormat:@"%2lO", (unsigned long)[decimalValue integerValue]];
        octValue = [NSString stringWithFormat:@"-%@",octValue];
    }
    else {
        octValue = [NSString stringWithFormat:@"%2lO", (unsigned long)[currentValue integerValue]];
    }
    return octValue;
}

@end
