#import "MyClass1.h"

@implementation MyClass1

-(NSNumber*) add:(NSNumber*)a and:(NSNumber*)b {
    return @([a intValue] + [b intValue]);
}

-(NSNumber*) minus:(NSNumber*)a and:(NSNumber*)b {
    return @([a intValue] - [b intValue]);
}

-(NSNumber*) multiply:(NSNumber*)a and:(NSNumber*)b {
    return @([a intValue] * [b intValue]);
}

-(NSNumber*) divide:(NSNumber*)a and:(NSNumber*)b {
    return @([a intValue] / [b intValue]);
}

@end
