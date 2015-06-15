#import "LinesParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface LinesParser ()

@end

@implementation LinesParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"lines";


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
    [PKParser_weakSelf execute:^{
    
    PKTokenizer *t = self.tokenizer;

    // whitespace
    self.silentlyConsumesWhitespace = NO;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    
    // NOTE: mated `S` (i.e. whitespace) tokens will never be preserved by this parser's assembly, unless you turn on the `preservesWhitespaceTokens` below
    // So by default, it is as if all `S` references were actually defined as `S!`. Not sure I still like this default, but that's how it is for now.
    //self.assembly.preservesWhitespaceTokens = YES;

    }];

    NSString * methodName = self.startRuleName;
    if (methodName == nil) {
        [self lines_];
    }
    else {
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@_", methodName]);
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self, selector);
    }
    [PKParser_weakSelf matchEOF:YES];

}

- (void)lines_ {
    PKParser_weakSelfDecl;
    do {
        [PKParser_weakSelf line_];
    } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf line_];}]);

    [self fireDelegateSelector:@selector(parser:didMatchLines:)];
}

- (void)line_ {
    PKParser_weakSelfDecl;
    while ([PKParser_weakSelf speculate:^{ if (![PKParser_weakSelf speculate:^{ [PKParser_weakSelf eol_];}]) {[PKParser_weakSelf match:TOKEN_KIND_BUILTIN_ANY discard:NO];} else {[PKParser_weakSelf raise:@"negation test failed in line"];}}]) {
        if (![PKParser_weakSelf speculate:^{ [PKParser_weakSelf eol_];}]) {
            [PKParser_weakSelf match:TOKEN_KIND_BUILTIN_ANY discard:NO];
        } else {
            [PKParser_weakSelf raise:@"negation test failed in line"];
        }
    }
    [PKParser_weakSelf eol_];

    [self fireDelegateSelector:@selector(parser:didMatchLine:)];
}

- (void)eol_ {
    PKParser_weakSelfDecl;
    [self testAndThrow:(id)^{ return EQ(@"\n", LS(1)); }]; 
    [PKParser_weakSelf matchWhitespace:NO];

    [self fireDelegateSelector:@selector(parser:didMatchEol:)];
}

@end
