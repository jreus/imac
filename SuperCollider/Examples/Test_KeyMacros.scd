Server.default = s = Server.internal; // for some reason this works on imacs
k = KeyAutomator.new;
m = k.recordMacro();
m.stop;
m.playback;

m.record;


AppleScript.eval("
beep
beep
beep
");
