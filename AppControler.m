//
//  AppControler.m
//  PDSView
//
//  Created by Ryan Matthew Balfanz on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppControler.h"

#import "PDSFile.h"


@implementation AppControler

// Handle a file dropped on the dock icon
- (BOOL)application:(NSApplication *)sender openFile:(NSString *)path
{
	
	// !! Do something here with the file path !!
	[filenameField setStringValue:path];
	return YES;
}

- (IBAction)viewLabels:(id)sender
{	
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
}

@end
