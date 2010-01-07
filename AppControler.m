//
//  AppControler.m
//  PDSView
//
//  Created by Ryan Matthew Balfanz on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppControler.h"

#import "PreferenceController.h"
#import "SheetController.h"
#import "PDSFile.h"


@implementation AppControler
// http://lists.apple.com/archives/Cocoa-dev/2005/Nov/msg00346.html
- (IBAction)showPreferencePanel:(id)sender
{
	// preferenceController is a singleton
	if (!preferenceController)
	{
		preferenceController = [[PreferenceController alloc] init];
	}
	NSLog(@"Showing Preference Panel");
	[preferenceController showWindow:self];
}

- (IBAction)showCommandSheet:(id)sender
{
	if (!sheetController)
	{
		sheetController = [[SheetController alloc] init];
	}
	NSLog(@"Showing Command Sheet");
	[sheetController showWindow:self];
}

// Handle a file dropped on the dock icon
- (BOOL)application:(NSApplication *)sender openFile:(NSString *)path
{
	[filenameField setStringValue:path];
	[self updateViewsWithPDSFile:path];
	return YES;
}

- (IBAction)viewLabels:(id)sender
{
	NSAlert *progressAlert = [[[NSAlert alloc] init] autorelease];
	[progressAlert addButtonWithTitle:@"OK"];
	[progressAlert addButtonWithTitle:@"Cancel"];
	[progressAlert addButtonWithTitle:@"Hide Output"];
	[progressAlert setMessageText:@"Running PyPDS command."];
	[progressAlert setInformativeText:@"You may set the path to PyPDS in the applicaton preferences."];
	[progressAlert setAlertStyle:NSWarningAlertStyle];
	[progressAlert setShowsSuppressionButton:YES];
//    [progressAlert setAccessoryView:[sender sheetAccessoryView]];

	// Display the alert as a popup.
//	NSInteger result = [progressAlert runModal];
	
	// Display the alert as a sheet.
	[progressAlert beginSheetModalForWindow:[sender window]
						 modalDelegate:nil 
						didEndSelector:nil // @selector(alertDidEnd:returnCode:contextInfo:) 
						   contextInfo:nil];

	[self updateViewsWithPDSFile:[filenameField stringValue]];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    if (returnCode == NSAlertFirstButtonReturn)
	{
		NSLog(@"Got NSAlertFirstButtonReturn (1)");
    }
	
	if (returnCode == NSAlertSecondButtonReturn)
	{
		NSLog(@"Got NSAlertSecondButtonReturn (2)");
    }
}

- (void)updateViewsWithPDSFile:(NSString *)filename
{
	[outputView setString:@""];
	[imageView setImage:nil];
	
	PDSFile *pdsFile;
	pdsFile = [[PDSFile alloc] initWithFile:[filenameField stringValue]];

	if ([pdsFile labels])
	{
		[outputView setString:[pdsFile labels]];
	}
	else
	{
		NSLog(@"Did not get labels");
	}
	if ([pdsFile image])
	{
		[imageView setImage:[pdsFile image]];
	}
	else
	{
		NSLog(@"Did not get an image :(");
	}
	
	[pdsFile release];
}

- (void)sizeSplitViewToImage
{
	
}

@end
