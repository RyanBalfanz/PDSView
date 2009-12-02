//
//  AppControler.m
//  PDSView
//
//  Created by Ryan Matthew Balfanz on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppControler.h"


@implementation AppControler

- (IBAction)viewLabels:(id)sender
{
	if (task) {
		[task interrupt];
	} else {
		task = [[NSTask alloc] init];
		[task setLaunchPath:@"/Users/ryan/Dev/PyPDS/src/pds-labels.py"];
		
		NSArray *args = [NSArray arrayWithObjects:[filenameField stringValue], nil];
		[task setArguments:args];
		
		// Release the old pipe.
		[pipe release];
		// Create a new pipe.
		pipe = [[NSPipe alloc] init];
		[task setStandardOutput:pipe];
		
		NSFileHandle *fh = [pipe fileHandleForReading];
		
		NSNotificationCenter *nc;
		nc = [NSNotificationCenter defaultCenter];
		[nc removeObserver:self];
		[nc addObserver:self
			   selector:@selector(dataReady:)
				   name:NSFileHandleReadCompletionNotification
				 object:fh];
		[nc addObserver:self
			   selector:@selector(taskTerminated:)
				   name:NSTaskDidTerminateNotification
				 object:task];
		[task launch];
		[outputView setString:@""];
		
		[fh readInBackgroundAndNotify];
	}
}

- (void)appendData:(NSData	*)d
{
	NSString *s = [[NSString alloc]	initWithData:d encoding:NSUTF8StringEncoding];
	NSTextStorage *ts = [outputView textStorage];
	[ts replaceCharactersInRange:NSMakeRange([ts length], 0) withString:s];
	[s release];
}

- (void)dataReady:(NSNotification *)n
{
	NSData *d;
	d = [[n userInfo] valueForKey:NSFileHandleNotificationDataItem];
	
	NSLog(@"dataReady:%d bytes", [d length]);
	
	if ([d length]) {
		[self appendData:d];
	}
	
	if (task)
		[[pipe fileHandleForReading] readInBackgroundAndNotify];
}

- (void)taskTerminated:(NSNotification *)note
{
	NSLog(@"taskTerminated:");
	
	[task release];
	task = nil;
}

@end
