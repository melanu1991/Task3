#import <Foundation/Foundation.h>

@protocol ChangedResultDelegate <NSObject>

- (void)setNewResultOnDisplay:(NSDecimalNumber *)newResult;

@end
