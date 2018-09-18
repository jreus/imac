/**********************
Keyboard controls & OSC responders

**************/
a = a ? ();
a.ampthresh = 0.2;
a.ampincrement = 0.01;
// Window Animations
a.windows = []; // array of NSWindow objects which are open
a.views = [];
a.buttons = []; // array of active NSButton objects
a.screenWidth = Window.screenBounds.right;
a.screenHeight = Window.screenBounds.bottom;
a.cleaning = false;
a.dbounceTime = 0.3;
a.dbounceIncrement = 0.01;
a.dbounceActive = false;
o.notNil and: {o.remove;}; // OSC responder for amplitude
o = OSCresponder(nil, '/amp', {|t,r,msg|
		// Default responder
	if (a.dbounceActive == false) {
		a.dbounceActive = true;
		("Amplitude: "++ msg[3]).postln;
		{ a.dbounceActive = false; }.defer(a.dbounceTime);
	};
}).add;
c = {"No cleanup necessary for default audio responder.".postln;}; // cleanup function


Post << "Starting key responders...\n";
Keyboard.enable(s);
Keyboard.setVerbose(true);


// Keystroke Macromaker
a.automator = KeyAutomator.new;

// Add control keys to the macro ignore list
a.automator.ignoreKeys = [
		Keyboard.getKeycode('1'),  // record macro
		Keyboard.getKeycode('2'),  // stop recording
		Keyboard.getKeycode('3'),  // playback macro
		Keyboard.getKeycode('4'),  // loop macro on/off
		Keyboard.getKeycode('5'),  // default audio responder (do nothing)
		Keyboard.getKeycode('6'),  // window grid
		Keyboard.getKeycode('7'),  // window glow
		Keyboard.getKeycode('8'),  // window slide
		Keyboard.getKeycode('9'),  // window zoom
		Keyboard.getKeycode('0'),  // animate desktop background
		Keyboard.getKeycode('equal'),  // +increment amp thresh
		Keyboard.getKeycode('minus'),  // -decrement amp thresh
		Keyboard.getKeycode('leftbracket'),  // -decrement debounce time
		Keyboard.getKeycode('rightbracket'),  // +increment debounce time
];


/*************** Record/Loop Key Gestures ************
******************************************************/
Post << "Loading Macro Recording Controls...\n";

Keyboard.addKeyResponder('1',{|val|
	var macro;
	if (val == 1) {
		macro = a.automator.recordMacro(0, true);
		("Recording Macro 0").postln;
	};
});

Keyboard.addKeyResponder('2',{|val|
	var macro;
	if (val == 1) {
		macro = a.automator.stopMacroRecording(0);
		("Stop Recording Macro 0").postln;
	};
});

Keyboard.addKeyResponder('3',{|val|
	var macro;
	if (val == 1) {
		macro = a.automator.playMacro(0);
		("Play Macro 0").postln;
	};
});

Keyboard.addKeyResponder('4',{|val|
	var macro;
	if (val == 1) {
		macro = a.automator.toggleMacroLooping(0);
		("Macro 0 looping toggled:"+macro.loop).postln;
	};
});

// Desktop animation
Keyboard.addKeyResponder('0',{|val|
	var macro;
	if (val == 1) {
		macro = a.automator.toggleMacroLooping(0);
		("Animate Desktop BG:"+macro.loop).postln;
	};
});


~animatorScript = "/Volumes/Store/Box\ Sync/_PROJECTS/imac/AppleScript/screenshot_bg_animator.scpt";
~animatorScript = "/Users/imac/Documents/imac/AppleScript/screenshot_bg_animator.scpt";
("osascript" + ~animatorScript).unixCmd;


/*************** Control Listener Threshholds & Debounce ************
*********************************************************************/
Post << "Loading Threshhold & Debounce Controls...\n";


// + and - raise/lower the amp threshhold
Keyboard.addKeyResponder('equal',{|val|
	if (val == 1) {
		a.ampthresh = a.ampthresh + a.ampincrement;
		if (a.ampthresh > 1.0) { a.ampthresh = 1.0; };
		a.listener_synth.set(\thresh, a.ampthresh);
		("++ampthresh to:"+ a.ampthresh).postln;
	};
});

Keyboard.addKeyResponder('minus',{|val|
	if (val == 1) {
		a.ampthresh = a.ampthresh - a.ampincrement;
		if (a.ampthresh < 0.0) { a.ampthresh = 0.0; };
		a.listener_synth.set(\thresh, a.ampthresh);
		("--ampthresh to:"+ a.ampthresh).postln;
	};
});


// [ and ] raise/lower debounce time
Keyboard.addKeyResponder('rightbracket',{|val|
	if (val == 1) {
		a.dbounceTime = a.dbounceTime + a.dbounceIncrement;
		if (a.dbounceTime > 1.0) { a.dbounceTime = 1.0; };
		("++dbouncetime to:" + a.dbounceTime).postln;
	};
});

Keyboard.addKeyResponder('leftbracket',{|val|
	if (val == 1) {
		a.dbounceTime = a.dbounceTime - a.dbounceIncrement;
		if (a.dbounceTime < 0.05) { a.dbounceTime = 0.05; };
		("--dbounceTime to:"+a.dbounceTime).postln;
	};
});



/*************** Window Animations ************
These use CocoaBridge so make sure a.cocoaBridge = true
***********************************************/

/*

Post << "Loading CocoaBridge Responders...\n";

// 5 default responder
Keyboard.addKeyResponder('5', {|val|
	if (val == 1) {
		"5 - default is down".postln;
		o.notNil and: {o.remove;};
		c.value; // clean up old responder
		({a.cleaning == true}).while({}); // wait for last cleanup to finish
		a.dbounceActive = false;
		o = OSCresponder(nil, '/amp', {|t,r,msg|
			if (a.dbounceActive == false) {
				a.dbounceActive = true;
				("Amplitude: "++ msg[3]).postln;
				{ a.dbounceActive = false; }.defer(a.dbounceTime);
			};
		}).add;
		c = {"No Cleanup is Necessary for the Default Audio Responder.".postln;};
	} {
		"5 - default is up".postln;
	};
});



// 6 window grid
Keyboard.addKeyResponder('6',{|val|
	if (val == 1) {
		"6 is down! Go!".postln;
		o.notNil and: {o.remove;};
		{
			var panelwidth, panelheight, numcols=5, numrows=5,myrect,mywin,init=false;
			c.value; // clean up old responder
			({a.cleaning == true}).while({}); // wait for last cleanup to finish
			"Cleanup finished".postln;
			panelwidth = a.screenWidth / numcols;
			panelheight = a.screenHeight / numrows;

			// Init grid
			{
				"Init start".postln;
				init = true;
				numrows.do({|i|
					numcols.do({|j|
						myrect = Rect(j*panelwidth,i*panelheight,panelwidth,panelheight);
						mywin = SCNSObject("NSWindow","initWithContentRect:styleMask:backing:defer:",[myrect,15,2,1]);
						a.windows = a.windows.add(mywin);
						//mywin.invoke("setBackgroundColor:",[Color.rand],true);
						mywin.invoke("setTitle:",[String.fill(rrand(3,20),{|i| rrand(10,9000).asAscii;})],true);
						mywin.invoke("makeKeyAndOrderFront:",[nil],defer:true);
					});
				});
				"Init finished".postln;
				init = false;
			}.fork(AppClock);

			({init == true}).while({}); // how about a callback after initialization is done instead? This would all benefit from a class structure

			a.dbounceActive = false;
			o = OSCresponder(nil, '/amp', {|t,r,msg|
				if (a.dbounceActive == false) {
					a.dbounceActive = true;
					("Amplitude 2: "++ msg[3]).postln;
					{ a.dbounceActive = false; }.defer(a.dbounceTime);

					block {|break|
						var vals = (1.0 / (1..20)).reverse;
						fork({
							a.windows.do({|thewin,ind|
								{
									vals.do({|num,ind|
										thewin.invoke("setAlphaValue:",[num],true);
										0.01.wait; // animation fade speed
									});
								}.fork(AppClock);
								0.1.wait; // window cycle speed
							});
						});
					};
				};//endif
			}).add;

			// clean up grid
			c = {
				{
					({a.cleaning == true}).while({}); // wait for last cleanup to finish				~cleaning = true; // could probably do this more reliably using a system/chain of callbacks
					"Cleanup".postln;
					a.windows.do({|thewin,i|
						thewin.invoke("close",defer:true);
						thewin.release;
						0.01.wait;
					});
					a.windows.removeEvery(a.windows);
					a.cleaning = false;
				}.fork(AppClock);
			};
		}.fork(AppClock);
	} {
		"6 is up".postln;
	};
});


// 7 windows glowing
Keyboard.addKeyResponder('7',{|val|
	if (val == 1) {
		"7 is down! Go!".postln;
		o.notNil and: {o.remove;};
		{
			var panelwidth, panelheight, numcols=8, numrows=7,myrect,mywin,init=false,anivals;
			c.value; // clean up old responder
			({a.cleaning == true}).while({}); // wait for last cleanup to finish
			"Cleanup finished".postln;
			panelwidth = a.screenWidth / numcols;
			panelheight = a.screenHeight / numrows;
			anivals = (1.0 / (1..20)).reverse;
			a.gridspeed = 0.05;


			// Init grid
			{
				"Init start".postln;
				init = true;
				numrows.do({|i|
					numcols.do({|j|
						myrect = Rect(j*panelwidth,i*panelheight,panelwidth,panelheight);
						mywin = SCNSObject("NSWindow","initWithContentRect:styleMask:backing:defer:",[myrect,15,2,1]);
						a.windows = a.windows.add(mywin);
						//mywin.invoke("setBackgroundColor:",[Color.rand],true);
						mywin.invoke("setTitle:",[String.fill(rrand(3,20),{|i| rrand(10,9000).asAscii;})],true);
						mywin.invoke("makeKeyAndOrderFront:",[nil],defer:true);
					});
				});
				"Init finished".postln;
				init = false;
			}.fork(AppClock);

			({init == true}).while({}); // how about a callback after initialization is done instead? This would all benefit from a class structure

			a.dbounceActive = false;
			o = OSCresponder(nil, '/amp', {|t,r,msg|
				var rr, gg, bb;
				if (a.dbounceActive == false) {
					rr = 1.0.rand; gg=1.0.rand; bb=1.0.rand;
					a.dbounceActive = true;

					("Amplitude 3: "++ msg[3]).postln;
					{ a.dbounceActive = false; }.defer(a.dbounceTime);

					fork({
						a.windows.do({|thewin,ind|
							{
								anivals.do({|num,ind|
									thewin.invoke("setBackgroundColor:",[Color.new(num*rr,num*gg,num*bb,1)],true);
									0.01.wait; // single window fade speed
								});
							}.fork(AppClock);
							a.gridspeed.wait; // grid cycle speed
						});
					});
				};//endif
			}).add;

			// clean up grid
			c = {
				{
					({a.cleaning == true}).while({}); // wait for last cleanup to finish				~cleaning = true; // could probably do this more reliably using a system/chain of callbacks
					"Cleanup begin".postln;
					a.windows.do({|thewin,i|
						thewin.invoke("close",defer:true);
						thewin.release;
						0.01.wait;
					});
					a.windows.removeEvery(a.windows);
					"Cleanup end".postln;
					a.cleaning = false;
				}.fork(AppClock);
			};
		}.fork(AppClock);
	} {
		"7 is up".postln;
	};
});



// 8 windows sliding
Keyboard.addKeyResponder('8',{|val|
	if (val == 1) {
		"8 is down! Go!".postln;
		o.notNil and: {o.remove;};
		{
			var panelwidth, panelheight, numpanels=6,myrect,mywin,mybut,myview;
			c.value; // clean up old responder
			({a.cleaning == true}).while({}); // wait for last cleanup to finish
			panelwidth = a.screenWidth / (numpanels + 2);
			panelheight = a.screenHeight / (numpanels + 4);

			// Init windows
			{
				numpanels.do({|i|
					myrect = Rect(i%2 * (a.screenWidth - panelwidth - (2*i)),
						(i%4 > 1).binaryValue * (a.screenHeight - panelheight),panelwidth,panelheight);
					mywin = SCNSObject("NSWindow","initWithContentRect:styleMask:backing:defer:",[myrect,271,2,1]);
					a.windows = a.windows.add(mywin);
					mywin.invoke("setTitle:",[String.fill(rrand(3,20),{|i| rrand(10,9000).asAscii;})],true);
					myview = SCNSObject("NSView","initWithFrame:",[mywin.invoke("frame")]);
					a.views = a.views.add(myview);
					mywin.invoke("setContentView:",[myview],true);
					mybut = SCNSObject("NSButton","initWithFrame:",[Rect(panelwidth / 2,panelheight / 2,100,20)]);
					a.buttons = a.buttons.add(mybut);
					myview.invoke("addSubview:",[mybut],true);
					mybut.invoke("setButtonType:",[0]);
					mybut.invoke("setBezelStyle:",[0]);
					mybut.invoke("setTitle:",[["OK","Apply","Quit","Cancel","Continue","Agree"].choose]);
					mywin.invoke("makeKeyAndOrderFront:",[nil],true);
				});

			}.fork(AppClock);

			1.wait;

			// Here's where the fun starts
			a.dbounceActive = false;
			o = OSCresponder(nil, '/amp', {|t,r,msg|
				if (a.dbounceActive == false) {
					a.dbounceActive = true;
					("Amplitude 4: "++ msg[3]).postln;
					{ a.dbounceActive = false; }.defer(~dbounceTime);

					block {|break|
						{
							var torect;
							a.windows.do({|thewin,ind|
								torect = Rect(rrand(0,a.screenWidth),rrand(100,a.screenHeight),rrand(100,300),rrand(30,200));
								thewin.invoke("setFrame:display:animate:",[torect,1,1],true);
								0.03.wait; // pause between windows
							});
						}.fork(AppClock);
					};
				};//endif
			}).add;

			// clean up windows
			c = {
				{
					({a.cleaning == true}).while({}); // wait for last cleanup to finish
					a.cleaning = true;
					"Cleanup".postln;
					a.buttons.do({|thebut,i|
						thebut.release;
					});
					a.buttons.removeEvery(a.buttons);

					a.views.do({|theview,i|
						theview.release;
					});
					a.views.removeEvery(a.views);

					a.windows.do({|thewin,i|
						thewin.invoke("close",defer:true);
						thewin.release;
						0.01.wait;
					});
					a.windows.removeEvery(a.windows);
					0.1.wait;
					a.cleaning = false;
				}.fork(AppClock);
			};
		}.fork(AppClock);
	} {
		"8 is up".postln;
	};
});



// 9 window zooming
Keyboard.addKeyResponder('9',{|val|
	if (val == 1) {
		"9 is down! Go!".postln;
		o.notNil and: {o.remove;};
		{
			var mywin,myrect,panelwidth=10,panelheight=10,zoom=1;
			c.value; // clean up old responder
			({a.cleaning == true}).while({}); // wait for last cleanup to finish.. seems dangerous to do these while loops, at least it's on a different thread.. that could be saving me, would be best to use callbacks

			a.zoomdir = 1;
			// Init window
			{
				myrect = Rect((a.screenWidth / 2) - (panelwidth / 2),(a.screenHeight / 2) - (panelheight / 2),panelwidth,panelheight);
				mywin = SCNSObject("NSWindow","initWithContentRect:styleMask:backing:defer:",[myrect,271,2,1]);
				a.windows = a.windows.add(mywin);
				mywin.invoke("setTitle:",[String.fill(rrand(3,20),{|i| rrand(10,9000).asAscii;})],true);
				mywin.invoke("center",defer:true);
				a.windows = a.windows.add(mywin);
				mywin.invoke("makeKeyAndOrderFront:",[nil],true);
			}.fork(AppClock);

			1.wait;

			// Here's where the fun starts
			a.dbounceActive = false;
			o = OSCresponder(nil, '/amp', {|t,r,msg|
				if (a.dbounceActive == false) {
					a.dbounceActive = true;
					("Amplitude 9: "++ msg[3]).postln;
					{ a.dbounceActive = false; }.defer(a.dbounceTime);
					{
						var therect;
						therect = mywin.invoke("frame");
						therect.width = therect.width + (100.rand * a.zoomdir);
						therect.height = therect.height + (50.rand * a.zoomdir);
						if (therect.width > a.screenWidth or:(therect.height > a.screenHeight)) {
							a.zoomdir = -1;
						};
						if (therect.width < 5 or:(therect.height < 5)) {
							a.zoomdir = 1;
						};
						//mywin.invoke("zoom:",[nil],true);
						//panelwidth = rrand(5,~screenWidth);panelheight = rrand(5,~screenHeight);
						//torect = Rect((~screenWidth / 2) - (panelwidth / 2),(~screenHeight / 2) - (panelheight / 2),panelwidth,panelheight);
						mywin.invoke("setTitle:",[String.fill(rrand(3,20),{|i| rrand(10,9000).asAscii;})],true);
						mywin.invoke("setFrame:display:animate:",[therect,1,1],true);
						mywin.invoke("center",defer:true);
					}.fork(AppClock);
				};//endif
			}).add;

			// clean up window
			c = {
				{
					({a.cleaning == true}).while({}); // wait for last cleanup to finish
					a.cleaning = true;
					"Cleanup".postln;
					a.windows.do({|thewin,i|
						thewin.invoke("close",defer:true);
						thewin.release;
						0.01.wait;
					});
					a.windows.removeEvery(a.windows);
					0.1.wait;
					a.cleaning = false;
				}.fork(AppClock);
			};
		}.fork(AppClock);
	} {
		"9 is up".postln;
	};
});

// Others...
//windows minimizing / maximizing
//something very simple and illustrative..
//window pops up for each sound.. can it unminimize?

// END COCOABRIDGE DEPENDENT CODE
// NTS:: This stuff could be coded in Xcode more easily.
*/




/* Free the listeners & synths
x.free;
o.free;
k.free;
a.free;
*/


