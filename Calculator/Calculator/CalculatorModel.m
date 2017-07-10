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
        self.formatterDecimal.usesGroupingSeparator = NO;
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
        
        @try {
            
            result = [self.currentOperand decimalNumberByDividingBy:operand];
            
        } @catch (NSException *exception) {
            
            [self.delegate setResultExceptionOnDisplay:[NSString stringWithFormat:@"Деление на ноль!"]];
            
        }
        
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
    
//    [self.delegate setNewResultOnDisplay:result]; --> тут не совсем понял как сделать т.к. при бинарной операцие значение на экране должно меняться только после нажатия следующей операции! А так оно поменяет его сразу!
    
    return result;
}

-(NSDecimalNumber *)unaryOperand:(NSDecimalNumber *)operand operation:(NSString *)operation {
    NSDecimalNumber *result = nil;
    if ([operation isEqualToString:@"sqrt"]) {
        @try {
            if (operand.doubleValue<0) {
                NSException *e = [NSException exceptionWithName:@"RootOfNegativeValue" reason:@"Корень из отрицательного числа!" userInfo:nil];
                @throw e;
            }
            double value = sqrt(operand.doubleValue);
            NSString *temp = [NSString stringWithFormat:@"%g",value];
            result = (NSDecimalNumber *)[self.formatterDecimal numberFromString:temp];
        } @catch (NSException *exception) {
            [self.delegate setResultExceptionOnDisplay:exception.reason];
        }
        
    } else if ([operation isEqualToString:@"±"]) {
        NSDecimalNumber *numberInvert = [NSDecimalNumber decimalNumberWithString:@"-1"];
        result = [numberInvert decimalNumberByMultiplyingBy:operand];
    }
    
//    [self.delegate setNewResultOnDisplay:result];
    
    return result;
}

- (void)dealloc
{
    [_delegate release];
    [_operation release];
    [_currentOperand release];
    [_formatterDecimal release];
    [_beforeOperand release];
    [super dealloc];
}

@end
