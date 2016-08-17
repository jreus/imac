#! /bin/sh

#g++  /System/Library/Frameworks/GLUT.framework/GLUT /System/Library/Frameworks/OpenGL.framework/OpenGL testApp.cpp -o testApp

# OSC client

export MACOSX_DEPLOYMENT_TARGET=10.4
#g++ -dynamiclib -single_module -undefined dynamic_lookup -o /usr/local/lib/liblo.dylib osc_server.c -o oscApp
g++ -lliblo -o oscApp osc_server.c
chmod 777 oscApp
