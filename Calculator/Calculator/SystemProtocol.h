#import <Foundation/Foundation.h>

@protocol SystemProtocol <NSObject>

- (NSString *)convertToDec:(NSString *)currentValue;
- (NSString *)decToChoiceSystem:(NSString *)currentValue;

@end
