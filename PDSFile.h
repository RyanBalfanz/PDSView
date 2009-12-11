//
//  PDSFile.h
//  PDSView
//
//  Created by Ryan Matthew Balfanz on 12/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSON.h"

@interface PDSFile : NSObject {
	NSString* labels;
	NSImage* image;
	
	NSTask *labelsTask;
	NSPipe *labelsPipe;
	
	NSTask *imageTask;
	NSPipe *imagePipe;
		
	NSMutableString *stringBuffer;
	NSMutableData *dataBuffer;

}
- (id)initWithFile:(NSString *)filename;
- (NSString *)labels;
- (NSImage *)image;
- (void)getLabelsFromFile:(NSString *)filename;
- (void)getImageFromFile:(NSString *)filename;
@end
