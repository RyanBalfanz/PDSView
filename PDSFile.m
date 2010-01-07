//
//  PDSFile.m
//  PDSView
//
//  Created by Ryan Matthew Balfanz on 12/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PDSFile.h"


@implementation PDSFile
- (id)initWithFile:(NSString *)filename
{
    if (self = [super init])
    {
		//[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.userName"
		
		stringBuffer = [[NSMutableString alloc] init];
		[self getLabelsFromFile:filename];
		[labelsTask waitUntilExit];
		[labelsTask release];
		
		dataBuffer = [[NSMutableData alloc] init];
		[self getImageFromFile:filename];
		[imageTask waitUntilExit];
		[imageTask release];
    }
	
	if (labelsTask)
	{
		NSLog(@"killing labels task");
		[labelsTask interrupt];
	}
	if (imageTask)
	{
		NSLog(@"killing labels task");
		[imageTask interrupt];
	}
	
    return self;
}

- (void)getLabelsFromFile:(NSString *)filename
{
	NSLog(@"trying to get labels from file %@", filename);	
	if (labelsTask)
	{
		NSLog(@"inturrupting task");
		[labelsTask interrupt];
	}
	else
	{
		labelsTask = [[NSTask alloc] init];
		[labelsTask setLaunchPath:@"/Users/ryan/Dev/PyPDS/src/pds-labels.py"];
		
		NSArray *args;
		args = [NSArray arrayWithObjects:filename, nil];
		[labelsTask setArguments: args];
		
		// Release the old pipe.
		[labelsPipe release];
		// Create a new pipe.
		labelsPipe = [[NSPipe alloc] init];
		[labelsTask setStandardOutput:labelsPipe];
		
		NSFileHandle *fh;
		fh = [labelsPipe fileHandleForReading];
		
		NSLog(@"Labels Notification Center");
		NSNotificationCenter *nc;
		nc = [NSNotificationCenter defaultCenter];
		[nc removeObserver:self];
		[nc addObserver:self
			   selector:@selector(labelsDataReady:)
				   name:NSFileHandleReadCompletionNotification
				 object:fh];
		[nc addObserver:self
			   selector:@selector(labelsTaskTerminated:)
				   name:NSTaskDidTerminateNotification
				 object:labelsTask];
		NSLog(@"Labels Task Launch");
		[labelsTask launch];
		//NO [labelsTask waitUntilExit];
		
		[fh readInBackgroundAndNotify];
		//[fh synchronizeFile]; // Do not do this after readInBackgroundAndNotify.

		//[labelsTask waitUntilExit]; // OK just labels
	}
	[labelsTask waitUntilExit]; // OK just labels
}

- (void)labelsAppendData:(NSData *)d
{
	NSString *buffer;
	buffer = [[NSString alloc]
			  initWithData:d
			  encoding:NSNonLossyASCIIStringEncoding];

	stringBuffer = [[[stringBuffer autorelease]
				  stringByAppendingString:buffer] retain];
	NSLog(@"stringBuffer length: %d", [stringBuffer length]);
}

- (void)labelsDataReady:(NSNotification *)n
{
	NSData *d;
	d = [[n userInfo] valueForKey:NSFileHandleNotificationDataItem];
	
	if ([d length])
	{
		[self labelsAppendData:d];
	}
	
	if (labelsTask)
	{
		[[labelsPipe fileHandleForReading] readInBackgroundAndNotify];
	}
}

- (void)labelsTaskTerminated:(NSNotification *)note
{
	NSLog(@"Labels Task terminated");
	[labelsTask release];
	labelsTask = nil;
	
	labels = [[NSString alloc] initWithString:stringBuffer];
}

- (NSString *)labels
{
	return labels;
}

- (void)getImageFromFile:(NSString *)filename
{
	NSLog(@"trying to get image from file %@", filename);
	if (imageTask)
	{
		NSLog(@"inturrupting image task");
		[imageTask interrupt];
	}
	else
	{
		NSString *python;
		python = @"/Library/Frameworks/Python.framework/Versions/5.1.1/bin/python";
		NSString *pds_image;
		pds_image = @"/Users/ryan/Dev/PyPDS/src/pds-image.py";
		
		imageTask = [[NSTask alloc] init];
		[imageTask setLaunchPath:python];
		
		NSArray *args;
		args = [NSArray arrayWithObjects:pds_image, filename, @"--format=TIFF", nil];
		[imageTask setArguments: args];
		
		// Release the old pipe.
		[imagePipe release];
				
		// Create a new pipe.
		imagePipe = [[NSPipe alloc] init];
		[imageTask setStandardOutput:imagePipe];
		//[imageTask setStandardError:imagePipe];

		// Stdout file handle
		NSFileHandle *fh;
		fh = [imagePipe fileHandleForReading];
		
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
				 object:imageTask];
		[imageTask launch];
		
		[fh readInBackgroundAndNotify];
		//[fh synchronizeFile]; // Do not do this after readInBackgroundAndNotify.

		//[imageTask waitUntilExit];
	}
	[imageTask waitUntilExit];
}

- (void)appendData:(NSData *)d
{
	[dataBuffer appendData:d];
	NSLog(@"databuffer length: %d", [dataBuffer length]);
}

- (void)dataReady:(NSNotification *)n
{
	NSData *d;
	d = [[n userInfo] valueForKey:NSFileHandleNotificationDataItem];
	
	if ([d length])
	{
		[self appendData:d];
	}
	
	if (imageTask)
	{
		[[imagePipe fileHandleForReading] readInBackgroundAndNotify];
	}
}

- (void)taskTerminated:(NSNotification *)note
{
	NSLog(@"Image Task terminated");
	[imageTask release];
	imageTask = nil;

	image = [[NSImage alloc] initWithData:dataBuffer];
}

- (NSImage *)image
{
	return image;
}

@end
