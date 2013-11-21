//
//  OCUDLAppKitBuiltins.m
//  OCUDL
//
//  Created by Dustin Bachrach on 10/15/13.
//  Copyright (c) 2013 Dustin Bachrach. All rights reserved.
//

#import "OCUDLAppKitBuiltins.h"
#import "OCUDL.h"
#import <Cocoa/Cocoa.h>

@interface OCUDLAppKitBuiltins ()

+ (void)registerNSColor;
+ (void)registerNSImage;
+ (void)registerNSNib;

@end

@implementation OCUDLAppKitBuiltins

+ (void)registerNSColor
{
	[[OCUDLManager defaultManager] registerPrefix:@"#"
										 forBlock:^id(NSString *literal, NSString *prefix, NSString* suffix) {
											 unsigned int value = 0;
											 if ([[NSScanner scannerWithString:literal] scanHexInt:&value])
											 {
												 if (literal.length == 6)
												 {
													 return [NSColor colorWithCalibratedRed:((float)((value & 0xFF0000) >> 16)) / 255.0
                                                                                      green:((float)((value & 0x00FF00) >> 8)) / 255.0
                                                                                       blue:((float)(value & 0x0000FF)) / 255.0
                                                                                      alpha:1.0];
												 }
												 else if (literal.length == 3)
												 {
													 return [NSColor colorWithCalibratedRed:((float)((value & 0xF00) >> 8)) / 15.0
                                                                                      green:((float)((value & 0x0F0) >> 4)) / 15.0
                                                                                       blue:((float)(value & 0x00F)) / 15.0
                                                                                      alpha:1.0];
												 }
											 }
											 else
											 {
												 if ([literal caseInsensitiveCompare:@"black"] == NSOrderedSame)
												 {
													 return [NSColor blackColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"darkGray"] == NSOrderedSame)
												 {
													 return [NSColor darkGrayColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"lightGray"] == NSOrderedSame)
												 {
													 return [NSColor lightGrayColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"white"] == NSOrderedSame)
												 {
													 return [NSColor whiteColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"gray"] == NSOrderedSame)
												 {
													 return [NSColor grayColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"red"] == NSOrderedSame)
												 {
													 return [NSColor redColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"green"] == NSOrderedSame)
												 {
													 return [NSColor greenColor];
												 }
												 
												 else if ([literal caseInsensitiveCompare:@"blue"] == NSOrderedSame)
												 {
													 return [NSColor blueColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"cyan"] == NSOrderedSame)
												 {
													 return [NSColor cyanColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"yellow"] == NSOrderedSame)
												 {
													 return [NSColor yellowColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"magenta"] == NSOrderedSame)
												 {
													 return [NSColor magentaColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"orange"] == NSOrderedSame)
												 {
													 return [NSColor orangeColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"purple"] == NSOrderedSame)
												 {
													 return [NSColor purpleColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"brown"] == NSOrderedSame)
												 {
													 return [NSColor brownColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"clear"] == NSOrderedSame)
												 {
													 return [NSColor clearColor];
												 }
											 }
											 return nil;
										 }];
    
}

+ (void)registerNSImage
{
	[[OCUDLManager defaultManager] registerSuffix:@".img"
										 forBlock:^id(NSString *literal, NSString *prefix, NSString* suffix) {
											 return [NSImage imageNamed:literal];
										 }];
}

+ (void)registerNSNib
{
	[[OCUDLManager defaultManager] registerSuffix:@".xib"
										 forBlock:^id(NSString *literal, NSString *prefix, NSString* suffix) {
#if IOS_TARGET
											 return [NSNib nibWithNibName:literal bundle:nil];
#else
                                             return [[NSNib alloc]initWithNibNamed:literal bundle:nil];
#endif
										 }];
}

static dispatch_once_t s_pred;

void useCUDLAppKitBuiltins()
{
	dispatch_once(&s_pred, ^{
		[OCUDLAppKitBuiltins registerNSColor];
		[OCUDLAppKitBuiltins registerNSImage];
		[OCUDLAppKitBuiltins registerNSNib];
	});
}

@end
