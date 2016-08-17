//
//  main.m
//  ProgrammaticCocoa
//
//  Created by jc r on 2/16/15.
//  Copyright __MyCompanyName__ 2015. All rights reserved.
//	
//	A Cocoa App without interface builder
//  (for when it's necessary)
//
/*
If you want to programmatically instantiate the application without main nib, in main.m you can
instantiate the AppDelegate as below. In your apps Supporting Files / YourApp.plist Main nib base file / MainWindow.xib
should be deleted. Your AppDelegate init method can create the window. 

A timer could be used to open the windows. 

Or a sound signal.
*/
//

#import <Cocoa/Cocoa.h>
//#import "AppDelegate.h"

int main(int argc, char *argv[])
{
/*
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[NSApplication sharedApplication];
	
	AppDelegate *appDelegate = [[AppDelegate alloc] init];
	[NSApp setDelegate:appDelegate];
	[NSApp run];
	[pool release];
	return 0;
*/
    return NSApplicationMain(argc,  (const char **) argv);
}
