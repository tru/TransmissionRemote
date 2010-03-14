//
//  TCURLConnection.h
//  TransmissionRemote
//
//  Created by Tobias Rundström on 2010-03-13.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TCURLConnection : NSURLConnection {
	NSMutableURLRequest *_urlRequest;
	NSMutableData *_requestData;
	NSDictionary *_requestDict;
}

-(id)initWithMutableRequest:(NSMutableURLRequest*)urlRequest delegate:(id)delegate;

@property (nonatomic, retain) NSMutableData *requestData;
@property (nonatomic, readonly, retain) NSMutableURLRequest	*urlRequest;
@property (nonatomic, retain) NSDictionary *requestDict;

@end
