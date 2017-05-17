//
//  CalculatorModel.m
//  Calculator
//
//  Created by melanu1991 on 17.05.17.
//  Copyright © 2017 melanu. All rights reserved.
//

#import "CalculatorModel.h"

@implementation CalculatorModel

- (NSDecimalNumber *)performOperand:(NSDecimalNumber *)operand{
    NSDecimalNumber *result = nil;
    NSLog(@"%@ - %@",self.currentOperand, operand);
    if ([self.operation isEqualToString:@"+"]) {
        result = [self.currentOperand decimalNumberByAdding:operand];
    } else if ([self.operation isEqualToString:@"-"]) {
        result = [self.currentOperand decimalNumberBySubtracting:operand];
    } else if ([self.operation isEqualToString:@"*"]) {
        result = [self.currentOperand decimalNumberByMultiplyingBy:operand];
    } else if ([self.operation isEqualToString:@"/"]) {
        result = [self.currentOperand decimalNumberByDividingBy:operand];
    }
    return result;
}

@end
