#import <Foundation/Foundation.h>

@protocol ChangedResultDelegate <NSObject>

- (void)setNewResultOnDisplay:(NSDecimalNumber *)newResult;
- (void)setResultExceptionOnDisplay:(NSString *)showDisplayException;

@end
