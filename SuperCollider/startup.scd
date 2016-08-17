/********************************

Generic SC Startup Script


2016, Jonathan Reus-Brodsky

********************************/

a = ();
a.runStartup = true; // change this to false to disable autostartup
a.programPath = "_main.scd".resolveRelative;

if(a.runStartup) {
	a.programPath.load;
}