#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FoundMethod : NSObject
@property (strong, retain) NSString* className;
@property (strong, retain) NSString* methodName;
@property (strong, retain) NSInvocation* invocation;

-(instancetype) initWithClassName:(NSString*)c methodName:(NSString*)m invocation:(NSInvocation*)i;
@end

NS_ASSUME_NONNULL_END
