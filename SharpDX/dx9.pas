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
  
 var
   devic : Device;
   vertices : VertexBuffer;
   vertexDecl : VertexDeclaration;
   f : RenderForm;


  procedure Draw();
  begin  
    devic.Clear(ClearFlags.Target or ClearFlags.ZBuffer, new SharpDX.ColorBGRA(20,52,41,0), 1.0, 0);
    devic.BeginScene();
    
    devic.SetStreamSource(0, vertices, 0, 20);
    devic.VertexDeclaration := vertexDecl;
    devic.DrawPrimitives(PrimitiveType.TriangleList , 0, 1);

    devic.EndScene();
    devic.Present();
  end;
  

// Основная программа
begin
  f := new RenderForm('SlimDX2 - MiniTri Direct3D9 Sample');        
       
  devic  :=  Device.create ( SharpDX.Direct3D9.Direct3D.Create(), 0, DeviceType.Hardware,
                             f.Handle, CreateFlags.HardwareVertexProcessing,
                             new PresentParameters(f.ClientSize.Width,
                                                   f.ClientSize.Height));
                   

  vertices := new VertexBuffer(devic, 3 * sizeof(Vertex), Usage.WriteOnly, VertexFormat.None, Pool.Managed);
      
  var q : array of Vertex; //System.IntPtr;
      q := new Vertex[3];
      q[0] := new Vertex(new Vector4(400.0, 100.0, 0.5, 1.0), SharpDX.Color.Red );
      q[1] := new Vertex(new Vector4(650.0, 500.0, 0.5, 1.0), SharpDX.Color.Blue );
      q[2] := new Vertex(new Vector4(150.0, 500.0, 0.5, 1.0), SharpDX.Color.Green );
       
  var st : SharpDX.DataStream :=    vertices.&Lock(0, 0, SharpDX.Direct3D9.LockFlags.None);    
  // var pp :System.IntPtr := vertices.LockToPointer(0, 0, SharpDX.Direct3D9.LockFlags.None);
  // var st : SharpDX.DataStream := new DataStream(pp, 0, true, true);
      
  st.WriteRange(q);
  vertices.Unlock();
      
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

  RenderLoop.Run (f, Draw);
end.
  
  

        