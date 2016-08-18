/***********************************************

A Keypress macro recorder & player.
Relies on Keyboard for server-side keystate listening.
Will overwrite any keylogging function used in Keyboard.

Jonathan Brodsky-Reus
Aug 2016

USAGE:

k = KeyAutomator.new; // will boot the server & activate Keyboard listener if not already done
k.ignoreKeys = [Keyboard.getKeycode('up'), Keyboard.getKeycode('down'), Keyboard.getKeycode('left'), Keyboard.getKeycode('right') ];

m = k.recordMacro;
// Hit some keys
m.stop; // Stop recording
m.playback; // Playback the macro
m.loop = true; // loop the macro


Info on Key Automation in AppleScript
http://apple.stackexchange.com/questions/36943/how-do-i-automate-a-key-press-in-applescript

**********************************************/





/*********************************************************************************************
*********************************************************************************************/
KeyAutomator {
	var <macros;
	var <>ignoreKeys;

	*new {
		^super.new.initme;
	}

	initme {
		macros = [];
		ignoreKeys = [];
		// KeyAutomator uses the Keylogger of Keyboard to catch keystrokes
		Keyboard.enableKeylogger({|state, symbol, index|
			if(ignoreKeys.indexOf(index) == nil) {
				macros.do {|macro, i|
					if(macro.isRecording) {
						macro.addKeyEvent(state, symbol, index);
					};
				};
			};
		});
	}

	// Returns the macro being recorded to
	recordMacro {|startrecording=true, index=nil|
		var themacro;
		if(index.isNil) {
			themacro = KeyMacro.new;
			macros = macros.add(themacro);
		} {
			themacro = macros[index];
		};
		if(startrecording) {
			themacro.record;
		};
		^themacro;
	}

	playMacro {|macro_idx|
		macros[macro_idx].playback;
	}

	stopMacroRecording {|macro_idx|
		macros[macro_idx].stop;
	}

	clearMacroRecording {|macro_idx|
		macros[macro_idx].clear;
	}

}


/*********************************************************************************************
KeyMacro - the workhouse of KeyAutomator
Responsible for recording macros and playing them back.

Info on Key Automation in AppleScript
http://apple.stackexchange.com/questions/36943/how-do-i-automate-a-key-press-in-applescript

*********************************************************************************************/
KeyMacro {
	var <isRecording;
	var <keyEvents;
	var firstEventTime;
	var <>loop;

	*new {
		^super.new.initme;
	}

	initme {
		isRecording = false;
		loop = false;
		keyEvents = [];
		firstEventTime = nil;
	}

	record {|appendToEnd=false|
		var lastevent;
		isRecording = true;
		if(appendToEnd == false) {
			keyEvents = [];
			firstEventTime = nil;
		} {
			// If appending to the end of the current macro, then use the last event as the new firstEvent time
			lastevent = keyEvents.at(keyEvents.size - 1);
			if(lastevent.notNil) {
				firstEventTime = Process.elapsedTime - lastevent.timestamp;
			} {
				firstEventTime = Process.elapsedTime;
			};
		};
	}

	stop {
		isRecording = false;
	}

	clear {
		keyEvents = [];
		firstEventTime = nil;
	}

	addKeyEvent {|state, symbol, index|
		var timenow;
		if(isRecording) {
			timenow = Process.elapsedTime;
			if(firstEventTime.isNil) {
				firstEventTime = timenow;
				timenow = 0;
			} {
				timenow = timenow - firstEventTime;
			};
			keyEvents = keyEvents.add(KeyEvent.new(
				timenow,
				state,
				symbol,
				index
			));
		}
	}

	// Compile an AppleScript command from the macro and evaluate it.
	playback {
		var lastTimestamp = 0, command = "tell application \"System Events\"";
		keyEvents.do {|theEvent, i|
			if(theEvent.timestamp != 0) {
				command = command ++ "\n  delay" + (theEvent.timestamp - lastTimestamp).trunc(0.01);
				lastTimestamp = theEvent.timestamp;
			};
			if(theEvent.state == 1) {
				// Key Down
				command = command ++ "\n  key code" + theEvent.index + "-- down" + theEvent.symbol;
			};
		};
		command = command ++ "\nend tell";
		command.postln;
		AppleScript.eval(command, returnFunc: {|result, pid|
			if(loop == true && result == 0) {
				this.playback;
			};
		});
	}

}

KeyEvent {
	var <timestamp, <state, <symbol, <index;

	*new {|theTimestamp, theState, theSymbol, theIndex|
		^super.new.initme(theTimestamp, theState, theSymbol, theIndex);
	}

	initme {|theTimestamp, theState, theSymbol, theIndex|
		timestamp = theTimestamp;
		state = theState;
		symbol = theSymbol;
		index = theIndex;
	}
}


