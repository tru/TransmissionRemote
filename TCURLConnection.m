//
//  TCURLConnection.m
//  TransmissionRemote
//
//  Created by Tobias Rundström on 2010-03-13.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import "TCURLConnection.h"


@implementation TCURLConnection

@synthesize requestData = _requestData;
@synthesize urlRequest = _urlRequest;
@synthesize requestDict = _requestDict;

-(id)initWithMutableRequest:(NSMutableURLRequest *)request delegate:(id)delegate
{
	self = [super initWithRequest:request delegate:delegate];
	
	if (self) {
		_urlRequest = request;
		[_urlRequest retain];
		
		_requestData = [NSMutableData new];
		
		NSLog(@"New connection created for %@", [_urlRequest URL]);
	}
	
	return self;
}

-(void)dealloc
{
	NSLog(@"DEALLOC: TCURLConnection");
	[_requestData release];
	[_urlRequest release];
	if (_requestDict) {
		[_requestDict release];
	}
	[super dealloc];
}

@end
