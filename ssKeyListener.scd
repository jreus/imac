/*
Make this into a class!!!! Come on this is rad.
A keylistener that responds OS-wide, even when SuperCollider is not the key application.
The key listener won't respond to key combinations.. eg. shift, cmd, alt, ctrl are ignored. 
*/

(

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

Server.default = s = Server.internal;
s.boot;
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



k = Synth(\keylistener);

d = (); // lookup functions for symbols..
/* OSCFunc available only in SC 3.5
x = OSCFunc({|msg| (" "+ msg + "  " + ~keycodes[msg[2]]).postln; d[l[msg[2]]].value(msg[3].asInteger)}, \tr);
*/

// Here's the 3.4.4 compatible version
x.notNil and: {x.remove;}; x = OSCresponder(nil, '/tr', {|t, r, msg|
	if(d[~keycodes[msg[2]]] == nil) {
		("No response for key " ++ msg[2] ++ " //// " ++ ~keycodes[msg[2]]).postln;
	} {
		d[~keycodes[msg[2]]].value(msg[3].asInteger);
	};
}).add;

);

// Free the listener & synth
x.free;
k.free;


// Now add key responders like this.

d.put('up',{|val|
	if (val == 1) {
		// Key is down
		"Up is down".postln;	
	} {
		// Key is up	
		"Up is up".postln;
	};
});

