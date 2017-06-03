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
@property (nonatomic, assign, getter=isBinaryOperation) BOOL binaryOperation;
@property (nonatomic, copy) NSString *currentNumberSystem;
@property (nonatomic, retain) NSDictionary *arrayOfOperation;
@property (nonatomic, retain) BinarySystem *binSystem;
@property (nonatomic, retain) OctSystem *octSystem;
@property (nonatomic, retain) HexSystem *hexSystem;
@end

@implementation CalculatorModel

- (BinarySystem *)binSystem {
    if (!_binSystem) {
        _binSystem = [[[BinarySystem alloc]init]retain];
    }
    return _binSystem;
}

- (OctSystem *)octSystem {
    if (!_octSystem) {
        _octSystem = [[[OctSystem alloc]init]retain];
    }
    return _octSystem;
}

- (HexSystem *)hexSystem {
    if (!_hexSystem) {
        _hexSystem = [[[HexSystem alloc]init]retain];
    }
    return _hexSystem;
}
- (NSString *)currentNumberSystem {
    if (!_currentNumberSystem) {
        _currentNumberSystem = [@"DEC" retain];
    }
    return _currentNumberSystem;
}

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

- (void)convertAnyNumberSystemToDecimalNumberSystemWithNumber:(NSString *)number {
    NSString *tempValue = nil;
    if ([self.currentNumberSystem isEqualToString:@"DEC"]) {
        return;
    }
    if ([self.currentNumberSystem isEqualToString:@"BIN"]) {
        tempValue = [self.binSystem convertToDec:number];
    }
    else if ([self.currentNumberSystem isEqualToString:@"OCT"]) {
        tempValue = [self.octSystem convertToDec:number];
    }
    else if ([self.currentNumberSystem isEqualToString:@"HEX"]) {
        tempValue = [self.hexSystem convertToDec:number];
    }
    if (tempValue != nil) {
        [self.delegate setNewResultOnDisplayNotDecimalSystem:tempValue];
    }
}

- (void)convertDecimalNumberSystemToAnyNumberSystemWithNumber:(NSString *)number {
    NSString *tempValue = number;
    if ([self.currentNumberSystem isEqualToString:@"DEC"]) {
        return;
    }
    if ([self.currentNumberSystem isEqualToString:@"BIN"]) {
        tempValue = [self.binSystem decToChoiceSystem:tempValue];
    }
    else if ([self.currentNumberSystem isEqualToString:@"OCT"]) {
        tempValue = [self.octSystem decToChoiceSystem:tempValue];
    }
    else if ([self.currentNumberSystem isEqualToString:@"HEX"]) {
        tempValue = [self.hexSystem decToChoiceSystem:tempValue];
    }
    [self.delegate setNewResultOnDisplayNotDecimalSystem:tempValue];
}

- (void)changeNumberSystemWithNewSystem:(NSString *)newNumberSystem withCurrentValue:(NSString *)currentValue {
    NSLog(@"currentValue: %@", currentValue);
    NSString *tempValue = currentValue;
    if ([self.currentNumberSystem isEqualToString:newNumberSystem]) {
        return;
    }
    if ([self.currentNumberSystem isEqualToString:@"BIN"]) {
        tempValue = [self.binSystem convertToDec:currentValue];
    }
    else if ([self.currentNumberSystem isEqualToString:@"OCT"]) {
        tempValue = [self.octSystem convertToDec:currentValue];
    }
    else if ([self.currentNumberSystem isEqualToString:@"HEX"]) {
        tempValue = [self.hexSystem convertToDec:currentValue];
    }
    if ([newNumberSystem isEqualToString:@"BIN"]) {
        tempValue = [self.binSystem decToChoiceSystem:tempValue];
    }
    else if ([newNumberSystem isEqualToString:@"OCT"]) {
        tempValue = [self.octSystem decToChoiceSystem:tempValue];
    }
    else if ([newNumberSystem isEqualToString:@"HEX"]) {
        tempValue = [self.hexSystem decToChoiceSystem:tempValue];
    }
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
        result = [self performSelector:selectorOperation];
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
        result = [self performSelector:selectorOperation];
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
    [_unaryOperation release];
    [_arrayOfOperation release];
    [_binSystem release];
    [_hexSystem release];
    [_octSystem release];
    [super dealloc];
}

@end
