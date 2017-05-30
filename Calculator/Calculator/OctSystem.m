#import "OctSystem.h"

@implementation OctSystem

- (NSString *)convertToDec:(NSString *)currentValue {
    int sum = 0;
    for (int i = (int)currentValue.length-1, j=0; i>=0; i--,j++) {
        unichar temp = [currentValue characterAtIndex:i];
        sum+=pow(8, j)*((int)temp-'0');
    }
    return [NSString stringWithFormat:@"%d",sum];
}

- (NSString *)decToChoiceSystem:(NSString *)currentValue {
    return [NSString stringWithFormat:@"%O",currentValue.intValue];
}

@end
