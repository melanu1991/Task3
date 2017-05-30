#import "BinarySystem.h"

@implementation BinarySystem

- (NSString *)convertToDec:(NSString *)currentValue {
    int sum = 0;
    for (int i = (int)currentValue.length-1, j=0; i>=0; i--,j++) {
        unichar temp = [currentValue characterAtIndex:i];
        sum+=pow(2, j)*((int)temp-'0');
    }
    return [NSString stringWithFormat:@"%d",sum];
}

- (NSString *)decToChoiceSystem:(NSString *)currentValue {
    NSMutableString *str = [NSMutableString stringWithFormat:@""];
    for(NSInteger numberCopy = currentValue.intValue; numberCopy > 0; numberCopy >>= 1)
    {
        [str insertString:((numberCopy & 1) ? @"1" : @"0") atIndex:0];
    }
    return str;
}

@end
