//
//  OCUDLManager.m
//  OCUDL
//
//  Created by Dustin Bachrach on 10/10/13.
//  Copyright (c) 2013 Dustin Bachrach. All rights reserved.
//

#import "OCUDLManager.h"

@interface OCUDLManager ()

/// All prefixes
@property (strong, nonatomic) NSMutableDictionary *prefixMapping;

/// All suffixes
@property (strong, nonatomic) NSMutableDictionary *suffixMapping;

@end


@implementation OCUDLManager

static dispatch_once_t s_pred;
static OCUDLManager *s_manager = nil;

+ (instancetype)defaultManager
{
	dispatch_once(&s_pred, ^{
		s_manager = [[OCUDLManager alloc] init];
	});
	
	return s_manager;
}

- (id)init
{
	if (self = [super init])
	{
		self.prefixMapping = [[NSMutableDictionary alloc] init];
		self.suffixMapping = [[NSMutableDictionary alloc] init];
	}
	return self;
}

#pragma mark - Registration

- (void)registerPrefix:(NSString*)prefix forClass:(Class<OCUDLClass>)class
{
    [self registerPrefix:prefix forBlock:^id(NSString *str, NSString *prefStr, NSString *suffStr) {
        return (id)[[(Class)class alloc] initWithLiteral:str prefix:prefStr];
    }];
}

- (void)registerPrefix:(NSString*)prefix forBlock:(OCUDLBlock)block
{
	self.prefixMapping[prefix] = @[NSNull.null,block];
}

- (void)registerPrefix:(NSString*)prefix andSuffix:(NSString*)suffix forBlock:(OCUDLBlock)block
{
	self.prefixMapping[prefix] = @[suffix,block];
}

- (void)registerSuffix:(NSString*)suffix forClass:(Class<OCUDLClass>)class
{
    [self registerSuffix:suffix forBlock:^id(NSString *str, NSString *prefStr, NSString*suffStr) {
        return (id)[[(Class)class alloc] initWithLiteral:str suffix:suffStr];
    }];
}

- (void)registerSuffix:(NSString*)suffix forBlock:(OCUDLBlock)block
{
	self.suffixMapping[suffix] = block;
}

#pragma mark - Object Emitter

- (id)objectForLiteralString:(NSString *)str {
    NSMutableDictionary *prefixMapping = self.prefixMapping;
    NSArray *sortedPrefixMappingKeys = [[prefixMapping allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return[@([obj1 length]) compare:@([obj2 length])];
    }];
    
    OCUDLBlock block = nil;
    NSString* prefix = nil;
    NSString* suffix = nil;
    
    for (prefix in sortedPrefixMappingKeys) {
        if ([str hasPrefix:prefix]) {
            NSString* afterPrefixStr = [str substringFromIndex:[prefix length]];
            suffix = prefixMapping[prefix][0];
            
            if ((NSNull*)suffix != NSNull.null) {
                if([afterPrefixStr hasSuffix:suffix]) {
                    str = [ str substringToIndex:(str.length - suffix.length) ] ;
                    block = prefixMapping[prefix][1];
                    break;
                }
            }
            else {
                suffix = nil;
                str = afterPrefixStr;
                block = prefixMapping[prefix][1];
                break;
            }
        }
    }
    
    if (block == nil) {
        prefix = nil;
        NSMutableDictionary *suffixMapping = self.suffixMapping;
        NSArray *sortedSuffixMappingKeys = [[suffixMapping allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return[@([obj2 length]) compare:@([obj1 length])];
        }];
        
        for (NSString *suffix in sortedSuffixMappingKeys) {
            if ([str hasSuffix:suffix]) {
                
                str = [str substringToIndex:[str length] - [suffix length]];
                
                block = suffixMapping[suffix];
            }
        }
    }
    return block ? block(str,prefix,suffix) : nil;
}

@end
