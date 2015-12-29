#import "CurlyActionParser.h"
#import <PEGKit/PEGKit.h>


@interface CurlyActionParser ()

@end

@implementation CurlyActionParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";


    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {
    if (!self.isEmptyOK || [self speculate:^{
            [self startSpeculate];
        }]) {
        [self startSpeculate];
    }
    else {
        [self matchEOF:YES];
        PUSH(PEGKitSuccessfulEmptyParse);
    }
}

- (void)startSpeculate {

    NSString * methodName = self.startRuleName;
    if (methodName == nil) {
        [self start_];
    }
    else {
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@_", methodName]);
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self, selector);
    }
    [self matchEOF:YES]; 

}

- (void)start_ {
    
    do {
        [self matchWord:NO]; 
    } while ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]);
    [self execute:^{
    
    id word = nil;
    while (!EMPTY()) {
        word = POP_STR();
    }
    PUSH(word);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

@end