#import "NotationSystemFactory.h"
#import "SystemProtocol.h"
#import "BinarySystem.h"
#import "OctSystem.h"
#import "HexSystem.h"
#import "Constants.h"

@implementation NotationSystemFactory

+ (id<SystemProtocol>)notationForSystem:(NSString *)system {
    if ([system isEqualToString:VAKSystemBin]) {
        return [[BinarySystem alloc] init];
    }
    else if ([system isEqualToString:VAKSystemOct]) {
        return [[OctSystem alloc] init];
    }
    else if ([system isEqualToString:VAKSystemHex]) {
        return [[HexSystem alloc] init];
    }
    return [[VAKDecimalSystem alloc] init];
}

@end
