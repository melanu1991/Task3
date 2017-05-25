//
//  CalculatorModel.h
//  Calculator
//
//  Created by melanu1991 on 17.05.17.
//  Copyright © 2017 melanu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChangedResultDelegate.h"

@interface CalculatorModel : NSObject

@property (nonatomic,unsafe_unretained) id<ChangedResultDelegate> delegate;
@property (nonatomic, copy) NSString *operation;
@property (nonatomic, copy) NSDecimalNumber *currentOperand;
@property (nonatomic,retain) NSNumberFormatter *formatterDecimal;
@property (nonatomic, copy) NSDecimalNumber *beforeOperand;

-(instancetype)init;

- (NSDecimalNumber *)binaryOperand:(NSDecimalNumber *)operand;
- (NSDecimalNumber *)unaryOperand:(NSDecimalNumber *)operand operation:(NSString *)operation;

@end
