#import "BinarySystem.h"

@implementation BinarySystem

- (NSString *)convertToDec:(NSString *)currentValue {
    NSString *decimalValue = nil;
    NSString *sign = [NSString stringWithFormat:@"%C",[currentValue characterAtIndex:0]];
    if ([sign isEqualToString:@"-"]) {
        NSString *binaryValue = [currentValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        decimalValue = [NSString stringWithFormat:@"%ld",strtol([binaryValue UTF8String], NULL, 2)];
        decimalValue = [NSString stringWithFormat:@"-%@",decimalValue];
    }
    else {
        decimalValue = [NSString stringWithFormat:@"%ld",strtol([currentValue UTF8String], NULL, 2)];
    }
    return decimalValue;
}

- (NSString *)decToChoiceSystem:(NSString *)currentValue {
    NSUInteger decimalNumber = [currentValue integerValue];
    int index = 0;
    NSString *binary = @"";
    NSString *sign = [NSString stringWithFormat:@"%C",[currentValue characterAtIndex:0]];
    if ([sign isEqualToString:@"-"]) {
        NSString *decimalValue = [currentValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        decimalNumber = decimalValue.integerValue;
        while (decimalNumber > 0) {
            binary = [[NSString stringWithFormat:@"%lu", decimalNumber&1] stringByAppendingString:binary];
            decimalNumber = decimalNumber>> 1;
            ++index;
        }
        binary = [NSString stringWithFormat:@"-%@",binary];
    }
    else {
        while (decimalNumber > 0) {
            binary = [[NSString stringWithFormat:@"%lu", decimalNumber&1] stringByAppendingString:binary];
            decimalNumber = decimalNumber>> 1;
            ++index;
        }
    }
    return binary;
}

@end
