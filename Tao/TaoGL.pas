 {$reference Tao.FreeGlut.dll}
 {$reference Tao.OpenGl.dll}

   
 uses
   System, System.Collections.Generic, System.Linq, System.Text, 
   Tao.OpenGl, Tao.FreeGlut;


 procedure init_graphics;
 begin
   Gl.glEnable(Gl.GL_LIGHTING);
   Gl.glEnable(Gl.GL_LIGHT0);
   Gl.glEnable(Gl.GL_DEPTH_TEST);
   Gl.glClearColor(0, 0, 0, 1);
 end;

 procedure on_display();
 begin
   Gl.glClear(Gl.GL_COLOR_BUFFER_BIT or Gl.GL_DEPTH_BUFFER_BIT);
   Gl.glLoadIdentity();
   Glu.gluLookAt(0, 0, 5, 0, 0, 1, 0, 1, 0);
   Glut.glutSolidTeapot(1);
   Glut.glutSwapBuffers();
 end;

 procedure on_reshape( w, h:integer);
 begin
   Gl.glMatrixMode(Gl.GL_PROJECTION);
   Gl.glLoadIdentity();
   Gl.glViewport(0, 0, w, h);
   Glu.gluPerspective(40, w / h, 1, 100);
   Gl.glMatrixMode(Gl.GL_MODELVIEW);
 end;

 
 begin
   Glut.glutInit();
   Glut.glutInitWindowSize(500, 500);
   Glut.glutCreateWindow('Tao Example');
   init_graphics();
   Glut.glutDisplayFunc(on_display);
   Glut.glutReshapeFunc(on_reshape);
   Glut.glutMainLoop();
 end.
