//
//  MenuHandler.m
//  TransmissionRemote
//
//  Created by Tobias Rundström on 2010-03-13.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import "MenuHandler.h"
#import "TransmissionClient.h"
#import "PreferencesWindow.h"
#import "AboutController.h"

@implementation MenuHandler

-(IBAction)addTorrent:(id)sender
{
	NSOpenPanel *panel = [[NSOpenPanel openPanel] retain];
	panel.delegate = self;
	[panel setCanChooseDirectories:NO];
	[panel setCanCreateDirectories:NO];
	[panel setAllowsMultipleSelection:YES];
	[panel setPrompt:NSLocalizedString(@"Add torrent", nil)];
	[panel setMessage:NSLocalizedString(@"Select torrent to add", nil)];
	[panel beginWithCompletionHandler:^void (NSInteger result) {
		
		if (result == NSFileHandlingPanelCancelButton) {
			return;
		}
		
		for (NSURL *Url in [panel URLs]) {
			[[TransmissionClient client] addTorrentUrl:Url];
		}
		
		[panel release];
		
	}];
}

-(BOOL)panel:(id)sender shouldShowFilename:(NSString *)filename
{
	if ([filename hasSuffix:@".torrent"]) {
		return YES;
	}
	return NO;
}

-(IBAction)showPreferences:(id)sender
{
	PreferencesWindow *win = [PreferencesWindow new];
	[win showWindow:nil];
}

-(IBAction)showAboutDialog:(id)sender
{
	AboutController *aboutCtrl = [AboutController new];
	[aboutCtrl showWindow:nil];
}


@end