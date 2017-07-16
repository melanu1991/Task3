#import <Foundation/Foundation.h>
#import "ChangedResultDelegate.h"
#import "OctSystem.h"
#import "BinarySystem.h"
#import "HexSystem.h"

typedef NSDecimalNumber *(^ExecuteOperation)(void);

@interface CalculatorModel : NSObject

@property (nonatomic,weak) id<ChangedResultDelegate> delegate;
@property (nonatomic,strong) NSNumberFormatter *formatterDecimal;
@property (nonatomic, assign, getter=isNextOperand) BOOL nextOperand;
@property (nonatomic, assign, getter=isEqualOperation) BOOL equalOperation;
@property (nonatomic, copy) NSString *currentNumberSystem;

- (void)binaryOperationWithOperand:(NSDecimalNumber *)operand operation:(NSString *)operation;
- (void)unaryOperationWithOperand:(NSDecimalNumber *)operand operation:(NSString *)operation;
- (void)executeOperation:(NSDecimalNumber *)newOperand;

- (void)addOperation:(NSString *)operation withExecuteBlock:(ExecuteOperation)executeBlock;

- (void)clearValue;

- (void)changeNumberSystemWithNewSystem:(NSString *)newNumberSystem withCurrentValue:(NSString *)currentValue;
- (void)convertAnyNumberSystemToDecimalNumberSystemWithNumber:(NSString *)number;
- (void)convertDecimalNumberSystemToAnyNumberSystemWithNumber:(NSString *)number;

@end
