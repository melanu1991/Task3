#import <Foundation/Foundation.h>
#import "SystemProtocol.h"
#import "VAKDecimalSystem.h"

@interface NotationSystemFactory : NSObject

+ (id<SystemProtocol>)notationForSystem:(NSString *)system;

@end
