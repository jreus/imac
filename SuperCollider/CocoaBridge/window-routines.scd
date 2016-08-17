/**********

Window Animations using CocoaBridge

Note that SCNSObject is broken in 3.5 (64-bit)

See:
https://github.com/supercollider/supercollider/issues/252
http://new-supercollider-mailing-lists-forums-use-these.2681727.n2.nabble.com/SCNSObject-cocoa-bridge-broken-in-3-5-td7294936.html


********/

~wins = Array.new(20);
Window.screenBounds.right;
Window.screenBounds.bottom;
~wins.add(SCNSObject("NSWindow", "initWithContentRect:styleMask:backing:defer:",
[Rect(Window.screenBounds.right,Window.screenBounds.bottom,400,200), 271, 2, 1]));
w = ~wins[0];

// Bitwise ops
256 | 8 | 4 | 2 | 1 | 0;

/*
Window Style masks
NSBorderlessWindowMask = 0,
NSTitledWindowMask = 1 << 0,
NSClosableWindowMask = 1 << 1,
NSMiniaturizableWindowMask = 1 << 2,
NSResizableWindowMask = 1 << 3,
NSTexturedBackgroundWindowMask = 1 << 8
*/


w.invoke("makeKeyAndOrderFront:",[nil], defer: true);

w.invoke("setBackgroundColor:",[Color.rand],defer:true);
w.invoke("setOpaque:",[1]);
w.invoke("setFrameTopLeftPoint:",[Point(0,900)]);
w.invoke("animationResizeTime:",[Rect(200,200,200,200)]); // time for animated resize, can be changed by subclassing NSWindow
w.invoke("setFrame:display:animate:",[Rect(0,900,200,100),1,1],defer:true);
w.invoke("setFrame:display:animate:",[Rect(400,0,300,300),1,1]);
w.invoke("performZoom:",[nil]); // simulates a mouseclick
w.invoke("zoom:",[nil]);
w.invoke("isZoomed");
w.invoke("setTitle:",["(*&"]);
w.invoke("center");
w.invoke("performClose:",[nil]); // simulate mouseclick
w.invoke("close"); // Note: DOES NOT RELEASE!
w.invoke("makeKeyAndOrderFront:",[nil], defer:true); // see.. still there
w.release;
w.invoke("close"); // There we go

// Enable minimizing..


w.invoke("performMiniaturize:",[nil], defer:true); // simulate mouseclick
w.invoke("miniaturize:",[nil], defer:true);
w.invoke("isMiniaturized");
w.invoke("deminiaturize:",[nil], defer:true);


(
s = Server.default;
CmdPeriod.add({
	Window.closeAll;
	});
w = SCWindow.new("MyWin",Rect(100,100,300,500));
w.view.background = Color(0.7,0.8,0.6);
w.view.decorator = FlowLayout( w.view.bounds );
w.front;
);

Ndef(\anal,
{
Amplitude.

});

Ndef(\anal).play;



// Get screen dimensions
Window.screenBounds;

{
SCButton.new(w,Point(100,100));
/*b = SCButton(w,Point(200,200));
//b.states = [["Yes", Color.black, Color.rand ],
				[ "No", Color.white, Color.red ]];*/
}.fork(AppClock);


(
{
32.do({arg i;
	b = SCButton(w, Rect(rrand(20,300), rrand(20, 300), 75, 24));
	b.states = [["Start " ++ i, Color.black, Color.rand ],
				[ "Stop " ++ i, Color.white, Color.red ]];
	0.1.wait;

	});

}.fork(AppClock);
);

/*
Window.allWindows;

Quarks.updateDirectory;
Quarks.gui;
Quarks.repos.quarks;
Quarks.installed;

Platform.userAppSupportDir;
Platform.userExtensionDir;
*/
