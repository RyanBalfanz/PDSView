//
//  PDSViewAppDelegate.h
//  PDSView
//
//  Created by Ryan Matthew Balfanz on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PDSViewAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	NSView *sheetAccessoryView;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *sheetAccessoryView;


@end
