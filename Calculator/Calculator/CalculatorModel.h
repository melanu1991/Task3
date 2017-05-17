//
//  CalculatorModel.h
//  Calculator
//
//  Created by melanu1991 on 17.05.17.
//  Copyright © 2017 melanu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorModel : NSObject

@property (nonatomic, copy) NSString *operation;
@property (nonatomic, copy) NSDecimalNumber *currentOperand;

- (NSDecimalNumber *)performOperand:(NSDecimalNumber *)operand;

@end
