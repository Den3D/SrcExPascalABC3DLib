 {$reference SharpDX.Desktop.dll}
 {$reference SharpDX.Direct3D9.dll}
 {$reference SharpDX.DXGI.dll}
 {$reference SharpDX.dll}
 {$reference SharpDX.Mathematics.dll}
   
 {$reference System.Windows.Forms.dll}
 {$reference System.Drawing.dll}
 {$apptype windows}
   
  uses
  System, System.Collections.Generic, System.Linq, System.Text,System.Windows.Forms,
  System.Threading.Tasks,System.Drawing, 
  SharpDX, SharpDX.Direct3D9,SharpDX.Direct3D, SharpDX.Windows;
  
  
  
 //Описание формата вершин
 type 
   Vertex = record
   Position : Vector4 ;
   Color :  SharpDX.ColorBGRA ;
   
   constructor Create(Position : Vector4 ;  Color :  SharpDX.ColorBGRA);
    begin
      Self.Position := Position;
      Self.Color := Color;
    end;
 end;


// Описание окна приложкния  
type Form1 = class (RenderForm) 
  
  // описание таймера
  timer: Timer;
  components: System.ComponentModel.IContainer;
  
  // переменные D3D9
  devic : Device;
  vertices : VertexBuffer;
  vertexDecl : VertexDeclaration;
 
  // Процедура отрисовки 
  procedure Draw(sender: Object; e: EventArgs);
  begin
    devic.Clear(ClearFlags.Target or ClearFlags.ZBuffer, new SharpDX.ColorBGRA(20,52,41,0), 1.0, 0);
    devic.BeginScene(); // начало
    
      devic.SetStreamSource(0, vertices, 0, 20);
      devic.VertexDeclaration := vertexDecl;
      devic.DrawPrimitives(PrimitiveType.TriangleList , 0, 1);

    devic.EndScene();  // конец
    devic.Present();
  end;
  
  // Конструктор формы 
  constructor Create(); 
  begin 
    // Вызов конструктора родительского класса   
    inherited Create('SlimDX - MiniTri Direct3D9 Sample');
     
    // создаем таймер 
    components := new System.ComponentModel.Container;
    timer := new System.Windows.Forms.Timer(self.components);
    
    SuspendLayout();
    
    // Задаем работу таймера на
    // выполнение проц. Draw каждую секунду 
    timer.Enabled := true;
    timer.Interval := 1;
    timer.Tick += Draw;
    
    // настройка D3D9
    devic  :=  Device.Create (SharpDX.Direct3D9.Direct3D.Create, 0, DeviceType.Hardware, 
                              self.Handle, CreateFlags.HardwareVertexProcessing,
                              new PresentParameters(self.ClientSize.Width,
                                                    self.ClientSize.Height));
    // Создание буфера вершин               
    vertices := new VertexBuffer(devic, 3 * sizeof(Vertex), Usage.WriteOnly, VertexFormat.None, Pool.Managed);
      
    var q : array of Vertex; //System.IntPtr;
    // Заполнение вершин в массив
    q := new Vertex[3];
    q[0] := new Vertex(new Vector4(400.0, 100.0, 0.5, 1.0), Color.Red );
    q[1] := new Vertex(new Vector4(650.0, 500.0, 0.5, 1.0), Color.Blue );
    q[2] := new Vertex(new Vector4(150.0, 500.0, 0.5, 1.0), Color.Green );
    
    // Блокирования буфера вершин для записи массива
    var st : SharpDX.DataStream :=    vertices.&Lock(0, 0, SharpDX.Direct3D9.LockFlags.None);
      
       // var pp :System.IntPtr := vertices.LockToPointer(0, 0, SharpDX.Direct3D9.LockFlags.None);   
       // var st : SharpDX.DataStream := new DataStream(pp, 0, true, true);
      
    st.WriteRange(q);
    vertices.Unlock(); // заблок. после записи
    
    // Обисания вершин для видеоадаптера
    var vertexElems : array of VertexElement;
    vertexElems := new VertexElement[3];
   
    vertexElems[0] := new VertexElement(0, 0, DeclarationType.Float4, 
                                              DeclarationMethod.Default, 
                                              DeclarationUsage.PositionTransformed,
                                              0);
                                             
    vertexElems[1] := new VertexElement(0, 16, DeclarationType.Color, 
                                               DeclarationMethod.Default, 
                                               DeclarationUsage.Color,
                                               0);
                                              
    vertexElems[2] := VertexElement.VertexDeclarationEnd;
   
    vertexDecl := new VertexDeclaration(devic, vertexElems);  
  end;
    
  // Процедура рисования на форме
  protected procedure OnPaint(e: System.Windows.Forms.PaintEventArgs); override;
  begin
  // repeat
  Draw(self, e);
  // until(1 = 2);
  end;
//----------------------------------//
end; // -- End class


// Основная программа
var f : Form1;
begin
  f := new Form1(); 
  Application.Run(f);
end.
