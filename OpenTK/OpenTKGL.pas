{$reference System.Drawing.dll}
{$reference OpenTK.dll}

 
uses System, System.Drawing,
     OpenTK, OpenTK.Graphics.OpenGL;
 
type Form1 = class (GameWindow)
  
  // угол поворота треугольника
  yy : real;

// Конструктор класса
public constructor Create();
begin
  yy := 0;
  GL.ClearColor(Color.CornflowerBlue);
end; 

// Процедура предназначенная для загрузки ресурсов
// и первичной настойки OpenGL
protected procedure OnLoad(e: EventArgs); override;
begin
  Title := 'Hello OpenTK!';
  GL.ClearColor(Color.CornflowerBlue);
end;       

// Процедура перерисовки. 
// Настраивает камеру зрителя и рисует треугольник  
protected procedure OnRenderFrame(e: FrameEventArgs); override;
begin
  GL.Clear(ClearBufferMask.ColorBufferBit or ClearBufferMask.DepthBufferBit);
  var modelview:Matrix4 := Matrix4.LookAt(Vector3.Zero, Vector3.UnitZ, Vector3.UnitY);
  Matrix4.CreateTranslation(0,0,-10,modelview);
  GL.MatrixMode(MatrixMode.Modelview);
  GL.LoadMatrix(&modelview);
  gl.Rotate(yy, new Vector3(0,1,0));
  gl.Translate(0.0,0.0,0.0);
 
  GL.&Begin(BeginMode.Triangles);
    GL.Color3(1.0, 0.0, 0.0); 
    GL.Vertex3(-1.0, -1.0, 4.0);
    GL.Color3(0.0, 1.0, 0.0);
    GL.Vertex3(1.0, -1.0, 4.0);
    GL.Color3(0.0, 0.0, 1.0);
    GL.Vertex3(0.0, 1.0, 4.0);
  GL.&End();
  
  yy := yy + 2;
     
  SwapBuffers();
end;

// Процедура выполняющая при изменения размера формы.
protected procedure OnResize(e: EventArgs); override;
begin
  GL.Viewport(ClientRectangle.X, ClientRectangle.Y, ClientRectangle.Width, ClientRectangle.Height);
  var projection:Matrix4 := Matrix4.CreatePerspectiveFieldOfView(Math.PI / 4, Width / Height, 1.0, 64.0);
  GL.MatrixMode(MatrixMode.Projection);
  GL.LoadMatrix(&projection);
end;

//-------------------------------------//
end; // end class

 
var f : Form1;
begin
  f := new Form1();

  // Запуск приложения  
  f.run(30.0);
  
end.