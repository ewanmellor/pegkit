#import "NamedActionParser.h"
#import <PEGKit/PEGKit.h>


@interface NamedActionParser ()

@property (nonatomic, retain) NSMutableDictionary *start_memo;
@property (nonatomic, retain) NSMutableDictionary *a_memo;
@property (nonatomic, retain) NSMutableDictionary *b_memo;
@end

@implementation NamedActionParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.tokenKindTab[@"a"] = @(NAMEDACTION_TOKEN_KIND_A);
        self.tokenKindTab[@"b"] = @(NAMEDACTION_TOKEN_KIND_B);

        self.tokenKindNameTab[NAMEDACTION_TOKEN_KIND_A] = @"a";
        self.tokenKindNameTab[NAMEDACTION_TOKEN_KIND_B] = @"b";

        self.start_memo = [NSMutableDictionary dictionary];
        self.a_memo = [NSMutableDictionary dictionary];
        self.b_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.start_memo = nil;
    self.a_memo = nil;
    self.b_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_start_memo removeAllObjects];
    [_a_memo removeAllObjects];
    [_b_memo removeAllObjects];
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

- (void)__start {
    
    [self a_]; 
    [self b_]; 

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)start_ {
    [self parseRule:@selector(__start) withMemo:_start_memo];
}

- (void)__a {
    
    [self execute:^{
    PUSH(@"foo");
    }];
    [self match:NAMEDACTION_TOKEN_KIND_A discard:NO]; 
    [self execute:^{
    PUSH(@"bar");
    }];

    [self fireDelegateSelector:@selector(parser:didMatchA:)];
}

- (void)a_ {
    [self parseRule:@selector(__a) withMemo:_a_memo];
}

- (void)__b {
    
    [self match:NAMEDACTION_TOKEN_KIND_B discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchB:)];
}

- (void)b_ {
    [self parseRule:@selector(__b) withMemo:_b_memo];
}

@end