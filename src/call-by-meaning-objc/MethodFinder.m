#import "MethodFinder.h"
#import <objc/runtime.h>

@implementation MethodFinder

-(instancetype)initWithClassNames:(NSArray<NSString*>*) classNames {
    if (self = [super init]) {
        self.classNames = [[NSMutableArray alloc] initWithCapacity:[classNames count]];
        [self.classNames addObjectsFromArray:classNames];
    }
    return self;
}

-(NSArray<NSString*>*) methods:(Class) clz {
    bool VERBOSE = NO;
    NSMutableArray<NSString*>* result = [[NSMutableArray alloc] initWithCapacity:10];
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(clz, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        if (VERBOSE) {
                printf("\t'%s' has method named '%s' of encoding '%s'\n",
                       class_getName(clz),
                       sel_getName(method_getName(method)),
                       method_getTypeEncoding(method));
        }
        [result addObject:[NSString stringWithCString:sel_getName(method_getName(method)) encoding:NSUTF8StringEncoding]];
    }
    free(methods);
    return result;
}

-(FoundMethod*) findMethodThatGiven:(NSArray*)inputs producesOutput:(id)requiredOutput {
    NSArray<FoundMethod*>* found = [self findMethodsThatGiven:inputs produceOutput:requiredOutput];
    
    if ([found count] == 1) {
        return found[0];
    } else
    if ([found count] > 1){
        NSString* msg = [NSString stringWithFormat:@"AMBIGUOUS MEANING: More than one found method takes %@ and yields %@.", [inputs componentsJoinedByString:@","], requiredOutput];
        @throw [[NSException alloc] initWithName:@"AmbiguousMeaningException" reason:msg userInfo:nil];
    } else
    {
        NSString* msg = [NSString stringWithFormat:@"UNKNOWN MEANING: No found method takes %@ and yields %@.", [inputs componentsJoinedByString:@","], requiredOutput];
        @throw [[NSException alloc] initWithName:@"UnknownMeaningException" reason:msg userInfo:nil];
    }
}

-(NSArray<FoundMethod*>*) findMethodsThatGiven:(NSArray*)inputs produceOutput:(id)requiredOutput {
    NSString* msg = [NSString stringWithFormat:@"Searching for meanings that take %@ and yield %@.", [inputs componentsJoinedByString:@","], requiredOutput];
    NSLog(@"%@", msg);
    NSMutableArray<FoundMethod*>* results = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSString* c in self.classNames) {
        [results addObjectsFromArray:[self findMethodsInClassNamed:c thatGiven:inputs produceOutput:requiredOutput]];
    }
    return results;
}

-(NSArray<FoundMethod*>*) findMethodsInClasses:(NSArray<NSString*>*)classNames thatGiven:(NSArray*)inputs produceOutput:(id)requiredOutput {
    NSMutableArray<FoundMethod*>* results = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSString* c in classNames) {
        [results addObjectsFromArray:[self findMethodsInClassNamed:c thatGiven:inputs produceOutput:requiredOutput]];
    }
    return results;
}

-(NSArray<FoundMethod*>*) findMethodsInClassNamed:(NSString*)c thatGiven:(NSArray*)inputs produceOutput:(id)requiredOutput {
    NSMutableArray<FoundMethod*>* results = [[NSMutableArray alloc] initWithCapacity:10];
    id myobj = [[NSClassFromString(c) alloc] init];
    NSArray<NSString*>* methods = [self methods:NSClassFromString(c)];
    for (NSString* method in methods) {
        SEL s = NSSelectorFromString(method);
                
        if ([myobj respondsToSelector:s]) {
            NSMethodSignature* signature = [myobj methodSignatureForSelector:s];
            if ([signature numberOfArguments] == (2+[inputs count])) {
                NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[myobj methodSignatureForSelector:s]];
                [inv setSelector:s];
                [inv setTarget:myobj];
                BOOL cancelled = NO;                
                const int SELF_AND_CMD_OFFSET = 2;
                for (int i = 0; i < [inputs count]; i++) {
                    id value = inputs[i];
                    [inv setArgument:&value atIndex:SELF_AND_CMD_OFFSET+i];
                }
                if (!cancelled) {
                    @try {
                        [inv invoke];
                        __unsafe_unretained id result = 0; // __unsafe_unretained important because next line doesn't retain
                        [inv getReturnValue:&(result)];  //This copies bytes from the return buffer, but does not add a retain count.
                        if ([result isEqual:requiredOutput]) {
                            FoundMethod* r = [[FoundMethod alloc] initWithClassName:c methodName:method invocation:inv];
                            [results addObject:r];
                        }
                        result = nil;
                    }
                    @catch (NSException *exception){
                        // NSInvalidArgumentException
                        // Occurs if the method fails, likely because the arguments passed were of a different
                        // type and didn't support parameters.
                    }
                }
            }
        }
    }
        
    return results;
}

-(id)invoke:(FoundMethod*)r upon:(NSArray*)inputs {
    SEL s = NSSelectorFromString(r.methodName);
    id myobj = [[NSClassFromString(r.className) alloc] init];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[myobj methodSignatureForSelector:s]];
    [inv retainArguments];
    [inv setSelector:s];
    [inv setTarget:myobj];
    for (int i = 0; i < [inputs count]; i++) {
        id value = inputs[i];
        //arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        [inv setArgument:&value atIndex:2+i];
    }
    [inv invoke];
    
    __unsafe_unretained id result;
    [inv getReturnValue:&(result)];
    return result;
}
@end
