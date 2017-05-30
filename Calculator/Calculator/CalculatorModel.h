#import <Foundation/Foundation.h>
#import "ChangedResultDelegate.h"

@interface CalculatorModel : NSObject

@property (nonatomic,unsafe_unretained) id<ChangedResultDelegate> delegate;
@property (nonatomic, copy) NSString *operation;
@property (nonatomic, copy) NSDecimalNumber *currentOperand;
@property (nonatomic,retain) NSNumberFormatter *formatterDecimal;
@property (nonatomic, copy) NSDecimalNumber *beforeOperand;

- (NSDecimalNumber *)binaryOperationWithOperand:(NSDecimalNumber *)operand;
- (NSDecimalNumber *)unaryOperationWithOperand:(NSDecimalNumber *)operand operation:(NSString *)operation;

@end
