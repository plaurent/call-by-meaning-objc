#import "MyClass2.h"

@implementation MyClass2

-(NSNumber*)lengthOfString:(NSString*)s {
    return @([s length]);
}

// THE FOLLOWING WILL CAUSE PROBLEMS -- SINGLE STRING, TWO PARAMETERS

-(NSNumber*)string:(NSString*)a isNCharactersLongerThan:(NSString*)b {
    return @([a length]-[b length]);
}

-(NSString*)upp:(NSString*)a {
    return [a uppercaseString];
}

@end
