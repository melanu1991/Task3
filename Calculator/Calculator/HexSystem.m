//
//  HexSystem.m
//  Calculator
//
//  Created by melanu1991 on 28.05.17.
//  Copyright © 2017 melanu. All rights reserved.
//

#import "HexSystem.h"

@implementation HexSystem

- (NSString *)convertToDec:(NSString *)currentValue {
    int sum = 0;
    for (int i = (int)currentValue.length-1, j=0; i>=0; i--,j++) {
        unichar temp = [currentValue characterAtIndex:i];
        sum+=pow(16, j)*((int)temp-'0');
    }
    return [NSString stringWithFormat:@"%d",sum];
}

- (NSString *)decToChoiceSystem:(NSString *)currentValue {
    NSNumber *value = [NSNumber numberWithInteger:currentValue.integerValue];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for (int i = 0; ; i++) {
        [temp addObject:[NSNumber numberWithInteger:value.integerValue%16]];
        if (value.integerValue<16) {
            break;
        }
        value = [NSNumber numberWithInteger:value.integerValue/16];
    }
    NSString *result = @"";
    for (int i = (int)temp.count-1; i>=0; i--) {
        result = [NSString stringWithFormat:@"%@%@",result,temp[i]];
    }
    [temp release];
    return result;
}

@end
