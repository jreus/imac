
/* CocoaBridge!

The Objective-C synthax:
	NSNumber *n = [[NSNumber alloc] initWithFloat: 1.1];
	[n floatValue];
turns into:
*/
	n = SCNSObject("NSNumber", "initWithFloat:", [1.1]);
	n.invoke("floatValue");
/*	
Multiple messages are put together in one String and their arguments in one Array.

Example:
Cocoa:
	NSWindow *c = [[NSWindow alloc] initWithContentRect: rect styleMask: 10 backing: 2 defer:YES];
SC:
*/
c = SCNSObject("NSWindow", "initWithContentRect:styleMask:backing:defer:",[Rect(0,0,400,100), 10, 2, 1]);

/*
Some methods need to be defered. If you want to defer ust call invoke with defer:true. Watch out there is no smart protection for methods that need defer until now! In general you should defer graphic operations.
So calling this might crash sc-lang:*/
	c.invoke("makeKeyAndOrderFront:", [nil]);	
/* but this line is fine:
*/
	c.invoke("makeKeyAndOrderFront:", [nil], defer:true);


// Get mouse position
SCNSObject("NSEvent","mouseLocation");



/*
Common Conversion Table

SuperCollider will try to convert types when possible, here are the most common types and their translation
betweem the 2 languages.

SuperCollider Types		->		Objective-C Types			(when using invoke / SCNSObject.new)
----------------------------------------------------------------------------------------------------
SCNSObject						id (NSObject)
Nil								nil, NULL pointer
Number (Float, Integer)				float, int, long, short, char, NSNumber
Boolean							YES, NO, bool, NSNumber
String							NSString, SEL, char*, void*
Rect								NSRect
Color							NSColor
Point							NSPoint, NSRange, NSSize
Int8Array							void*, char*
Int16Array						void*, short*
Int32Array						void*, int*
DoubleArray						void*, double*
FloatArray						void*, float*
Signal							float*
Array							QTTime, NSRange, NSSize, SCNSObject*

Objective-C Types			->		SuperCollider Types		(on method return)
----------------------------------------------------------------------------------------------------
NSString, char*					String
NSColor							Color
NSSize, NSRange, QTTime			Array
NSRect							Rect
NSPoint							Point
BOOL, long, char, int, short			Integer
float, double						Float
c99 _bool							Boolean
*(pointer type)						RawPointer							
id, (any other NSObject)				SCNSObject


*/




