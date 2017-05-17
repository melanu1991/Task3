//
//  CalculatorModel.m
//  Calculator
//
//  Created by melanu1991 on 17.05.17.
//  Copyright © 2017 melanu. All rights reserved.
//

#import "CalculatorModel.h"

@implementation CalculatorModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.formatterDecimal = [[NSNumberFormatter alloc]init];
        self.formatterDecimal.minimumFractionDigits = 1;
        self.formatterDecimal.generatesDecimalNumbers = YES;
        self.formatterDecimal.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return self;
}

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
    } else if  ([self.operation isEqualToString:@"sqrt"]) {
        NSString *temp = [NSString stringWithFormat:@"%f",(sqrt(operand.doubleValue))];
        result = (NSDecimalNumber *)[self.formatterDecimal numberFromString:temp];
    }
    self.currentOperand = result;
    return result;
}

@end
