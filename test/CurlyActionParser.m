#import "CurlyActionParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


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
    PKParser_weakSelfDecl;

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
    [PKParser_weakSelf matchEOF:YES];

}

- (void)start_ {
    PKParser_weakSelfDecl;
    do {
        [PKParser_weakSelf matchWord:NO];
    } while ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]);
    [PKParser_weakSelf execute:^{
    
    id word = nil;
    while (!EMPTY()) {
        word = POP_STR();
    }
    PUSH(word);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

@end