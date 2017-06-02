#import "CalculatorModel.h"

NSString * const VAKPlusOperation = @"+";
NSString * const VAKMinusOperation = @"-";
NSString * const VAKMulOperation = @"*";
NSString * const VAKDivOperation = @"/";
NSString * const VAKSqrtOperation = @"√";
NSString * const VAKPlusMinusOperation = @"±";
NSString * const VAKProcentOperation = @"%";

@interface CalculatorModel ()
@property (nonatomic, copy) NSString *operation;
@property (nonatomic, copy) NSString *unaryOperation;
@property (nonatomic, copy) NSDecimalNumber *currentOperand;
@property (nonatomic, copy) NSDecimalNumber *beforeOperand;
@property (nonatomic, assign, getter=isFirstOperand) BOOL firstOperand;
@property (nonatomic, assign, getter=isEqualOperation) BOOL equalOperation;
@property (nonatomic, assign, getter=isBinaryOperation) BOOL binaryOperation;
@property (nonatomic, retain) NSDictionary *arrayOfOperation;
@end

@implementation CalculatorModel

- (NSDictionary *)arrayOfOperation {
    if (!_arrayOfOperation) {
        _arrayOfOperation = [@{VAKPlusOperation : @"plusOperation",
                               VAKMinusOperation : @"minusOperation",
                               VAKMulOperation : @"mulOperation",
                               VAKDivOperation : @"divOperation",
                               VAKProcentOperation : @"procentOperation",
                               VAKSqrtOperation : @"sqrtOperation",
                               VAKPlusMinusOperation : @"plusMinusOperation"
                               } retain];
    }
    return _arrayOfOperation;
}

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

- (void)clearValue {
    self.currentOperand = nil;
    self.beforeOperand = nil;
    self.operation = nil;
    self.NextOperand = NO;
    self.firstOperand = NO;
    self.equalOperation = NO;
    self.unaryOperation = nil;
    self.binaryOperation = nil;
}

- (void)executeOperation:(NSDecimalNumber *)newOperand {
    NSDecimalNumber *result = nil;
    if (!self.equalOperation) {
            self.beforeOperand = newOperand;
    }
    if (self.isBinaryOperation) {
        SEL selectorOperation = NSSelectorFromString(self.arrayOfOperation[self.operation]);
        result = [self performSelector:selectorOperation];
        if (result != nil) {
            self.currentOperand = result;
            [self.delegate setNewResultOnDisplay:result];
        }
    }
    else {
        SEL selectorOperation = NSSelectorFromString(self.arrayOfOperation[self.unaryOperation]);
        result = [self performSelector:selectorOperation];
        if (result != nil) {
            self.beforeOperand = result;
            [self.delegate setNewResultOnDisplay:result];
        }
    }
    self.NextOperand = NO;
    self.equalOperation = YES;
}

- (void)binaryOperationWithOperand:(NSDecimalNumber *)operand operation:(NSString *)operation{
    self.equalOperation = NO;
    self.binaryOperation = YES;
    if (!self.isFirstOperand) {
        self.operation = operation;
        self.currentOperand = operand;
        self.firstOperand = YES;
        return;
    }
    if (self.isNextOperand) {
        self.beforeOperand = operand;
        NSString *opr = self.arrayOfOperation[self.operation];
        SEL selectorOperation = NSSelectorFromString(opr);
        self.currentOperand = [self performSelector:selectorOperation];
    }
    else {
        self.operation = operation;
        return;
    }
    self.operation = operation;
    if (self.currentOperand != nil) {
        [self.delegate setNewResultOnDisplay:self.currentOperand];
    }
//    NSDecimalNumber *result = nil;
//    if ([self.operation isEqualToString:VAKPlusOperation]) {
//        result = [self.currentOperand decimalNumberByAdding:operand];
//    } else if ([self.operation isEqualToString:VAKMinusOperation]) {
//        result = [self.currentOperand decimalNumberBySubtracting:operand];
//    } else if ([self.operation isEqualToString:VAKMulOperation]) {
//        result = [self.currentOperand decimalNumberByMultiplyingBy:operand];
//    } else if ([self.operation isEqualToString:VAKDivOperation]) {
//        @try {
//            result = [self.currentOperand decimalNumberByDividingBy:operand];
//        } @catch (NSException *exception) {
//            [self.delegate setResultExceptionOnDisplay:[NSString stringWithFormat:@"Деление на ноль!"]];
//        }
//    } else if ([self.operation isEqualToString:@"%"]) {
//        if ( (self.currentOperand.integerValue - self.currentOperand.doubleValue == 0) || (operand.integerValue/operand.doubleValue == 0)) {
//            NSString *temp = [NSString stringWithFormat:@"%ld",self.currentOperand.integerValue % operand.integerValue];
//            result = (NSDecimalNumber *)[self.formatterDecimal numberFromString:temp];
//        }
//        else {
//            NSString *temp = [NSString stringWithFormat:@"%d", (int)(self.currentOperand.doubleValue/operand.doubleValue)];
//             result = [self.currentOperand decimalNumberBySubtracting:[[NSDecimalNumber decimalNumberWithString:temp] decimalNumberByMultiplyingBy:operand]];
//        }
//    }
//    self.currentOperand = result;
//    return result;
}

-(void)unaryOperationWithOperand:(NSDecimalNumber *)operand operation:(NSString *)operation {
    self.equalOperation = NO;
    self.unaryOperation = operation;
    NSDecimalNumber *result = nil;
    self.beforeOperand = operand;
    SEL selectorOperation = NSSelectorFromString(self.arrayOfOperation[self.unaryOperation]);
    result = [self performSelector:selectorOperation];
    if (result != nil) {
        [self.delegate setNewResultOnDisplay:result];
    }
//    NSDecimalNumber *result = nil;
//    if ([operation isEqualToString:VAKSqrtOperation]) {
//        @try {
//            if (operand.doubleValue<0) {
//                NSException *e = [NSException exceptionWithName:@"RootOfNegativeValue" reason:@"Корень из отрицательного числа!" userInfo:nil];
//                @throw e;
//            }
//            double value = sqrt(operand.doubleValue);
//            NSString *temp = [NSString stringWithFormat:@"%g",value];
//            result = (NSDecimalNumber *)[self.formatterDecimal numberFromString:temp];
//        } @catch (NSException *exception) {
//            [self.delegate setResultExceptionOnDisplay:exception.reason];
//        }
//        
//    } else if ([operation isEqualToString:VAKPlusMinusOperation]) {
//        NSDecimalNumber *numberInvert = [NSDecimalNumber decimalNumberWithString:@"-1"];
//        result = [numberInvert decimalNumberByMultiplyingBy:operand];
//    }
//    [self.delegate setNewResultOnDisplay:result];
}

- (NSDecimalNumber *)sqrtOperation {
    NSDecimalNumber *result = nil;
    @try {
        if (self.beforeOperand.doubleValue<0) {
            NSException *e = [NSException exceptionWithName:@"RootOfNegativeValue" reason:@"Корень из отрицательного числа!" userInfo:nil];
            @throw e;
        }
        double value = sqrt(self.beforeOperand.doubleValue);
        NSString *temp = [NSString stringWithFormat:@"%g",value];
        result = (NSDecimalNumber *)[self.formatterDecimal numberFromString:temp];
    } @catch (NSException *exception) {
        [self.delegate setResultExceptionOnDisplay:exception.reason];
        [self clearValue];
        return nil;
    }
    return result;
}

- (NSDecimalNumber *)plusMinusOperation {
    NSDecimalNumber *numberInvert = [NSDecimalNumber decimalNumberWithString:@"-1"];
    return [numberInvert decimalNumberByMultiplyingBy:self.beforeOperand];
}

- (NSDecimalNumber *)plusOperation {
    return [self.currentOperand decimalNumberByAdding:self.beforeOperand];
}

- (NSDecimalNumber *)minusOperation {
    return [self.currentOperand decimalNumberBySubtracting:self.beforeOperand];;
}

- (NSDecimalNumber *)mulOperation {
    return [self.currentOperand decimalNumberByMultiplyingBy:self.beforeOperand];
}

- (NSDecimalNumber *)divOperation {
    NSDecimalNumber *result = nil;
    @try {
        result = [self.currentOperand decimalNumberByDividingBy:self.beforeOperand];
    } @catch (NSException *exception) {
        [self.delegate setResultExceptionOnDisplay:[NSString stringWithFormat:@"Деление на ноль!"]];
        [self clearValue];
        return nil;
    }
    return result;
}

- (NSDecimalNumber *)procentOperation {
    NSDecimalNumber *result = nil;
    if ( (self.currentOperand.integerValue - self.currentOperand.doubleValue == 0) || (self.beforeOperand.integerValue/self.beforeOperand.doubleValue == 0)) {
        NSString *temp = [NSString stringWithFormat:@"%ld",self.currentOperand.integerValue % self.beforeOperand.integerValue];
        result = (NSDecimalNumber *)[self.formatterDecimal numberFromString:temp];
    }
    else {
        NSString *temp = [NSString stringWithFormat:@"%d", (int)(self.currentOperand.doubleValue/self.beforeOperand.doubleValue)];
        result = [self.currentOperand decimalNumberBySubtracting:[[NSDecimalNumber decimalNumberWithString:temp] decimalNumberByMultiplyingBy:self.beforeOperand]];
    }
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
