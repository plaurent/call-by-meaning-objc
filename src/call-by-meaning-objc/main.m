#import <Foundation/Foundation.h>
#import "MethodFinder.h"
#import "FoundMethod.h"

void run() {
    MethodFinder* finder = [[MethodFinder alloc] initWithClassNames:@[@"MyClass1", @"MyClass2"]];

    // Demonstrate that we can find an addition function.
    FoundMethod* found_add = [finder findMethodThatGiven:@[@3, @4] producesOutput:@7];
    NSArray* test = @[@5, @6];
    NSNumber* result = [finder invoke:found_add upon:test]; // should be 11
    NSLog(@"Result of applying meaning %@ upon %@ was %@", found_add, [test componentsJoinedByString:@","], result);

    // Demonstrates how we might find and use multiple matches (findMethods with an "s")
    NSArray* multipleMatches = [finder findMethodsThatGiven:@[@2, @2] produceOutput:@4];
    NSLog(@"Methods found by meaning '2,2->4' were: %@", multipleMatches);
    test = @[@20, @20];
    NSLog(@"Result of applying first found method, %@, upon %@ is %@", multipleMatches[0], [test componentsJoinedByString:@","], [finder invoke:multipleMatches[0] upon:test]);

    // Demonstrates how to deal with multiple matches when we were only asking for one (findMethod with no "s")
    // AmbiguousMeaningException
    @try {
        FoundMethod* ambiguousMeaning = [finder findMethodThatGiven:@[@2, @2] producesOutput:@4];
    } @catch (NSException *e) {
        NSLog(@"GOT EXPECTED EXCEPTION: %@", [e description]);
    }
    
    // Demonstrates how to deal with multiple matches when we were only asking for one (findMethod with no "s")
    // UnknownMeaningException
    @try {
        FoundMethod* unknownMeaning = [finder findMethodThatGiven:@[@2, @2] producesOutput:@10000];
    } @catch (NSException *e) {
        NSLog(@"GOT EXPECTED EXCEPTION: %@", [e description]);
    }

    // Demonstrates finding and applying functions on other kinds of data, like strings.
    FoundMethod* found_strlen = [finder findMethodThatGiven:@[@"hello world"] producesOutput:@11];
    NSString* s = @"goodbye world";
    result = [finder invoke:found_strlen upon:@[s]];
    NSLog(@"Result of applying found method %@ to '%@' is %@", found_strlen, s, result);

    FoundMethod* found_upcase = [finder findMethodThatGiven:@[@"hello world"] producesOutput:@"HELLO WORLD"];
    id stringResult = [finder invoke:found_upcase upon:@[@"This should get uppercased"]];
    NSLog(@"Result of applying found method 'found_upcase' is: %@", stringResult);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        run();
    }
    return 0;
}
