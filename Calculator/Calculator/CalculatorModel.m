#import "CalculatorModel.h"
#import "Constants.h"
#import "NotationSystemFactory.h"

@interface CalculatorModel ()

@property (nonatomic, copy) NSString *operation;
@property (nonatomic, copy) NSString *unaryOperation;
@property (nonatomic, copy) NSDecimalNumber *currentOperand;
@property (nonatomic, copy) NSDecimalNumber *beforeOperand;
@property (nonatomic, assign, getter=isFirstOperand) BOOL firstOperand;
@property (nonatomic, assign, getter=isBinaryOperation) BOOL binaryOperation;
@property (nonatomic, copy) NSString *currentNumberSystem;
@property (nonatomic, retain) NSDictionary *arrayOfOperation;
@property (nonatomic, retain) id<SystemProtocol> system;

@end

@implementation CalculatorModel

- (NSDictionary *)arrayOfOperation {
    if (!_arrayOfOperation) {
        _arrayOfOperation = @{VAKPlusOperation : @"plusOperation",
                               VAKMinusOperation : @"minusOperation",
                               VAKMulOperation : @"mulOperation",
                               VAKDivOperation : @"divOperation",
                               VAKProcentOperation : @"procentOperation",
                               VAKSqrtOperation : @"sqrtOperation",
                               VAKPlusMinusOperation : @"plusMinusOperation"
                               };
    }
    return _arrayOfOperation;
}

- (id<SystemProtocol>)system {
    if (!_system) {
        _system = [[VAKDecimalSystem alloc] init];
    }
    return _system;
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

- (void)convertAnyNumberSystemToDecimalNumberSystemWithNumber:(NSString *)number {
    NSString *tempValue = nil;

    tempValue = [self.system convertToDec:number];
    
    if (tempValue != nil) {
        [self.delegate setNewResultOnDisplayNotDecimalSystem:tempValue];
    }
}

- (void)convertDecimalNumberSystemToAnyNumberSystemWithNumber:(NSString *)number {
    NSString *tempValue = number;

    tempValue = [self.system decToChoiceSystem:number];
    
    [self.delegate setNewResultOnDisplayNotDecimalSystem:tempValue];
}

- (void)changeNumberSystemWithNewSystem:(NSString *)newNumberSystem withCurrentValue:(NSString *)currentValue {
    NSString *tempValue = currentValue;
    
    tempValue = [self.system convertToDec:currentValue];
    self.system = [NotationSystemFactory notationForSystem:newNumberSystem];
    tempValue = [self.system decToChoiceSystem:tempValue];
    
    [self.delegate setNewResultOnDisplayNotDecimalSystem:tempValue];
    self.currentNumberSystem = newNumberSystem;
}

- (void)clearValue {
    self.currentOperand = nil;
    self.beforeOperand = nil;
    self.operation = nil;
    self.nextOperand = NO;
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
        if (self.operation == nil) {
            return;
        }
        SEL selectorOperation = NSSelectorFromString(self.arrayOfOperation[self.operation]);
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        result = [self performSelector:selectorOperation];
        #pragma clang diagnostic pop
        if (result != nil) {
            self.currentOperand = result;
            [self.delegate setNewResultOnDisplay:result];
        }
    }
    else {
        if (self.unaryOperation == nil) {
            return;
        }
        SEL selectorOperation = NSSelectorFromString(self.arrayOfOperation[self.unaryOperation]);
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        result = [self performSelector:selectorOperation];
        #pragma clang diagnostic pop
        if (result != nil) {
            self.beforeOperand = result;
            
            [self.delegate setNewResultOnDisplay:result];
        }
    }
    self.nextOperand = NO;
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
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        self.currentOperand = [self performSelector:selectorOperation];
        #pragma clang diagnostic pop
    }
    else {
        self.operation = operation;
        return;
    }
    self.operation = operation;
    if (self.currentOperand != nil) {
        [self.delegate setNewResultOnDisplay:self.currentOperand];
    }
}

-(void)unaryOperationWithOperand:(NSDecimalNumber *)operand operation:(NSString *)operation {
    self.equalOperation = NO;
    self.unaryOperation = operation;
    NSDecimalNumber *result = nil;
    self.beforeOperand = operand;
    SEL selectorOperation = NSSelectorFromString(self.arrayOfOperation[self.unaryOperation]);
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    result = [self performSelector:selectorOperation];
    #pragma clang diagnostic pop
    if (result != nil) {
        [self.delegate setNewResultOnDisplay:result];
    }
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

@end
