//
//  AppControler.h
//  PDSView
//
//  Created by Ryan Matthew Balfanz on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppControler : NSObject {
	IBOutlet NSTextField *filenameField;
	IBOutlet NSButton *viewLabelsButton;	
	IBOutlet NSTextView *outputView;
	IBOutlet NSImageView *imageView;
	
	NSTask *task;
	NSPipe *pipe;
}
- (IBAction)viewLabels:(id)sender;

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)path;
- (void)updateViewsWithPDSFile:(NSString *)filename;
@end
