#import "CalculatorModel.h"
#import "Constants.h"
#import "NotationSystemFactory.h"

typedef NSDecimalNumber *(^ExecuteOperation)(void);

@interface CalculatorModel ()

@property (nonatomic, copy) NSString *operation;
@property (nonatomic, copy) NSString *unaryOperation;
@property (nonatomic, copy) NSDecimalNumber *currentOperand;
@property (nonatomic, copy) NSDecimalNumber *beforeOperand;
@property (nonatomic, assign, getter=isFirstOperand) BOOL firstOperand;
@property (nonatomic, assign, getter=isBinaryOperation) BOOL binaryOperation;
@property (nonatomic, copy) NSString *currentNumberSystem;
@property (nonatomic, retain) NSMutableDictionary *arrayOfOperation;
@property (nonatomic, retain) id<SystemProtocol> system;

@end

@implementation CalculatorModel

- (NSMutableDictionary *)arrayOfOperation {
    if (!_arrayOfOperation) {
        ExecuteOperation plusOperation = ^{ return [self.currentOperand decimalNumberByAdding:self.beforeOperand]; };
        ExecuteOperation minusOperation = ^{ return [self.currentOperand decimalNumberBySubtracting:self.beforeOperand]; };
        ExecuteOperation mulOperation = ^{ return [self.currentOperand decimalNumberByMultiplyingBy:self.beforeOperand]; };
        ExecuteOperation divOperation = ^{
            NSDecimalNumber *result = [NSDecimalNumber notANumber];
            @try {
                result = [self.currentOperand decimalNumberByDividingBy:self.beforeOperand];
            } @catch (NSException *exception) {
                [self.delegate setResultExceptionOnDisplay:[NSString stringWithFormat:@"Деление на ноль!"]];
                [self clearValue];
                return result;
            }
            return result;
        };
        ExecuteOperation procentOperation = ^{
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
        };
        ExecuteOperation sqrtOperation = ^{
            NSDecimalNumber *result = [NSDecimalNumber notANumber];
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
                return result;
            }
            return result;
        };
        ExecuteOperation plusMinusOperation = ^{
            NSDecimalNumber *numberInvert = [NSDecimalNumber decimalNumberWithString:@"-1"];
            return [numberInvert decimalNumberByMultiplyingBy:self.beforeOperand];
        };
        _arrayOfOperation = [NSMutableDictionary dictionaryWithObjectsAndKeys:plusOperation, VAKPlusOperation,
                                                                              minusOperation, VAKMinusOperation,
                                                                              mulOperation, VAKMulOperation,
                                                                              divOperation, VAKDivOperation,
                                                                              procentOperation, VAKProcentOperation,
                                                                              sqrtOperation, VAKSqrtOperation,
                                                                              plusMinusOperation, VAKPlusMinusOperation,
                                                                              nil];
    }
    return _arrayOfOperation;
}

- (void)addOperation:(NSString *)operation withExecuteBlock:(ExecuteOperation)executeBlock {
    self.arrayOfOperation[operation] = executeBlock;
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
        ExecuteOperation executeOperation = self.arrayOfOperation[self.operation];
        result = executeOperation();
        if (result != nil) {
            self.currentOperand = result;
            [self.delegate setNewResultOnDisplay:result];
        }
    }
    else {
        if (self.unaryOperation == nil) {
            return;
        }
        ExecuteOperation executeOperation = self.arrayOfOperation[self.unaryOperation];
        result = executeOperation();
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
        ExecuteOperation executeOperation = self.arrayOfOperation[self.operation];
        self.currentOperand = executeOperation();
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
    ExecuteOperation executeOperation = self.arrayOfOperation[self.unaryOperation];
    result = executeOperation();
    if (result != nil) {
        [self.delegate setNewResultOnDisplay:result];
    }
}

@end
