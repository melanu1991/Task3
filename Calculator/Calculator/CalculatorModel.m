#import "CalculatorModel.h"

NSString * const VAKPlusOperation = @"+";
NSString * const VAKMinusOperation = @"-";
NSString * const VAKMulOperation = @"*";
NSString * const VAKDivOperation = @"/";
NSString * const VAKSqrtOperation = @"√";
NSString * const VAKPlusMinusOperation = @"±";

@implementation CalculatorModel

- (NSNumberFormatter *)formatterDecimal {
    if (!_formatterDecimal) {
        _formatterDecimal = [[NSNumberFormatter alloc]init];
        _formatterDecimal.generatesDecimalNumbers = YES;
        _formatterDecimal.usesSignificantDigits = YES;
        _formatterDecimal.usesGroupingSeparator = NO;
        _formatterDecimal.numberStyle = NSNumberFormatterDecimalStyle;
        [_formatterDecimal setMinimumFractionDigits:1];
        [_formatterDecimal setMaximumFractionDigits:5];
    }
    return _formatterDecimal;
}

- (NSDecimalNumber *)binaryOperationWithOperand:(NSDecimalNumber *)operand{
    NSDecimalNumber *result = nil;
    if ([self.operation isEqualToString:VAKPlusOperation]) {
        result = [self.currentOperand decimalNumberByAdding:operand];
    } else if ([self.operation isEqualToString:VAKMinusOperation]) {
        result = [self.currentOperand decimalNumberBySubtracting:operand];
    } else if ([self.operation isEqualToString:VAKMulOperation]) {
        result = [self.currentOperand decimalNumberByMultiplyingBy:operand];
    } else if ([self.operation isEqualToString:VAKDivOperation]) {
        @try {
            result = [self.currentOperand decimalNumberByDividingBy:operand];
        } @catch (NSException *exception) {
            [self.delegate setResultExceptionOnDisplay:[NSString stringWithFormat:@"Деление на ноль!"]];
        }
    } else if ([self.operation isEqualToString:@"%"]) {
        if ( (self.currentOperand.integerValue - self.currentOperand.doubleValue == 0) || (operand.integerValue/operand.doubleValue == 0)) {
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

-(void)unaryOperationWithOperand:(NSDecimalNumber *)operand operation:(NSString *)operation {
    NSDecimalNumber *result = nil;
    if ([operation isEqualToString:VAKSqrtOperation]) {
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
        
    } else if ([operation isEqualToString:VAKPlusMinusOperation]) {
        NSDecimalNumber *numberInvert = [NSDecimalNumber decimalNumberWithString:@"-1"];
        result = [numberInvert decimalNumberByMultiplyingBy:operand];
    }
    [self.delegate setNewResultOnDisplay:result];
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
