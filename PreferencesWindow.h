//
//  PreferencesWindow.h
//  TransmissionRemote
//
//  Created by Tobias Rundström on 2010-03-14.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PreferencesWindow : NSWindowController {
	NSTextField	*_serverHostField;
	NSTextField *_serverPortField;
	NSButton *_needsAuthButton;
	NSTextField *_userField;
	NSSecureTextField *_passwordField;
}

-(IBAction)needsAuthToggle:(id)pId;
-(IBAction)textChanged:(id)pId;

@property (nonatomic, retain) IBOutlet NSTextField *serverHostField;
@property (nonatomic, retain) IBOutlet NSTextField *serverPortField;
@property (nonatomic, retain) IBOutlet NSTextField *userField;
@property (nonatomic, retain) IBOutlet NSSecureTextField *passwordField;
@property (nonatomic, retain) IBOutlet NSButton *needsAuthButton;

@end
