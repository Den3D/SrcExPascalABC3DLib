{$reference System.Windows.Forms.dll}
{$reference System.Drawing.dll}

 
uses System, System.Drawing, System.Windows.Forms, OpenGL;
 
type Form1 = class (Form)

private
 _hdc : HDC;
 timer: Timer;
 components: System.ComponentModel.IContainer;
 
 // Угол поворота
 RotY : integer;

public

//--------------------------------------------//
//------   Инициализация  приложения   -------//
//--------------------------------------------//
procedure Init;
begin
  // Настройка OpenGL
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LEQUAL);
  glClearDepth(1.0);
  glHint(GL_PERSPECTIVE_CORRECTION_HINT,GL_NICEST);
  
  // Настройка камеры/окна просмотра
  glMatrixMode( GL_PROJECTION );
  glLoadIdentity;
  glViewport(0, 0, Width, Height);
  gluPerspective(45.0, Width/Height, 0.1, 1000.0);
  
  // Установка матрицы мира/объекта
  glMatrixMode( GL_MODELVIEW );
  glLoadIdentity;

  // Инициализация переменных
  RotY := 0;
end;

//--------------------------------------------//
//------     Процедура рисование       -------//
//--------------------------------------------//
procedure Render(sender: Object; e: EventArgs);
begin
  // Заливка фона 
  glClearColor(single(0.0), single(0.0), single(0.0), single(0.0));
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  // Установка наблюдателя/камеры
  glLoadIdentity();
  gluLookAt(0.0,0.0,5.0,  0.0,0.0,0.0,  0.0,1.0,0.0);
 
  glPushMatrix();
  // Устанавливаем позицию и поворок
  glTranslatef(0,0,0);
  glRotatef(RotY, 0.0, 1.0, 0.0);
  // Рисуем объект
  glBegin(GL_TRIANGLES); //рисуем треугольник
  glColor3f(1,0,0);  glVertex3f(0, 1, 0); //первая вершина
  glColor3f(0,1,0);  glVertex3f(1, -1, 0); //вторая вершина
  glColor3f(0,1,0);  glVertex3f(-1,-1, 0); //третья вершина
  glEnd;  
  
  glPopMatrix();
  
  // Увеличиваем угол  поворота
  RotY += 1; 
  
  // Выводим содержимое на форму
  glFlush();
  SwapBuffers(_hdc);
end;

//--------------------------------------------//
//------     Процедура перерисовки     -------//
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
//------     Конструктор класса        -------//
//--------------------------------------------//
constructor Create;
begin
  // Берем указатель на окно
  _hdc := GetDC(self.Handle.ToInt32());
  // Создаем таймер
  components := new System.ComponentModel.Container;
  timer := new System.Windows.Forms.Timer(self.components);
  timer.Enabled := true;
  timer.Interval := 1;
  // Инициализируем OpenGL
  OpenGLInit(self.Handle);
  // Настройка OpenGL
  Init;
  // Вызов каждую 1миллисек проц. Render
  timer.Tick += Render;
end;
 
// Процедура рисования окна
protected procedure OnPaint(e: System.Windows.Forms.PaintEventArgs); override;
begin
 //repeat
   Render(self, e);
 //until(false);
end;
 
// Процедура закрытия окна 
procedure Form_Closed(sender : object; e : EventArgs);
begin
  // Уничтожения OpenGL
  OpenGLUninit(self.Handle);
end;
 
// Процедура выз. при изменения размера окна 
procedure Form_Resize(sender: object; e : EventArgs);
begin
  ResizeCl;  
end;

// Обработка нажатий кнопок
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
  
  // Запуск приложения
  Application.Run(f);
  
end.

