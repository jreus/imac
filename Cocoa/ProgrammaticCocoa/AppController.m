//
//  AppController.m
//  ProgrammaticCocoa
//
//  Created by jc r on 2/16/15.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController

- (id)init 
{
	[super init];
	
	windows = [NSMutableArray arrayWithCapacity: 30]; 
	
	// Start a timer to open windows on a regular basis
	appThread = [[NSTimer 
	scheduledTimerWithTimeInterval: 2 
	target:self 
	selector:@selector(appThreadCallback:) 
	userInfo:nil 
	repeats:YES] retain];

	// Message
	[self message:@"Hello World"];
	
	return self;
}


- (void)appThreadCallback:(NSTimer *)timer
{
	[self message:@"Holy Hamburgers"];
	[self openRandomWindow];
}

- (void)message:(NSString *)str
{
	NSLog(@"%@ --- windows: %d",str,[windows count]);
	NSBeep();	
}


- (void)openRandomWindow
{
	NSRect contentSize = NSMakeRect(300,300,300,300);
	unsigned int windowStyleMask = NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask;
	NSWindow *win = [[NSWindow alloc] initWithContentRect:contentSize styleMask:windowStyleMask backing:NSBackingStoreBuffered defer:YES];
	[win setBackgroundColor: [NSColor redColor]];
	[win setTitle:@"MyNewWin"];
	[windows addObject: win];
	[win makeKeyAndOrderFront:self];
}

- (void)applicationDidFinishLaunching:
{

}


@end
