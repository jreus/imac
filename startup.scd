/*
wifi login
cn017228
bV4AuDAC
*/



Server.default = s = Server.internal;
s.waitForBoot({

"Loading keycodes...".postln;
~keycodes = (
	10:'ss',
	18:'1',
	19:'2',
	20:'3',
	21:'4',
	23:'5',
	22:'6',
	26:'7',
	28:'8',
	25:'9',
	29:'0',
	27:'min',
	24:'plus',
	51:'backsp',
	48:'tab',
	12:'q',
	13:'w',
	14:'e',
	15:'r',
	17:'t',
	16:'y',
	32:'u',
	34:'i',
	31:'o',
	35:'p',
	33:'sqbrL',
	30:'sqbrR',
	36:'rtrn',
	0:'a',
	1:'s',
	2:'d',
	3:'f',
	5:'g',
	4:'h',
	38:'j',
	40:'k',
	37:'l',
	41:'semicol',
	39:'apost',
	42:'bkslsh',
	50:'tilde',	
	6:'z',
	7:'x',
	8:'c',
	9:'v',
	11:'b',
	45:'n',
	46:'m',
	43:'com',
	47:'per',
	44:'fwdslsh',
	49:'spc',
	123:'left',
	126:'up',
	125:'down',
	124:'right'
);

~keycodes.collect({|key,code| ("The key is "+key+" the code is "+code).postln});


"Initializing Server-Side Key ListenerÉ".postln;

// Using scsynth to do key listening so as not to need a target window.. these are OS-global key commands
SynthDef(\keylistener,{
	~keycodes.collect{|key, code|
		var t_state = KeyState.kr(code,0,1,lag:0);
		// SendTrig.kr(Changed.kr(state),code,state); // Changed only available in SC 3.5
	
		// Here's the 3.4.4 compatible version
		// QQQ I'm really unsure the technical reason why you need both of these.. Q for the list?
		SendTrig.kr(t_state, code, t_state);
		SendTrig.kr(1 - t_state, code, t_state);
		};
}).add;

"Initializing Server-Side Audio AnalysisÉ".postln;

~ampthresh = 0.2;
~ampincrement = 0.01;

// Amplitude listener É add some kind of debounce time here
SynthDef(\amplistener,{|thresh=0.2| 
	var in,amp,trig;
	in = LeakDC.ar(SoundIn.ar(0));
	amp = Amplitude.kr(in);
	trig = (amp > thresh);
	SendReply.kr(trig,"/amp",[amp]);
}).add;

s.sync;

k = Synth(\keylistener);
a = Synth(\amplistener);


(
l = (); // lookup functions for symbols..
~windows = Array.newClear; // array of active NSWindow objects
~views = Array.newClear; 	// array of retained NSView objects - SC retains these, but are they not autoreleased? To be looked into deeply.. maybe keeping them in this array makes them problematic. But we don't want memory leaks either.
~buttons = Array.newClear; // array of active NSButton objects
~screenWidth = Window.screenBounds.right;
~screenHeight = Window.screenBounds.bottom;
~cleaning = false;
~dbounceTime = 0.3;
~dbounceIncrement = 0.01;

"Starting audio respondersÉ".postln;
o.notNil and: {o.remove;}; 
~dbounceActive = false;
o = OSCresponder(nil, '/amp', {|t,r,msg| 
	// Default responder
	if (~dbounceActive == false) {
		~dbounceActive = true;
		("Amplitude: "++ msg[3]).postln;	
		{ ~dbounceActive = false; }.defer(~dbounceTime);
	};
}).add;
~cleanup = {"No cleanup necessary for default audio responder.".postln;};

"Starting key responders...".postln;

/* OSCFunc available only in SC 3.5
x = OSCFunc({|msg| (" "+ msg + "  " + ~keycodes[msg[2]]).postln; d[l[msg[2]]].value(msg[3].asInteger)}, \tr);
*/

// Here's the 3.4.4 compatible version
x.notNil and: {x.remove;}; x = OSCresponder(nil, '/tr', {|t, r, msg|
	if(l[~keycodes[msg[2]]] == nil) {
		("No response for key " ++ msg[3].asInteger ++ ": " ++ msg[2] ++ " //// " ++ ~keycodes[msg[2]]).postln;
	} {
		l[~keycodes[msg[2]]].value(msg[3].asInteger);
	};
}).add;

// Now add key responders like this.

// 1 default responder
l.put('1',{|val|
	if (val == 1) {
		"1 is down".postln;
		o.notNil and: {o.remove;};
		~cleanup.value; // clean up old responder
		({~cleaning == true}).while({}); // wait for last cleanup to finish
		~dbounceActive = false;
		o = OSCresponder(nil, '/amp', {|t,r,msg| 
			if (~dbounceActive == false) {
				~dbounceActive = true;
				("Amplitude: "++ msg[3]).postln;	
				{ ~dbounceActive = false; }.defer(~dbounceTime);
			};
		}).add;		
		~cleanup = {"No Cleanup is Necessary for the Default Audio Responder.".postln;};
	} {
		"1 is up".postln;
	};
});

/*
~windows = Array.newClear;
~windows;
q = SCNSObject("NSWindow","initWithContentRect:styleMask:backing:defer:",[Rect(100,100,100,100),15,2,1]);
~windows = ~windows.add(q);
~windows
~windows.find(q)
~windows.add(q);
~windows.remove(q)
~windows.remove(q)
~windows */


// 2 window grid
l.put('2',{|val|
	if (val == 1) {
		"2 is down! Go!".postln;
		o.notNil and: {o.remove;}; 
		{
			var panelwidth, panelheight, numcols=5, numrows=5,myrect,mywin,init=false;
			~cleanup.value; // clean up old responder
			({~cleaning == true}).while({}); // wait for last cleanup to finish
			"Cleanup finished".postln;
			panelwidth = ~screenWidth / numcols;
			panelheight = ~screenHeight / numrows;
			
			// Init grid
			{
				"Init start".postln;
				init = true;
				numrows.do({|i| 
					numcols.do({|j|
						myrect = Rect(j*panelwidth,i*panelheight,panelwidth,panelheight);
						mywin = SCNSObject("NSWindow","initWithContentRect:styleMask:backing:defer:",[myrect,15,2,1]);
						~windows = ~windows.add(mywin);
						//mywin.invoke("setBackgroundColor:",[Color.rand],true);
						mywin.invoke("setTitle:",[String.fill(rrand(3,20),{|i| rrand(10,9000).asAscii;})],true);
						mywin.invoke("makeKeyAndOrderFront:",[nil],defer:true);
					});	
				});
				"Init finished".postln;
				init = false;
			}.fork(AppClock);
			
			({init == true}).while({}); // how about a callback after initialization is done instead? This would all benefit from a class structure

			~dbounceActive = false;
			o = OSCresponder(nil, '/amp', {|t,r,msg| 
				if (~dbounceActive == false) {
					~dbounceActive = true;
					("Amplitude 2: "++ msg[3]).postln;
					{ ~dbounceActive = false; }.defer(~dbounceTime);
				
					block {|break|
						var vals = (1.0 / (1..20)).reverse;
						fork({
							~windows.do({|thewin,ind|
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
			~cleanup = {
				{
				({~cleaning == true}).while({}); // wait for last cleanup to finish				~cleaning = true; // could probably do this more reliably using a system/chain of callbacks
				"Cleanup".postln;
				~windows.do({|thewin,i| 
					thewin.invoke("close",defer:true);
					thewin.release;
					0.01.wait;
				});
				~windows.removeEvery(~windows);
				~cleaning = false;
				}.fork(AppClock);
			};
		}.fork(AppClock);
	} {
		"2 is up".postln;
	};
});


// 3 windows glowing
l.put('3',{|val|
	if (val == 1) {
		"3 is down! Go!".postln;
		o.notNil and: {o.remove;}; 
		{
			var panelwidth, panelheight, numcols=8, numrows=7,myrect,mywin,init=false,anivals;
			~cleanup.value; // clean up old responder
			({~cleaning == true}).while({}); // wait for last cleanup to finish
			"Cleanup finished".postln;
			panelwidth = ~screenWidth / numcols;
			panelheight = ~screenHeight / numrows;
			anivals = (1.0 / (1..20)).reverse;
			~gridspeed = 0.05;

			
			// Init grid
			{
				"Init start".postln;
				init = true;
				numrows.do({|i| 
					numcols.do({|j|
						myrect = Rect(j*panelwidth,i*panelheight,panelwidth,panelheight);
						mywin = SCNSObject("NSWindow","initWithContentRect:styleMask:backing:defer:",[myrect,15,2,1]);
						~windows = ~windows.add(mywin);
						//mywin.invoke("setBackgroundColor:",[Color.rand],true);
						mywin.invoke("setTitle:",[String.fill(rrand(3,20),{|i| rrand(10,9000).asAscii;})],true);
						mywin.invoke("makeKeyAndOrderFront:",[nil],defer:true);
					});	
				});
				"Init finished".postln;
				init = false;
			}.fork(AppClock);

			({init == true}).while({}); // how about a callback after initialization is done instead? This would all benefit from a class structure

			~dbounceActive = false;
			o = OSCresponder(nil, '/amp', {|t,r,msg| 
				if (~dbounceActive == false) {
					var rr,gg,bb;
					rr = 1.0.rand; gg=1.0.rand; bb=1.0.rand;
					~dbounceActive = true;
					
					("Amplitude 3: "++ msg[3]).postln;
					{ ~dbounceActive = false; }.defer(~dbounceTime);
				
					fork({
						~windows.do({|thewin,ind|
						{
							anivals.do({|num,ind| 
								thewin.invoke("setBackgroundColor:",[Color.new(num*rr,num*gg,num*bb,1)],true);
								0.01.wait; // single window fade speed
							});	
						}.fork(AppClock);
						~gridspeed.wait; // grid cycle speed
						});
					});
				};//endif	
			}).add;
			
			// clean up grid
			~cleanup = {
				{
				({~cleaning == true}).while({}); // wait for last cleanup to finish				~cleaning = true; // could probably do this more reliably using a system/chain of callbacks
				"Cleanup begin".postln;
				~windows.do({|thewin,i| 
					thewin.invoke("close",defer:true);
					thewin.release;
					0.01.wait;
				});
				~windows.removeEvery(~windows);
				"Cleanup end".postln;
				~cleaning = false;
				}.fork(AppClock);
			};
		}.fork(AppClock);
	} {
		"3 is up".postln;
	};
});



// 4 windows sliding
l.put('4',{|val|
	if (val == 1) {
		"4 is down! Go!".postln;
		o.notNil and: {o.remove;}; 
		{
			var panelwidth, panelheight, numpanels=6,myrect,mywin,mybut,myview;
			~cleanup.value; // clean up old responder
			({~cleaning == true}).while({}); // wait for last cleanup to finish
			panelwidth = ~screenWidth / (numpanels + 2);
			panelheight = ~screenHeight / (numpanels + 4);
			
			// Init windows
			{
				numpanels.do({|i| 
					myrect = Rect(i%2 * (~screenWidth - panelwidth - (2*i)),
								(i%4 > 1).binaryValue * (~screenHeight - panelheight),panelwidth,panelheight);
					mywin = SCNSObject("NSWindow","initWithContentRect:styleMask:backing:defer:",[myrect,271,2,1]);
					~windows = ~windows.add(mywin);
					mywin.invoke("setTitle:",[String.fill(rrand(3,20),{|i| rrand(10,9000).asAscii;})],true);
					myview = SCNSObject("NSView","initWithFrame:",[mywin.invoke("frame")]);
					~views = ~views.add(myview);
					mywin.invoke("setContentView:",[myview],true);
					mybut = SCNSObject("NSButton","initWithFrame:",[Rect(panelwidth / 2,panelheight / 2,100,20)]);
					~buttons = ~buttons.add(mybut);
					myview.invoke("addSubview:",[mybut],true);
					mybut.invoke("setButtonType:",[0]);
					mybut.invoke("setBezelStyle:",[0]);
					mybut.invoke("setTitle:",[["OK","Apply","Quit","Cancel","Continue","Agree"].choose]);
					mywin.invoke("makeKeyAndOrderFront:",[nil],true);
				});

			}.fork(AppClock);
			
			1.wait;

			// Here's where the fun starts
			~dbounceActive = false;
			o = OSCresponder(nil, '/amp', {|t,r,msg| 
				if (~dbounceActive == false) {
					~dbounceActive = true;
					("Amplitude 4: "++ msg[3]).postln;
					{ ~dbounceActive = false; }.defer(~dbounceTime);
				
					block {|break|
						{
						var torect;
						~windows.do({|thewin,ind|
							torect = Rect(rrand(0,~screenWidth),rrand(100,~screenHeight),rrand(100,300),rrand(30,200));
							thewin.invoke("setFrame:display:animate:",[torect,1,1],true);
							0.03.wait; // pause between windows
						});
						}.fork(AppClock);
					};
				};//endif	
			}).add;
			
			// clean up windows
			~cleanup = {
				{
				({~cleaning == true}).while({}); // wait for last cleanup to finish
				~cleaning = true;				
				"Cleanup".postln;
				~buttons.do({|thebut,i| 
					thebut.release;
				});
				~buttons.removeEvery(~buttons);
				
				~views.do({|theview,i| 
					theview.release;
				});
				~views.removeEvery(~views);
				
				~windows.do({|thewin,i| 
					thewin.invoke("close",defer:true);
					thewin.release;
					0.01.wait;
				});
				~windows.removeEvery(~windows);
				0.1.wait;
				~cleaning = false;
				}.fork(AppClock);
			};
		}.fork(AppClock);
	} {
		"4 is up".postln;
	};
});



// 5 window zooming
l.put('5',{|val|
	if (val == 1) {
		"5 is down! Go!".postln;
		o.notNil and: {o.remove;}; 
		{
			var mywin,myrect,panelwidth=10,panelheight=10,zoom=1;
			~cleanup.value; // clean up old responder
			({~cleaning == true}).while({}); // wait for last cleanup to finish.. seems dangerous to do these while loops, at least it's on a different thread.. that could be saving me, would be best to use callbacks
			
			~zoomdir = 1;
			// Init window
			{
				myrect = Rect((~screenWidth / 2) - (panelwidth / 2),(~screenHeight / 2) - (panelheight / 2),panelwidth,panelheight);
				mywin = SCNSObject("NSWindow","initWithContentRect:styleMask:backing:defer:",[myrect,271,2,1]);
				~windows = ~windows.add(mywin);
				mywin.invoke("setTitle:",[String.fill(rrand(3,20),{|i| rrand(10,9000).asAscii;})],true);
				mywin.invoke("center",defer:true);
				~windows = ~windows.add(mywin);
				mywin.invoke("makeKeyAndOrderFront:",[nil],true);
			}.fork(AppClock);
			
			1.wait;

			// Here's where the fun starts
			~dbounceActive = false;
			o = OSCresponder(nil, '/amp', {|t,r,msg| 
				if (~dbounceActive == false) {
					~dbounceActive = true;
					("Amplitude 5: "++ msg[3]).postln;
					{ ~dbounceActive = false; }.defer(~dbounceTime);
					{
						var therect;
						therect = mywin.invoke("frame");
						therect.width = therect.width + (100.rand * ~zoomdir);
						therect.height = therect.height + (50.rand * ~zoomdir);
						if (therect.width > ~screenWidth or:(therect.height > ~screenHeight)) {
							~zoomdir = -1;
						};
						if (therect.width < 5 or:(therect.height < 5)) {
							~zoomdir = 1;
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
			~cleanup = {
				{
				({~cleaning == true}).while({}); // wait for last cleanup to finish
				~cleaning = true;				
				"Cleanup".postln;
				~windows.do({|thewin,i| 
					thewin.invoke("close",defer:true);
					thewin.release;
					0.01.wait;
				});
				~windows.removeEvery(~windows);
				0.1.wait;
				~cleaning = false;
				}.fork(AppClock);
			};
		}.fork(AppClock);
	} {
		"5 is up".postln;
	};
});




// 6 windows minimizing / maximizing




// 7 something very simple and illustrative..
// a window pops up for each sound.. can it unminimize?












// + and - raise/lower the amp threshhold
l.put('plus',{|val|
	if (val == 1) {
		~ampthresh = ~ampthresh + ~ampincrement;
		if (~ampthresh > 1.0) { ~ampthresh = 1.0; };
		a.set(\thresh,~ampthresh);
		("++ampthresh to: "++~ampthresh).postln;
	};
});
l.put('min',{|val|
	if (val == 1) {
		~ampthresh = ~ampthresh - ~ampincrement;
		if (~ampthresh < 0.0) { ~ampthresh = 0.0; };
		a.set(\thresh,~ampthresh);
		("--ampthresh to: "++~ampthresh).postln;
	};
});



// [ and ] raise/lower debounce time
l.put('sqbrR',{|val|
	if (val == 1) {
		~dbounceTime = ~dbounceTime + ~dbounceIncrement;
		if (~dbounceTime > 1.0) { ~dbounceTime = 1.0; };
		("++dbouncetime to: "++~dbounceTime).postln;
	};
});
l.put('sqbrL',{|val|
	if (val == 1) {
		~dbounceTime = ~dbounceTime - ~dbounceIncrement;
		if (~dbounceTime < 0.05) { ~dbounceTime = 0.05; };
		("--dbounceTime to: "++~dbounceTime).postln;
	};
});





);

});




/* Free the listeners & synths
x.free;
o.free;
k.free;
a.free;
*/ 