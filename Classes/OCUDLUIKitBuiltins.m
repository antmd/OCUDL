//
//  OCUDLUIKitBuiltins.m
//  OCUDL
//
//  Created by Dustin Bachrach on 10/15/13.
//  Copyright (c) 2013 Dustin Bachrach. All rights reserved.
//

#import "OCUDLUIKitBuiltins.h"
#import "OCUDL.h"


@interface OCUDLUIKitBuiltins ()

+ (void)registerUIColor;
+ (void)registerUIImage;
+ (void)registerUINib;
+ (void)registerUIStoryboard;

@end

@implementation OCUDLUIKitBuiltins

+ (void)registerUIColor
{
	[[OCUDLManager defaultManager] registerPrefix:@"#"
										 forBlock:^id(NSString *literal, NSString *prefix) {
											 unsigned int value = 0;
											 if ([[NSScanner scannerWithString:literal] scanHexInt:&value])
											 {
												 if (literal.length == 6)
												 {
													 return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16)) / 255.0
																			green:((float)((value & 0x00FF00) >> 8)) / 255.0
																			 blue:((float)(value & 0x0000FF)) / 255.0
																			alpha:1.0];
												 }
												 else if (literal.length == 3)
												 {
													 return [UIColor colorWithRed:((float)((value & 0xF00) >> 8)) / 15.0
																			green:((float)((value & 0x0F0) >> 4)) / 15.0
																			 blue:((float)(value & 0x00F)) / 15.0
																			alpha:1.0];
												 }
											 }
											 else
											 {
												 if ([literal caseInsensitiveCompare:@"black"] == NSOrderedSame)
												 {
													 return [UIColor blackColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"darkGray"] == NSOrderedSame)
												 {
													 return [UIColor darkGrayColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"lightGray"] == NSOrderedSame)
												 {
													 return [UIColor lightGrayColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"white"] == NSOrderedSame)
												 {
													 return [UIColor whiteColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"gray"] == NSOrderedSame)
												 {
													 return [UIColor grayColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"red"] == NSOrderedSame)
												 {
													 return [UIColor redColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"green"] == NSOrderedSame)
												 {
													 return [UIColor greenColor];
												 }
												 
												 else if ([literal caseInsensitiveCompare:@"blue"] == NSOrderedSame)
												 {
													 return [UIColor blueColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"cyan"] == NSOrderedSame)
												 {
													 return [UIColor cyanColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"yellow"] == NSOrderedSame)
												 {
													 return [UIColor yellowColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"magenta"] == NSOrderedSame)
												 {
													 return [UIColor magentaColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"orange"] == NSOrderedSame)
												 {
													 return [UIColor orangeColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"purple"] == NSOrderedSame)
												 {
													 return [UIColor purpleColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"brown"] == NSOrderedSame)
												 {
													 return [UIColor brownColor];
												 }
												 else if ([literal caseInsensitiveCompare:@"clear"] == NSOrderedSame)
												 {
													 return [UIColor clearColor];
												 }
											 }
											 return nil;
										 }];

}

+ (void)registerUIImage
{
	[[OCUDLManager defaultManager] registerSuffix:@".img"
										 forBlock:^id(NSString *literal, NSString *prefix) {
											 return [UIImage imageNamed:literal];
										 }];
}

+ (void)registerUINib
{
	[[OCUDLManager defaultManager] registerSuffix:@".xib"
										 forBlock:^id(NSString *literal, NSString *prefix) {
											 return [UINib nibWithNibName:literal bundle:nil];
										 }];
}


+ (void)registerUIStoryboard
{
	[[OCUDLManager defaultManager] registerSuffix:@".storyboard"
										 forBlock:^id(NSString *literal, NSString *prefix) {
											 return [UIStoryboard storyboardWithName:literal bundle:nil];
										 }];
}

static dispatch_once_t s_pred;

void useCUDLUIKitBuiltins(void)
{
	dispatch_once(&s_pred, ^{
		[OCUDLUIKitBuiltins registerUIColor];
		[OCUDLUIKitBuiltins registerUIImage];
		[OCUDLUIKitBuiltins registerUINib];
		[OCUDLUIKitBuiltins registerUIStoryboard];
	});
}

@end
