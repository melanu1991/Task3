#import "NotationSystemFactory.h"
#import "SystemProtocol.h"
#import "BinarySystem.h"
#import "OctSystem.h"
#import "HexSystem.h"
#import "Constants.h"

@implementation NotationSystemFactory

+ (id<SystemProtocol>)notationForSystem:(NSString *)system {
    if ([system isEqualToString:VAKSystemBin]) {
        return [[[BinarySystem alloc] init] autorelease];
    }
    else if ([system isEqualToString:VAKSystemOct]) {
        return [[[OctSystem alloc] init] autorelease];
    }
    else if ([system isEqualToString:VAKSystemHex]) {
        return [[[HexSystem alloc] init] autorelease];
    }
    return [[[VAKDecimalSystem alloc] init] autorelease];
}

@end
