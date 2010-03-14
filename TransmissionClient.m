//
//  TransmissionClient.m
//  TransmissionRemote
//
//  Created by Tobias Rundström on 2010-03-13.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import "TransmissionClient.h"
#import "JSON.h"
#import "NSDataAdditions.h"
#import "TCURLConnection.h"
#import "PreferencesWindow.h"

static TransmissionClient *_gClient = nil;

@implementation TransmissionClient

+(TransmissionClient*)client
{
	if (!_gClient) {
		_gClient = [TransmissionClient new];
	}
	return _gClient;
}

-(id)init
{
	self = [super init];
	if (self) {
		_sessionId = @"XXXY";
		
	}
	return self;
}

-(void)addTorrentUrl:(NSURL*)url
{
	
	NSDictionary *transmissionServer = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"transmissionServer"];
	if (!transmissionServer) {
		NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"Couldn't find configuration", nil)
										 defaultButton:NSLocalizedString(@"Open Preferences", nil)
									   alternateButton:NSLocalizedString(@"Skip", nil)
										   otherButton:nil
							 informativeTextWithFormat:NSLocalizedString(@"Couldn't find any configured Transmission Server, will not be able to add the torrent! Please configure a Transmission Server", nil)];
		NSInteger res = [alert runModal];
		if (res == 1) {
			[[PreferencesWindow new] showWindow:nil];
			return;
		}
		return;
	}
	
	NSString *torrentData = [[NSData dataWithContentsOfURL:url] base64EncodingWithLineLength:0];
	if (!torrentData) {
		NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"Failed to open file!", nil)
										 defaultButton:NSLocalizedString(@"OK", nil)
									   alternateButton:nil
										   otherButton:nil
							 informativeTextWithFormat:NSLocalizedString(@"Failed to open the torrent file, please try again.", nil)];
		[alert runModal];
		return;
	}
	
	NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
							   torrentData, @"metainfo",
							   nil];
	
	NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
							 @"torrent-add", @"method",
							 [NSString stringWithFormat:@"%d", _requestTag++], @"tag",
							 arguments, @"arguments",
							 nil];
	
	
	NSMutableURLRequest *urlRequest = [self doRequestWithDict:request];
	TCURLConnection *conn = [[TCURLConnection alloc] initWithMutableRequest:urlRequest delegate:self];	
	[conn release];
	[urlRequest release];
		
	NSLog(@"Sending request");
	
}

-(NSMutableURLRequest*)doRequestWithDict:(NSDictionary*)requestDict
{
	NSData *jsonData = [[requestDict JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
	
	NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"transmissionServer"];
	NSString *host = [NSString stringWithFormat:@"http://%@:%@/transmission/rpc", [dict objectForKey:@"serverIP"], [dict objectForKey:@"serverPort"]];
	
	NSLog(@"Connecting to %@", host);
	
	NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:host]];
	
	urlRequest.HTTPMethod = @"POST";
	[urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[urlRequest setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
	[urlRequest setValue:@"TransmissionRemote/0.1" forHTTPHeaderField:@"User-Agent"];
	[urlRequest setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
	[urlRequest	setValue:_sessionId forHTTPHeaderField:@"X-Transmission-Session-Id"];
	[urlRequest setHTTPBody:jsonData];

	return urlRequest;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	TCURLConnection *conn = (TCURLConnection*)connection;
	NSLog(@"Adding data %d", [data length]);
	[conn.requestData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSAlert *alert = [NSAlert alertWithError:error];
	[alert runModal];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse *resp = (NSHTTPURLResponse*)response;
	
	if ([resp statusCode] == 409) {
		_sessionId = [[[resp allHeaderFields] objectForKey:@"X-Transmission-Session-Id"] copy];
		NSLog(@"New session id = %@", _sessionId);
	}
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	TCURLConnection *conn = (TCURLConnection*)connection;
	if (![_sessionId isEqualToString:[conn.urlRequest valueForHTTPHeaderField:@"X-Transmission-Session-Id"]]) {
		NSMutableURLRequest *req = conn.urlRequest;
		[req setValue:_sessionId forHTTPHeaderField:@"X-Transmission-Session-Id"];
		TCURLConnection *newConn = [[TCURLConnection alloc] initWithMutableRequest:req delegate:self];
		[newConn release];
		
		NSLog(@"New connection should be sent");		
	}
}

@end
