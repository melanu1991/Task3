#import <Foundation/Foundation.h>
#import "ChangedResultDelegate.h"

@interface CalculatorModel : NSObject

@property (nonatomic,unsafe_unretained) id<ChangedResultDelegate> delegate;
@property (nonatomic,retain) NSNumberFormatter *formatterDecimal;
@property (nonatomic, assign, getter=isNextOperand) BOOL nextOperand;
@property (nonatomic, assign, getter=isEqualOperation) BOOL equalOperation;

- (void)binaryOperationWithOperand:(NSDecimalNumber *)operand operation:(NSString *)operation;
- (void)unaryOperationWithOperand:(NSDecimalNumber *)operand operation:(NSString *)operation;
- (void)executeOperation:(NSDecimalNumber *)newOperand;
- (void)clearValue;

@end
