s = Server.internal.boot;

s.waitForBoot({
	"Show me a window".postln;

	~myscwin = Window.new("Test Window").front;
	/*

	~mywin = SCNSObject("NSWindow","initWithContentRect:styleMask:backing:defer:",[Rect(100,100,100,100),15,2,1]);
	~mywin.invoke("setTitle:",[String.fill(rrand(3,20),{|i| rrand(10,9000).asAscii;})],true);
	~mywin.invoke("makeKeyAndOrderFront:",[nil],defer:true);
*/

});