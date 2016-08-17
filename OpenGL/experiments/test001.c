// compile with
// gcc /System/Library/Frameworks/GLUT.framework/GLUT /System/Library/Frameworks/OpenGL.framework/OpenGL test001.c -o myGlutApp

#include <GLUT/glut.h>
#include <math.h>

float t = 0;
float w = 800;
float h = 600;

void drawThickLine( float y )
{
    glBegin()
}

void display(void) {

    //clear white, draw with black
    // What color to clear the screen. State1.
    glClearColor(255, 255, 255, 0);

    // Call the clear command with the current state.
    // You want the depth buffer to be enabled.. glDepthMask( or something ..)

    // If the depth buffer is disabled it gets ignored by glClear
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // clears the depth buffer/color buffer

    // set current color (state)
    glColor3d(255, 255, 0);

    // draw a rectangle!
    glRecti(0, 0, 600, 400);

    glColor3d(0, 0, 0);

    //this draws a square using vertices
    glBegin(GL_LINE_LOOP);  // immediate mode -> feeding coordinates to OpenGL.
    glVertex2i(0, 0);
    glVertex2i(0, 128);
    glVertex2i(128, 128);
    glVertex2i(128, 0);
    glEnd();

    glColor3d(80,80,255);

    glBegin(GL_TRIANGLES);  // immediate mode -> feeding coordinates to OpenGL.
    glVertex2i(0, 0);
    glVertex2i(0, 128);
    glVertex2i(128, 128);
    glEnd();



    //a more useful helper
    glRecti(200, 200, 250, 250);


    // SWAP THE TWO FRAME BUFFERS -> whatever has been drawn to the current buffer
    //  gets displayed...
    // The previous buffer becomes a new drawing surface (or something like that..)
    glutSwapBuffers();
}

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

    glutMainLoop(); // this is your main event loop

    //we never get here because glutMainLoop() is an infinite loop
    return 0;

}