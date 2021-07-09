#import "FoundMethod.h"

@implementation FoundMethod
-(instancetype) initWithClassName:(NSString*)c methodName:(NSString*)m invocation:(NSInvocation*)i {
    if (self = [super init]) {
        self.className = c;
        self.methodName = m;
        self.invocation = i;
    }
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"foundMethod:%@->%@", self.className, self.methodName];
}
@end
