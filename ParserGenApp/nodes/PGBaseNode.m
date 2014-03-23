//
//  PKNode.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PGBaseNode.h"

@implementation PGBaseNode

+ (id)nodeWithToken:(PKToken *)tok {
    return [[[self alloc] initWithToken:tok] autorelease];
}


- (void)dealloc {
    self.actionNode = nil;
    self.semanticPredicateNode = nil;
    self.defName = nil;
    self.before = nil;
    self.after = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    PGBaseNode *that = (PGBaseNode *)[super copyWithZone:zone];
    that->_discard = _discard;
    that->_actionNode = [_actionNode retain];
    that->_semanticPredicateNode = [_semanticPredicateNode retain];
    that->_defName = [_defName retain];
    that->_before = [_before retain];
    that->_after = [_after retain];
    return that;
}


- (BOOL)isEqual:(id)obj {
    if (![super isEqual:obj]) {
        return NO;
    }

    PGBaseNode *that = (PGBaseNode *)obj;
    
    if (_discard != that->_discard) {
        return NO;
    }
    
    if (![_actionNode isEqual:that->_actionNode]) {
        return NO;
    }
    
    if (![_semanticPredicateNode isEqual:that->_semanticPredicateNode]) {
        return NO;
    }
    
    if (![_defName isEqual:that->_defName]) {
        return NO;
    }
    
    return YES;
}


- (void)replaceChild:(PGBaseNode *)oldChild withChild:(PGBaseNode *)newChild {
    NSParameterAssert(oldChild);
    NSParameterAssert(newChild);
    NSUInteger idx = [self.children indexOfObject:oldChild];
    NSAssert(NSNotFound != idx, @"");
    [self.children replaceObjectAtIndex:idx withObject:newChild];
}


- (void)replaceChild:(PGBaseNode *)oldChild withChildren:(NSArray *)newChildren {
    NSParameterAssert(oldChild);
    NSParameterAssert(newChildren);

    NSUInteger idx = [self.children indexOfObject:oldChild];
    NSAssert(NSNotFound != idx, @"");
    
    [self.children replaceObjectsInRange:NSMakeRange(idx, 1) withObjectsFromArray:newChildren];
}


- (void)visit:(id <PGNodeVisitor>)v; {
    NSAssert2(0, @"%s is an abastract method. Must be overridden in %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));
}


- (BOOL)isTerminal {
    NSAssert2(0, @"%s is an abastract method. Must be overridden in %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));
    return NO;
}

@end