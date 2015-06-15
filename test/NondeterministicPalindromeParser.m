#import "NondeterministicPalindromeParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface NondeterministicPalindromeParser ()

@end

@implementation NondeterministicPalindromeParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"s";
        self.tokenKindTab[@"0"] = @(NONDETERMINISTICPALINDROME_TOKEN_KIND_0);
        self.tokenKindTab[@"1"] = @(NONDETERMINISTICPALINDROME_TOKEN_KIND_1);

        self.tokenKindNameTab[NONDETERMINISTICPALINDROME_TOKEN_KIND_0] = @"0";
        self.tokenKindNameTab[NONDETERMINISTICPALINDROME_TOKEN_KIND_1] = @"1";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {
    PKParser_weakSelfDecl;
    if (!self.isEmptyOK || [self speculate:^{
            [PKParser_weakSelf startSpeculate];
        }]) {
        [self startSpeculate];
    }
    else {
        [self matchEOF:YES];
        PUSH(PEGKitSuccessfulEmptyParse);
    }
}

- (void)startSpeculate {
    PKParser_weakSelfDecl;

    NSString * methodName = self.startRuleName;
    if (methodName == nil) {
        [self s_];
    }
    else {
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@_", methodName]);
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self, selector);
    }
    [PKParser_weakSelf matchEOF:YES];

}

- (void)s_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:NONDETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO];[PKParser_weakSelf s_];[PKParser_weakSelf match:NONDETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO];}]) {
        [PKParser_weakSelf match:NONDETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO];
        [PKParser_weakSelf s_];
        [PKParser_weakSelf match:NONDETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:NONDETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO];[PKParser_weakSelf s_];[PKParser_weakSelf match:NONDETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO];}]) {
        [PKParser_weakSelf match:NONDETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO];
        [PKParser_weakSelf s_];
        [PKParser_weakSelf match:NONDETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:NONDETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO];}]) {
        [PKParser_weakSelf match:NONDETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:NONDETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO];}]) {
        [PKParser_weakSelf match:NONDETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 's'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchS:)];
}

@end
