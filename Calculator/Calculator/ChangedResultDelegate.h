#import <Foundation/Foundation.h>

@protocol ChangedResultDelegate <NSObject>

- (void)setNewResultOnDisplay:(NSDecimalNumber *)newResult;
- (void)setNewResultOnDisplayNotDecimalSystem:(NSString *)newResult;
- (void)setResultExceptionOnDisplay:(NSString *)showDisplayException;

@end
