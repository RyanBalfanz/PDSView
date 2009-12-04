//
//  AppControler.h
//  PDSView
//
//  Created by Ryan Matthew Balfanz on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppControler : NSObject {
	IBOutlet NSTextView *outputView;
	IBOutlet NSTextField *filenameField;
	IBOutlet NSButton *viewLabelsButton;
	IBOutlet NSView *imageView;
	NSTask *task;
	NSPipe *pipe;
}
- (BOOL)application:(NSApplication *)sender openFile:(NSString *)path;
- (IBAction)viewLabels:(id)sender;
@end
