#import "HexSystem.h"

@interface HexSystem ()
@property (nonatomic, retain) NSDictionary *dictionaryHex;
@end

@implementation HexSystem
@synthesize dictionaryHex = _dictionaryHex;

- (NSDictionary *)dictionaryHex {
    if (!_dictionaryHex) {
        _dictionaryHex = [@{ @"0":@"0",
                            @"1":@"1",
                            @"2":@"2",
                            @"3":@"3",
                            @"4":@"4",
                            @"5":@"5",
                            @"6":@"6",
                            @"7":@"7",
                            @"8":@"8",
                            @"9":@"9",
                            @"10":@"A",
                            @"11":@"B",
                            @"12":@"C",
                            @"13":@"D",
                            @"14":@"E",
                            @"15":@"F",
                            @"A":@"10",
                            @"B":@"11",
                            @"C":@"12",
                            @"D":@"13",
                            @"E":@"14",
                            @"F":@"15"
                            }retain];
    }
    return _dictionaryHex;
}

- (NSString *)convertToDec:(NSString *)currentValue {
    int sum = 0;
    for (int i = (int)currentValue.length-1, j=0; i>=0; i--,j++) {
        NSString *temp = [NSString stringWithFormat:@"%C",[currentValue characterAtIndex:i]];
        temp = self.dictionaryHex[temp];
        sum+=pow(16, j)*temp.integerValue;
    }
    return [NSString stringWithFormat:@"%d",sum];
}

- (NSString *)decToChoiceSystem:(NSString *)currentValue {
    return [NSString stringWithFormat:@"%X",currentValue.intValue];
}

- (void)dealloc {
    [super dealloc];
    [_dictionaryHex release];
}

@end
