Server.default = s = Server.internal;
s.boot;

(
CmdPeriod.add({ r.remove });

{ 
var in, amp, gatethresh = 0.01, gate;
	in = SoundIn.ar(1, 1.0); 
	in = in * 5;
	gate = (in > gatethresh);
	in = in * gate;
	amp = Amplitude.kr(in, 0.005, 0.1);
	amp = amp * gate;
	SendTrig.kr(Impulse.kr(5),100,amp);
	in;
}.play;

( // init
Speech.init(1);
~thresh = 0.01;

~lastTrig = Date.getDate.bootSeconds;
~tosay = "So good";

~timethresh = 3;
~delayt = 1; // At 0.2 we get crashes.
);

r = OSCresponderNode(s.addr, '\tr', 
{|t,r,m|
	var val, currTime, tosay;
	
	val = m[3];
	currTime = Date.getDate.bootSeconds;
	val.postln;
	
	if(((val > 0.001) && ((currTime - ~lastTrig) > ~timethresh)),
	{
		Routine({
		~tosay = ["So good", "Revolutionary", "Amazing", "So good you can lick it"].choose;	
		Speech.channels[0].stop(\immediate);
		wait(~delayt);
		Speech.channels[0].speak(~tosay);
		"Go".postln;
		}).play;
	});
		
	
	}).add;

)





// Testing how much speech SC can handle.
(
Speech.init(1);
~tosay = "Hello";
~waittime = 0.3;
~delaytime = 0.3;

t = Routine {
	inf.do {
	
	~tosay = ["So good", "Revolutionary", "Amazing", "So good you can lick it"].choose;

	Speech.channels[0].stop(\immediate);
	wait(~delaytime);
	Speech.channels[0].speak(~tosay);
	wait(~waittime);
	"Go".postln;
	};
};

)
t.play;
t.stop;



