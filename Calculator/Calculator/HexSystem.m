#import "HexSystem.h"

@implementation HexSystem

- (NSString *)convertToDec:(NSString *)currentValue {
    NSString *dec = nil;
    NSString *sign = [NSString stringWithFormat:@"%C",[currentValue characterAtIndex:0]];
    if ([sign isEqualToString:@"-"]) {
        NSString *hexValue = [currentValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        hexValue = [NSString stringWithFormat:@"%llu",(UInt64)strtoull([hexValue UTF8String], NULL, 16)];;
        dec = [NSString stringWithFormat:@"-%@",hexValue];
    }
    else {
        dec = [NSString stringWithFormat:@"%llu",(UInt64)strtoull([currentValue UTF8String], NULL, 16)];
    }
    return dec;
}

- (NSString *)decToChoiceSystem:(NSString *)currentValue {
    NSString *hex = nil;
    NSString *sign = [NSString stringWithFormat:@"%C",[currentValue characterAtIndex:0]];
    if ([sign isEqualToString:@"-"]) {
        NSString *decimalValue = [currentValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        hex = [NSString stringWithFormat:@"%2lX", (unsigned long)[decimalValue integerValue]];
        hex = [NSString stringWithFormat:@"-%@",hex];
    }
    else {
        hex = [NSString stringWithFormat:@"%2lX", (unsigned long)[currentValue integerValue]];
    }
    return hex;
}

@end
