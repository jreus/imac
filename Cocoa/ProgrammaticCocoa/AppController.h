//
//  AppController.h
//  ProgrammaticCocoa
//
//  Created by jc r on 2/16/15.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
	NSTimer *appThread;
	NSMutableArray *windows;
}

- (void)openRandomWindow;

- (void)message:(NSString *)str;

@end
