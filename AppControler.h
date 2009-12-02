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
	NSTask *task;
	NSPipe *pipe;
}
- (IBAction)viewLabels:(id)sender;
@end
