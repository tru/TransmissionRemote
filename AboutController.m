//
//  AboutController.m
//  TransmissionRemote
//
//  Created by Tobias Rundström on 2010-03-14.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import "AboutController.h"


@implementation AboutController
@synthesize textView = _textView;


-(id)init
{
	self = [super initWithWindowNibName:@"AboutDialog"];
	if (self) {
	}
	return self;
}

-(void)windowDidLoad
{
	NSMutableString *text = [[_textView textStorage] mutableString];
	NSString *versionString = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
	NSString *newStr = [text stringByReplacingOccurrencesOfString:@"$(version)"
													   withString:versionString];
	
	NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:newStr];
	[[_textView textStorage] setAttributedString:attrStr];
	[attrStr release];
}

@end
