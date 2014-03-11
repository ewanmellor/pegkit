//
//  PKURLState.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 3/26/10.
//  Copyright 2010 Todd Ditchendorf. All rights reserved.
//

#import <PEGKit/PKURLState.h>
#import <PEGKit/PKReader.h>
#import <PEGKit/PKTokenizer.h>
#import <PEGKit/PKToken.h>
#import <PEGKit/PKTypes.h>

// Gruber original
//  \b(([\w-]+://?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|/)))

@interface PKToken ()
@property (nonatomic, readwrite) NSUInteger offset;
@end

@interface PKTokenizerState ()
- (void)resetWithReader:(PKReader *)r;
- (void)append:(PKUniChar)c;
- (NSString *)bufferedString;
- (PKTokenizerState *)nextTokenizerStateFor:(PKUniChar)c tokenizer:(PKTokenizer *)t;
@end

@interface PKURLState ()
- (BOOL)parseWWWFromReader:(PKReader *)r;
- (BOOL)parseSchemeFromReader:(PKReader *)r;
- (BOOL)parseHostFromReader:(PKReader *)r;
- (void)parsePathFromReader:(PKReader *)r;
@property (nonatomic) PKUniChar c;
@property (nonatomic) PKUniChar lastChar;
@end

@implementation PKURLState

- (id)init {
    self = [super init];
    if (self) {
        self.allowsWWWPrefix = YES;
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}


- (void)append:(PKUniChar)ch {
    self.lastChar = ch;
    [super append:ch];
}


- (PKToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t {
    NSParameterAssert(r);
    [self resetWithReader:r];
    
    self.lastChar = PKEOF;
    self.c = cin;
    BOOL matched = NO;
    if (_allowsWWWPrefix && 'w' == _c) {
        matched = [self parseWWWFromReader:r];

        if (!matched) {
            if (PKEOF != _c) {
                NSUInteger buffLen = [[self bufferedString] length];
                [r unread:buffLen];
            }
            [self resetWithReader:r];
            self.c = cin;
        }
    }
    
    if (!matched) {
        matched = [self parseSchemeFromReader:r];
    }
    if (matched) {
        matched = [self parseHostFromReader:r];
    }
    if (matched) {
        [self parsePathFromReader:r];
    }
    
    NSString *s = [self bufferedString];

    if (PKEOF != _c) {
        [r unread];
    } 
    
    if (matched) {
        if ('.' == _lastChar || ',' == _lastChar || '-' == _lastChar) {
            s = [s substringToIndex:[s length] - 1];
            [r unread];
        }
        
        PKToken *tok = [PKToken tokenWithTokenType:PKTokenTypeURL stringValue:s floatValue:0.0];
        tok.offset = offset;
        return tok;
    } else {
        [r unread:[s length] - 1];
        return [[self nextTokenizerStateFor:cin tokenizer:t] nextTokenFromReader:r startingWith:cin tokenizer:t];
    }
}


- (BOOL)parseWWWFromReader:(PKReader *)r {
    BOOL result = NO;
    NSInteger wcount = 0;
    
    while ('w' == _c) {
        wcount++;
        [self append:_c];
        self.c = [r read];

        if (3 == wcount) {
            if ('.' == _c) {
                [self append:_c];
                self.c = [r read];
                result = YES;
                break;
            } else {
                result = NO;
                break;
            }
        }
    }
    
    return result;
}


- (BOOL)parseSchemeFromReader:(PKReader *)r {
    BOOL result = NO;

    // [[:alpha:]-]+://?
    for (;;) {
        if (isalnum(_c) || '-' == _c) {
            [self append:_c];
        } else if (':' == _c) {
            [self append:_c];
            
            self.c = [r read];
            if ('/' == _c) { // endgame
                [self append:_c];
                self.c = [r read];
                if ('/' == _c) {
                    [self append:_c];
                    self.c = [r read];
                }
                result = YES;
                break;
            } else {
                result = NO;
                break;
            }
        } else {
            result = NO;
            break;
        }

        self.c = [r read];
    }
    
    return result;
}


- (BOOL)parseHostFromReader:(PKReader *)r {
    BOOL result = NO;
    BOOL hasAtLeastOneChar = NO;
//    BOOL hasDot = NO;
    
    // ^[:space:]()<>
    for (;;) {
        if (PKEOF == _c || isspace(_c) || '(' == _c || ')' == _c || '<' == _c || '>' == _c) {
            result = hasAtLeastOneChar;
            break;
        } else if ('/' == _c && hasAtLeastOneChar/* && hasDot*/) {
            result = YES;
            break;
        } else {
//            if ('.' == _c) {
//                hasDot = YES;
//            }
            hasAtLeastOneChar = YES;
            [self append:_c];
            self.c = [r read];
        }
    }
    
    return result;
}


- (void)parsePathFromReader:(PKReader *)r {
    BOOL hasOpenParen = NO;
    
    for (;;) {
        if (PKEOF == _c || isspace(_c) || '<' == _c || '>' == _c) {
            break;
        } else if (')' == _c) {
            if (hasOpenParen) {
                hasOpenParen = NO;
                [self append:_c];
            } else {
                break;
            }
        } else {
            if (!hasOpenParen) {
                hasOpenParen = ('(' == _c);
            }
            [self append:_c];
        }
        self.c = [r read];
    }
}

@end