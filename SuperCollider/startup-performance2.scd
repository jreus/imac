Server.default = s = Server.internal;
s.waitForBoot({

{ SoundIn.ar([0,1]) }.play;

r = Routine {
	wait(1.0);
	Speech.init(5);
	wait(0.2);
	Speech.channels[0].voice_(5);
	Speech.channels[1].voice_(5); // VERY SLOW VOICE! BE CAREFUL!
	Speech.channels[2].voice_(5);
	wait(0.2);
	Speech.channels[0].speak("Revolution.");
	wait(5.0);
	wait(0.1);
	Speech.channels[1].speak("Revolution 1.");
	wait(5.0);
	wait(0.1);
	Speech.channels[2].speak("Revolution 2.");
	wait(4.0);
("osascript" 
	+" -e 'tell application \"System Events\"'" 
	+" -e 'repeat 100 times'" 
	+" -e 'key code 103'"
	+" -e 'delay 0.2'"
	+" -e 'end repeat'"
	+" -e 'repeat 30 times'"
	+" -e 'key code 109'"  
	+" -e 'delay 0.2'"  
	+" -e 'end repeat'" 
	+" -e 'end tell'"
	).unixCmd;
	Speech.channels[3].speak("Revolution 3.");
	wait(4.0);
	Speech.channels[4].speak("Revolution 4.");
	wait(4.0);
	Speech.channels[0].speak("Revolution 5.");
	wait(4.0);
	Speech.channels[1].speak("Revolution 6.");
	wait(4.0);
	Speech.channels[2].speak("Revolution 7.");
	wait(4.0);
	Speech.channels[3].speak("Revolution 67.");
	wait(4.0);
	Speech.channels[4].speak("Revolution 68.");
	wait(4.0);
	Speech.channels[5].speak("Revolution 115.");


};
r.play;

/*
{
	var in,amp,gate,thresh=0.1;
	in = SoundIn.ar(0);
	gate = (in > thresh);
	in = (gate * in) * 2.0;
	amp = RunningSum.rms(in, 200);
	SinOsc.ar(SinOsc.ar(100,mul:4400),mul: amp);
	//Lag.ar(in, 0.01);
	in;
};
*/

});