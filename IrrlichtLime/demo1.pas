 {$reference IrrlichtLime.dll}
 
 uses
  System, System.Collections.Generic, System.Linq, System.Text,
  IrrlichtLime, IrrlichtLime.Core, IrrlichtLime.Video,
  IrrlichtLime.Scene, IrrlichtLime.GUI;
  
  var
  device: IrrlichtDevice;
  driver: VideoDriver; 
  smgr: SceneManager; 
  gui: GUIEnvironment;
  node: AnimatedMeshSceneNode;
  mesh: AnimatedMesh;
  
  begin
   var d :=  new Dimension2Di(640, 480);
   device := IrrlichtDevice.CreateDevice(
              DriverType.OpenGL, d, 32, 
              false, false, false);
   
   device.SetWindowCaption('Hello World! - Irrlicht Engine Demo');  
   
  driver  := device.VideoDriver;
  smgr  := device.SceneManager;
  gui  := device.GUIEnvironment;
  
  gui.AddStaticText('Hello World! TheMrDen3D',
 				new Recti(10, 10, 260, 22), true);
 
   mesh  := smgr.GetMesh('media/sydney.md2');
   node  := smgr.AddAnimatedMeshSceneNode(mesh);
   
  if not(node = nil) then
  begin
    node.SetMaterialFlag(MaterialFlag.Lighting, false);
    node.SetMD2Animation(AnimationTypeMD2.Stand);
    node.SetMaterialTexture(0, driver.GetTexture('media/sydney.bmp'));
  end;
  
  smgr.AddCameraSceneNode(nil, new Vector3Df(0, 30, -40), new Vector3Df(0, 5, 0));
  
  while(device.Run() ) do 
  begin
    driver.BeginScene(ClearBufferFlag.All, new Color(255, 255, 140));
    smgr.DrawAll();
    gui.DrawAll();
    driver.EndScene();
  end;
  device.Drop();
  
  end.