//
//  CalculatorModel.m
//  Calculator
//
//  Created by melanu1991 on 17.05.17.
//  Copyright © 2017 melanu. All rights reserved.
//

#import "CalculatorModel.h"

@implementation CalculatorModel

-(instancetype)init {
    self = [super init];
    if (self) {
        self.formatterDecimal = [[NSNumberFormatter alloc]init];
        self.formatterDecimal.generatesDecimalNumbers = YES;
        self.formatterDecimal.usesSignificantDigits = YES;
        self.formatterDecimal.numberStyle = NSNumberFormatterDecimalStyle;
        [self.formatterDecimal setMinimumFractionDigits:1];
        [self.formatterDecimal setMaximumFractionDigits:5];
    }
    return self;
}

- (NSDecimalNumber *)binaryOperand:(NSDecimalNumber *)operand{
    NSDecimalNumber *result = nil;
    if ([self.operation isEqualToString:@"+"]) {
        result = [self.currentOperand decimalNumberByAdding:operand];
    } else if ([self.operation isEqualToString:@"-"]) {
        result = [self.currentOperand decimalNumberBySubtracting:operand];
    } else if ([self.operation isEqualToString:@"*"]) {
        result = [self.currentOperand decimalNumberByMultiplyingBy:operand];
    } else if ([self.operation isEqualToString:@"/"]) {
        result = [self.currentOperand decimalNumberByDividingBy:operand];
    } else if ([self.operation isEqualToString:@"%"]) {
        if (self.currentOperand.integerValue-self.currentOperand.doubleValue == 0 || operand.integerValue/operand.doubleValue == 0) {
            
            NSString *temp = [NSString stringWithFormat:@"%ld",self.currentOperand.integerValue % operand.integerValue];
            result = (NSDecimalNumber *)[self.formatterDecimal numberFromString:temp];
            
        }
        else {
            
            NSString *temp = [NSString stringWithFormat:@"%d", (int)(self.currentOperand.doubleValue/operand.doubleValue)];
             result = [self.currentOperand decimalNumberBySubtracting:[[NSDecimalNumber decimalNumberWithString:temp] decimalNumberByMultiplyingBy:operand]];
            
        }
    }
    self.currentOperand = result;
    return result;
}

-(NSDecimalNumber *)unaryOperand:(NSDecimalNumber *)operand operation:(NSString *)operation {
    NSDecimalNumber *result = nil;
    if ([operation isEqualToString:@"sqrt"]) {
        NSString *temp = [NSString stringWithFormat:@"%.5f",(sqrt(operand.doubleValue))];
        result = (NSDecimalNumber *)[self.formatterDecimal numberFromString:temp];
    } else if ([operation isEqualToString:@"±"]) {
        NSDecimalNumber *numberInvert = [NSDecimalNumber decimalNumberWithString:@"-1"];
        result = [numberInvert decimalNumberByMultiplyingBy:operand];
    }
    return result;
}

- (void)dealloc
{
    [_operation release];
    [_currentOperand release];
    [_formatterDecimal release];
    [super dealloc];
}

@end
