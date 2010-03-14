//
//  MenuHandler.h
//  TransmissionRemote
//
//  Created by Tobias Rundström on 2010-03-13.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MenuHandler : NSMenu<NSOpenSavePanelDelegate> {

}

-(IBAction)addTorrent:(id)sender;
-(IBAction)showPreferences:(id)sender;
-(IBAction)showAboutDialog:(id)sender;

@end
