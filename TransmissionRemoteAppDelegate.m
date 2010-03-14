//
//  TransmissionRemoteAppDelegate.m
//  TransmissionRemote
//
//  Created by Tobias Rundström on 2010-03-13.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import "TransmissionRemoteAppDelegate.h"
#import "PreferencesWindow.h"
#import "TransmissionClient.h"

@implementation TransmissionRemoteAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *transmissionServer = [defaults dictionaryForKey:@"transmissionServer"];
	if (!transmissionServer) {
		NSLog(@"Showing Preferences Windows!");
		PreferencesWindow *win = [PreferencesWindow new];
		[win showWindow:self];
	}
}


-(BOOL)application:(NSApplication *)sender openFile:(NSString *)filename
{
	NSLog(@"filename = %@", filename);
	[[TransmissionClient client] addTorrentUrl:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@", filename]]];
	return YES;
}

-(void)application:(NSApplication *)sender openFiles:(NSArray *)filenames
{
	for (NSString *file in filenames) {
		NSLog(@"filename = %@", file);
		[[TransmissionClient client] addTorrentUrl:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@", file]]];
	}
	[sender replyToOpenOrPrint:NSApplicationDelegateReplySuccess];
}


@end
