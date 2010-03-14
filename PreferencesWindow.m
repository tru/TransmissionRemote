//
//  PreferencesWindow.m
//  TransmissionRemote
//
//  Created by Tobias Rundström on 2010-03-14.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import "PreferencesWindow.h"


@implementation PreferencesWindow

@synthesize needsAuthButton = _needsAuthButton;
@synthesize userField = _userField;
@synthesize passwordField = _passwordField;
@synthesize serverHostField = _serverHostField;
@synthesize serverPortField = _serverPortField;

-(id)init
{
	self = [super initWithWindowNibName:@"PreferencesWindow"];
	return self;
}

-(void)windowDidLoad
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *transmissionServer = [defaults dictionaryForKey:@"transmissionServer"];
	if (transmissionServer) {
		NSString *tmp = [transmissionServer objectForKey:@"serverIP"];
		if (tmp) {
			[_serverHostField setStringValue:tmp];
		}
		tmp = [transmissionServer objectForKey:@"serverPort"];
		if (tmp) {
			[_serverPortField setStringValue:tmp];
		}
		
		[_needsAuthButton setState:[defaults integerForKey:@"needsAuthState"]];
		tmp = [transmissionServer objectForKey:@"username"];
		if (tmp) {
			[_userField setStringValue:tmp];
			if (_needsAuthButton.state == NSOnState) {
				[_userField setEnabled:YES];
			}
		}
		tmp = [transmissionServer objectForKey:@"password"];
		if (tmp) {
			[_passwordField setStringValue:tmp];
			if (_needsAuthButton.state == NSOnState) {
				[_passwordField setEnabled:YES];
			}

		}
	}

}

-(IBAction)textChanged:(id)pId
{
}

-(void)save
{
	
	NSLog(@"Saving preferences!");
	
	NSMutableDictionary *transmissionServer = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"transmissionServer"] mutableCopy];
	if (!transmissionServer) {
		transmissionServer = [NSMutableDictionary new];
	}
	
	[transmissionServer setObject:[_serverHostField stringValue] forKey:@"serverIP"];
	NSLog(@"Setting serverIP to %@", [_serverHostField stringValue]);
	[transmissionServer setObject:[_serverPortField stringValue] forKey:@"serverPort"];
	[transmissionServer setObject:[_passwordField stringValue] forKey:@"password"];
	[transmissionServer setObject:[_userField stringValue] forKey:@"username"];
	
	[[NSUserDefaults standardUserDefaults] setObject:transmissionServer forKey:@"transmissionServer"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)windowWillClose:(NSNotification*)notif
{
	NSLog(@"Window is closing!");
	[self save];
}

-(void)dealloc
{
	NSLog(@"DEALLOC: PreferencesWindow");
	
	[_serverHostField release];
	[_serverPortField release];
	[_passwordField release];
	[_userField release];
	[_needsAuthButton release];
	
	[super dealloc];
}

-(IBAction)needsAuthToggle:(id)pId
{
	if (_needsAuthButton.state == NSOnState) {
		[_userField setEnabled:YES];
		[_passwordField setEnabled:YES];
	} else {
		[_userField setEnabled:NO];
		[_passwordField setEnabled:NO];
	}
	
	[[NSUserDefaults standardUserDefaults] setInteger:_needsAuthButton.state forKey:@"needsAuthState"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


@end
