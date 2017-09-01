{$reference System.Windows.Forms.dll}
{$reference System.Drawing.dll}

 
uses System, System.Drawing, System.Windows.Forms, OpenGL;
 
type Form1 = class (Form)

private
 _hdc : HDC;
 timer: Timer;
 components: System.ComponentModel.IContainer;
 
 // ���� ��������
 RotY : integer;

public

//--------------------------------------------//
//------   �������������  ����������   -------//
//--------------------------------------------//
procedure Init;
begin
  // ��������� OpenGL
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LEQUAL);
  glClearDepth(1.0);
  glHint(GL_PERSPECTIVE_CORRECTION_HINT,GL_NICEST);
  
  // ��������� ������/���� ���������
  glMatrixMode( GL_PROJECTION );
  glLoadIdentity;
  glViewport(0, 0, Width, Height);
  gluPerspective(45.0, Width/Height, 0.1, 1000.0);
  
  // ��������� ������� ����/�������
  glMatrixMode( GL_MODELVIEW );
  glLoadIdentity;

  // ������������� ����������
  RotY := 0;
end;

//--------------------------------------------//
//------     ��������� ���������       -------//
//--------------------------------------------//
procedure Render(sender: Object; e: EventArgs);
begin
  // ������� ���� 
  glClearColor(single(0.0), single(0.0), single(0.0), single(0.0));
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  // ��������� �����������/������
  glLoadIdentity();
  gluLookAt(0.0,0.0,5.0,  0.0,0.0,0.0,  0.0,1.0,0.0);
 
  glPushMatrix();
  // ������������� ������� � �������
  glTranslatef(0,0,0);
  glRotatef(RotY, 0.0, 1.0, 0.0);
  // ������ ������
  glBegin(GL_TRIANGLES); //������ �����������
  glColor3f(1,0,0);  glVertex3f(0, 1, 0); //������ �������
  glColor3f(0,1,0);  glVertex3f(1, -1, 0); //������ �������
  glColor3f(0,1,0);  glVertex3f(-1,-1, 0); //������ �������
  glEnd;  
  
  glPopMatrix();
  
  // ����������� ����  ��������
  RotY += 1; 
  
  // ������� ���������� �� �����
  glFlush();
  SwapBuffers(_hdc);
end;

//--------------------------------------------//
//------     ��������� �����������     -------//
//--------------------------------------------//
procedure ResizeCl;
begin
  glMatrixMode( GL_PROJECTION );
  glLoadIdentity;
  glViewport(0, 0, Width, Height);
  gluPerspective(45.0, Width/Height, 0.1, 1000.0);
  glMatrixMode( GL_MODELVIEW );
  glLoadIdentity;
end;

//--------------------------------------------//
//------     ����������� ������        -------//
//--------------------------------------------//
constructor Create;
begin
  // ����� ��������� �� ����
  _hdc := GetDC(self.Handle.ToInt32());
  // ������� ������
  components := new System.ComponentModel.Container;
  timer := new System.Windows.Forms.Timer(self.components);
  timer.Enabled := true;
  timer.Interval := 1;
  // �������������� OpenGL
  OpenGLInit(self.Handle);
  // ��������� OpenGL
  Init;
  // ����� ������ 1�������� ����. Render
  timer.Tick += Render;
end;
 
// ��������� ��������� ����
protected procedure OnPaint(e: System.Windows.Forms.PaintEventArgs); override;
begin
 //repeat
   Render(self, e);
 //until(false);
end;
 
// ��������� �������� ���� 
procedure Form_Closed(sender : object; e : EventArgs);
begin
  // ����������� OpenGL
  OpenGLUninit(self.Handle);
end;
 
// ��������� ���. ��� ��������� ������� ���� 
procedure Form_Resize(sender: object; e : EventArgs);
begin
  ResizeCl;  
end;

// ��������� ������� ������
procedure  Form_KeyDown(sender: object; e : KeyEventArgs  );
begin
 
 if (e.KeyCode = Keys.S ) then  RotY :=  RotY + 1;
 if (E.KeyCode = Keys.Escape) then self.Close;
 
end;

//-------------------------------------//
end; // end class

 
var f : Form1;
begin
  f := new Form1();
  f.Resize += f.Form_Resize;
  f.Closed += f.Form_Closed;
  f.KeyDown += KeyEventHandler(f.Form_KeyDown);
  
  f.Width  := 800;
  f.Height := 600;
 
  // FullScreen
  if (false) then begin
    f.TopMost := true;
    f.FormBorderStyle := System.Windows.Forms.FormBorderStyle.None;
    f.WindowState := System.Windows.Forms.FormWindowState.Maximized;
  end;  
  
  // ������ ����������
  Application.Run(f);
  
end.

