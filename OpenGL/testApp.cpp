// compile with
// gcc /System/Library/Frameworks/GLUT.framework/GLUT /System/Library/Frameworks/OpenGL.framework/OpenGL test001.c -o myGlutApp

#include <GLUT/glut.h>
#include <math.h>
#include <stdio.h>
#include <cstdlib>
#include <cstring>

//#include "testAppUtils.h"

float w = 1000;
float h = 700;

//using namespace cm;


////////// FUNCTION PROTOTYPES /////////
void clear( float r, float g, float b, float a, bool depth = true, float depthClear = 1.0f );

////////// FUNCTIONS ////////////
////////// FUNCTIONS ////////////
////////// FUNCTIONS ////////////
////////// FUNCTIONS ////////////
////////// FUNCTIONS ////////////



void 
jrSetOrthoGL( float w, float h )
{
	glMatrixMode( GL_PROJECTION );
	glLoadIdentity();
	glOrtho( 0, w, 0, h, -1,1);
	glMatrixMode( GL_MODELVIEW );
	glLoadIdentity();
}

void Octagon(float side, float height, char solid)
{
  char j;
  float x = sin(0.785398163) * side, y = side / 2.0, z = height / 2.0, c;

  c = x + y;
  for (j = 0; j < 8; j++) {
    glTranslatef(-c, 0.0, 0.0);
    if (!solid)
      glBegin(GL_LINE_LOOP);
    else
      glBegin(GL_QUADS);
    glNormal3f(-1.0, 0.0, 0.0);
    glVertex3f(0.0, -y, z);
    glVertex3f(0.0, y, z);
    glVertex3f(0.0, y, -z);
    glVertex3f(0.0, -y, -z);
    glEnd();
    glTranslatef(c, 0.0, 0.0);
    if (solid) {
      glBegin(GL_TRIANGLES);
      glNormal3f(0.0, 0.0, 1.0);
      glVertex3f(0.0, 0.0, z);
      glVertex3f(-c, -y, z);
      glVertex3f(-c, y, z);
      glNormal3f(0.0, 0.0, -1.0);
      glVertex3f(0.0, 0.0, -z);
      glVertex3f(-c, y, -z);
      glVertex3f(-c, -y, -z);
      glEnd();
    }
    glRotatef(45.0, 0.0, 0.0, 1.0);
  }
}

float frand() { return (float)rand()/RAND_MAX; }

float frand(float a, float b) { return frand()*(b-a)+a; }

void drawText( const char * str )
{
	int n = strlen(str);
	float spacing = 11;

	glPushMatrix();
	for( int i = 0; i < n; i++ )
	{
		char c = str[i];
		
		if( c != ' ' )
			glutStrokeCharacter(GLUT_STROKE_ROMAN,c);

		glTranslatef(spacing,0,0);
	}
	glPopMatrix();
}

void DrawStr(const char *str)
{
	GLint i = 0;
	
	if(!str) return;
        
	while(str[i])
	{
		glutBitmapCharacter(GLUT_BITMAP_HELVETICA_12, str[i]);
		i++;
	}
}




void 
clear( float r, float g, float b, float a, bool depth, float depthClear )
{
	glClearColor(r,g,b,a);
	GLbitfield cbits = GL_COLOR_BUFFER_BIT;
	if(depth)
	{
		glClearDepth(depthClear);
		cbits |= GL_DEPTH_BUFFER_BIT;
	}	
	glClear(cbits);
}






///////// DRAWING ROUTINES /////////////
///////// GOOOD STUFF /////////////
///////// GOOOD STUFF /////////////
///////// GOOOD STUFF /////////////
///////// GOOOD STUFF /////////////

void display(void) {
	static unsigned int t = 0, frametimer = 10;
	static float r = 0.0,g = 0.0,b = 0.0;
	
	// This timing system could definitely be done better to use vsync. 
	// Also.. frequencies are maxed out at the refresh rate.
	if((t % frametimer) == 0) {
		r = frand(0.0, 1.0);
		g = frand(0.0, 1.0);
		b = frand(0.0, 1.0);
	}
   	clear(r, g, b, 1.0, false);
	
	/*
   	gfx::setPerspectiveProjection(70, 800.0/600.0, 1,600 );
	gfx::color(1,0,1);
	gfx::identity();
	gfx::translate(0,0,-(0.5*sin(t)+0.5)*100);
	gfx::rotate(t*1000,t*30000.0,0);
	// ^^ envision transformations go from last to first

	// Draw the teapot
//	gfx::setFillMode(gfx::FILL_WIRE);
	glutWireTeapot(10);
	
	// Draw an octagon
//	gfx::setFillMode(gfx::FILL_SOLID);
	Octagon(10,10,0);
	
	// Make a starry sky
	srand(1000);
	gfx::color(1);
	gfx::setPointSize(2);
	gfx::beginVertices(gfx::POINTS);
	float r = 100;
	int n = 1000;
	for( int i = 0; i < n; i++ )
	{
		gfx::vertex(frand(-r,r),frand(-r,r),frand(-r,r ));
	}
	gfx::endVertices();
*/
	
	jrSetOrthoGL(w,h);
	drawText("JON REUS ++");
	
	glRasterPos2f(5.0, 5.0);
	DrawStr("Hello World");
	
//	gfx::setFillMode(gfx::FILL_SOLID);

	// Animate..
	t+=1;
	
    // SWAP THE TWO FRAME BUFFERS -> whatever has been drawn to the current buffer
    //  gets displayed...
    // The previous buffer becomes a new drawing surface (or something like that..)
    glutSwapBuffers();
}


// Callback for resizing window
void reshape(int width, int height) {
    glViewport(0, 0, width, height); // origin in the bottom left
    // creates a viewport for rendering within the window, to make it window-sized use window dimensions
    w = width;
    h = height;

    glMatrixMode(GL_PROJECTION);
    // sets the matrix we are affecting...

    glLoadIdentity();
    // load the ID matrix

    //set the coordinate system, with the origin in the top left
    gluOrtho2D(0, width, height, 0);    // make an orthographic view...

    glMatrixMode(GL_MODELVIEW);

    // Model view matrix is how you view the world/model - could be a camera tranformation.. 
    //  or even an object transformation..

}

void idle(void) {
    glutPostRedisplay();    // tell GLUT to redraw the screen (call the displayfunc)
                            // to implement a framerate you can implement a timer
                            // otherwise idle is called as fast as the CPU can handle
}

int main(int argc, char *argv) {

    //a basic set up...
    glutInit(&argc, &argv); // sets up the GLUT environment don't worry about it..
    
    // You have different buffers in OpenGL.
    // 1. Framebuffer (GLUT_RGBA) -> means your framebuffer will be RGBA
    // 2. DOUBLE -> you're double buffering 
    // 3. The Depth buffer is a buffer with each pixel containing a depth value... used
    //      by OpenGL for occlusion... without GLUT_DEPTH enabled you just have
    //      things drawn first-come first-serve. OpenGL has a built-in depth test utilizing
    //      the depth buffer... equal, lequal, greatthan...
    //  Not shown. Stencil buffer... 
    glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH);


    glutInitWindowSize(640, 480);

    //create the window, the argument is the title
    glutCreateWindow("GLUT program");

    //pass the callbacks
    glutDisplayFunc(display); // gets called when drawing is needed...?...
    glutReshapeFunc(reshape);   // gets called when the window is reshaped
    glutIdleFunc(idle); // gets called every frame

    // glut init game mode goes full screen... 
	glutFullScreen();
    glutMainLoop(); // this is your main event loop

    //we never get here because glutMainLoop() is an infinite loop
    return 0;

}