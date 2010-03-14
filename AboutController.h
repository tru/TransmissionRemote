//
//  AboutController.h
//  TransmissionRemote
//
//  Created by Tobias Rundström on 2010-03-14.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AboutController : NSWindowController {
	NSTextView *_textView;
}

@property (nonatomic, retain) IBOutlet NSTextView *textView;

@end
