#import "NegationParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface NegationParser ()

@property (nonatomic, retain) NSMutableDictionary *s_memo;
@property (nonatomic, retain) NSMutableDictionary *foo_memo;
@end

@implementation NegationParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"s";
        self.tokenKindTab[@"foo"] = @(NEGATION_TOKEN_KIND_FOO);

        self.tokenKindNameTab[NEGATION_TOKEN_KIND_FOO] = @"foo";

        self.s_memo = [NSMutableDictionary dictionary];
        self.foo_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.s_memo = nil;
    self.foo_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_s_memo removeAllObjects];
    [_foo_memo removeAllObjects];
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

- (void)__s {
    PKParser_weakSelfDecl;
    if (![self predicts:NEGATION_TOKEN_KIND_FOO, 0]) {
        [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
    } else {
        [self raise:@"negation test failed in s"];
    }

    [self fireDelegateSelector:@selector(parser:didMatchS:)];
}

- (void)s_ {
    [self parseRule:@selector(__s) withMemo:_s_memo];
}

- (void)__foo {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:NEGATION_TOKEN_KIND_FOO discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchFoo:)];
}

- (void)foo_ {
    [self parseRule:@selector(__foo) withMemo:_foo_memo];
}

@end
