#include <GLUT/glut.h>
#include <math.h>
#include <stdio.h>
#include <cstdlib>
#include <cstring>
#include "testAppUtils.h"

#pragma once

void 
clear( float r, float g, float b, float a, bool depth = true, float depthClear = 1.0f );

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