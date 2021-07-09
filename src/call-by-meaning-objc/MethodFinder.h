#import <Foundation/Foundation.h>
#import "FoundMethod.h"

NS_ASSUME_NONNULL_BEGIN

@interface MethodFinder : NSObject
@property (strong, retain) NSMutableArray* classNames;


-(instancetype)initWithClassNames:(NSArray<NSString*>*) classNames;
-(NSArray<NSString*>*) methods:(Class) clz;
-(FoundMethod*) findMethodThatGiven:(NSArray*)inputs producesOutput:(id)requiredOutput;
-(NSArray<FoundMethod*>*) findMethodsThatGiven:(NSArray*)inputs produceOutput:(id)requiredOutput;

-(NSArray<FoundMethod*>*) findMethodsInClasses:(NSArray<NSString*>*)classNames thatGiven:(NSArray*)inputs produceOutput:(id)requiredOutput;
-(NSArray<FoundMethod*>*) findMethodsInClassNamed:(NSString*)c thatGiven:(NSArray*)inputs produceOutput:(id)requiredOutput;
-(NSNumber*)invoke:(FoundMethod*)r upon:(NSArray*)inputs;

@end

NS_ASSUME_NONNULL_END
