/*
- Next, rehearsals, scoring and gestures..
- Make nice classes

*/

Server.default = s = Server.internal;
s.boot;

~windows = Array.newClear;
~buttons = Array.newClear;
CmdPeriod.add({
"Start Releasing".postln;
~windows.do ({|win| 
	~windows.remove(win);
	"Rel window".postln;
	win.notNil and:{win.invoke("close",defer:true);};
	win.release;
	});
~buttons.do ({|but| 
	~buttons.remove(but);
	"Rel button".postln; but.release; });
});


// Be sure to sound check threshholds with this meter first
s.meter;

// How to keep this on cmd period?
Ndef(\an,{|thresh=0.13|
	var in,amp;
	in = SoundIn.ar(0);
	amp = Amplitude.kr(in);
	SendReply.kr((amp > thresh),"/amp",[amp]);
	}).play;
	
/*
a = { Amplitude.kr(SoundIn.ar(0)); }.scope;
a.free;
*/


( // How to keep this on cmd period?
~oscreply.notNil and: {~oscreply.remove;}; ~oscreply = OSCresponder(nil, "/amp", { |t, r, msg| 
	var ampval = msg[3];
	msg.postln;
	{
		var rect, win;
		if (~windows.size > 30) {
			~windows.do {|thewin|
				~windows.remove(thewin);
				thewin.invoke("close",defer:true);
				thewin.release;
				0.01.wait;
			};
		};
		rect = Rect(rrand(0,1024),rrand(0,768),50,40);
		win = SCNSObject("NSWindow", "initWithContentRect:styleMask:backing:defer:",[rect, 15, 2, 1]);
		~windows = ~windows.add(win);
		win.invoke("setBackgroundColor:",[Color.rand],true);
		win.invoke("makeKeyAndOrderFront:",[nil],true);
	}.fork(AppClock);
}).add;
);

~windows.size



// Button Flurry
(
{
r = Rect(0,500,500,400);
o = SCNSObject("NSWindow", "initWithContentRect:styleMask:backing:defer:",[r, 15, 2, 1]);
~windows.put(0,o);
w = ~windows[0];
w.invoke("setBackgroundColor:",[Color.rand]);
w.invoke("setTitle:",["Press any key to continue…"]);
w.invoke("makeKeyAndOrderFront:",[nil],defer:true);
c = SCNSObject("NSView", "initWithFrame:", [w.invoke("frame")]);
w.invoke("setContentView:",[c], true);

220.do({arg i;
	0.02.wait;
	b = SCNSObject("NSButton", "initWithFrame:", [Rect(r.width.rand,r.height.rand,100,20)]);
	~buttons.add(b);
	c.invoke("addSubview:",[b], true);
	b.invoke("setButtonType:",[0]);
	b.invoke("setBezelStyle:",[rrand(1,6)]);
	b.invoke("setTitle:",[["OK","Apply","Quit","Cancel","Continue","Agree"].choose]);
	w.invoke("setBackgroundColor:",[Color.rand]);
	});

}.fork(AppClock);
);


// Window grid
(
{
var width, height, numcols = 12, numrows = 12;
width = Window.screenBounds.right / numcols;
height = Window.screenBounds.bottom / numrows;

numrows.do({|i| 
	
	numcols.do({|j| 
		r = Rect(j*width, i*height, width, height);
		w = SCNSObject("NSWindow", "initWithContentRect:styleMask:backing:defer:",[r,15,2,1]);
		~windows.add(w);
		w.invoke("setBackgroundColor:",[Color.rand]);
		w.invoke("makeKeyAndOrderFront:",[nil],defer:true);
		});
	
	});


}.fork(AppClock);
);






/*

Window Masks

enum {
   NSBorderlessWindowMask = 0,    					0
   NSTitledWindowMask = 1 << 0,					1
   NSClosableWindowMask = 1 << 1,					2
   NSMiniaturizableWindowMask = 1 << 2,				4
   NSResizableWindowMask = 1 << 3,					8
   NSTexturedBackgroundWindowMask = 1 << 8			256
};





Button Types

enum {
   NSMomentaryLightButton   = 0,
   NSPushOnPushOffButton    = 1,
   NSToggleButton           = 2,
   NSSwitchButton           = 3,
   NSRadioButton            = 4,
   NSMomentaryChangeButton  = 5,
   NSOnOffButton            = 6,
   NSMomentaryPushInButton  = 7,
   NSMomentaryPushButton    = 0,
   NSMomentaryLight         = 7
};
typedef NSUInteger NSButtonType;

Bezel style

enum {
   NSRoundedBezelStyle           = 1,
   NSRegularSquareBezelStyle     = 2,
   NSThickSquareBezelStyle       = 3,
   NSThickerSquareBezelStyle     = 4,
   NSDisclosureBezelStyle        = 5,
   NSShadowlessSquareBezelStyle  = 6,
   NSCircularBezelStyle          = 7,
   NSTexturedSquareBezelStyle    = 8,
   NSHelpButtonBezelStyle        = 9,
   NSSmallSquareBezelStyle       = 10,
   NSTexturedRoundedBezelStyle   = 11,
   NSRoundRectBezelStyle         = 12,
   NSRecessedBezelStyle          = 13,
   NSRoundedDisclosureBezelStyle = 14,
   NSInlineBezelStyle = 15,
   NSSmallIconButtonBezelStyle  = 2
}
typedef NSUInteger NSBezelStyle;

*/