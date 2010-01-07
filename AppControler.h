//
//  AppControler.h
//  PDSView
//
//  Created by Ryan Matthew Balfanz on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PreferenceController;
@class SheetController;

@interface AppControler : NSObject
{
	IBOutlet NSTextField *filenameField;
	IBOutlet NSButton *viewLabelsButton;	
	IBOutlet NSTextView *outputView;
	IBOutlet NSImageView *imageView;
	
	PreferenceController *preferenceController;
	SheetController *sheetController;
	
	//NSTask *task;
	//NSPipe *pipe;
}

- (IBAction)showPreferencePanel:(id)sender;
- (IBAction)showCommandSheet:(id)sender;
- (IBAction)viewLabels:(id)sender;

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)path;
- (void)updateViewsWithPDSFile:(NSString *)filename;

@end
