//
//  PKTokenizerState+Subclass.h
//  PEGKit
//
//  Created by Ewan Mellor on 12/28/15.
//
//

@interface PKTokenizerState ()

- (void)resetWithReader:(PKReader *)r;

- (PKTokenizerState *)nextTokenizerStateFor:(PKUniChar)c tokenizer:(PKTokenizer *)t;

- (void)append:(PKUniChar)c;
- (void)appendString:(NSString *)s;

- (NSString *)bufferedString;

@property (nonatomic) NSUInteger offset;

@end
