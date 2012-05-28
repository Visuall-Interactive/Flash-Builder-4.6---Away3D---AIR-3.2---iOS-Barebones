package jonrowe.views
{
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.Scene3DEvent;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import jonrowe.utils.HoverDragController;
	import jonrowe.views.component.WireframeSingleAxisGrid;
	
	/**
	 * Canvas3D is a component to create and display a 3D scene.
	 * By default it contains:
	 * - a grid in the XZ plane
	 * - a cube
	 * - a pointlight
	 * - a directional light
	 * - a camera with a hover controller
	 * @author jonrowe
	 * 
	 */	
	
	public class OriginalCanvas3D extends Canvas3D
	{

		private var camController:HoverDragController;   			//the camera controller
		private var sunLight :DirectionalLight;						//A light
		private var skyLight :PointLight;							//Another light
		private var lightPicker:StaticLightPicker;					//A light picker

		
		/**
		 * wait for addedToStage event before doing anything 
		 * 
		 */		
		public function OriginalCanvas3D()
		{
			super();
		}

		override protected function initView(...args):View3D
		{
			
			var v:View3D = new View3D();
			v.mouseEnabled = true;
			v.backgroundColor = 0x393939;
			v.antiAlias = 2;
			
			//create a light for shadows that mimics the sun's position in the skybox
			sunLight = new DirectionalLight(-1, -0.4, 1);
			sunLight.color = 0xFFFFFF;
			sunLight.castsShadows = true;
			sunLight.ambient = 1;
			sunLight.diffuse = 1;
			sunLight.specular = 1;
			v.scene.addChild(sunLight);
			
			//create a light for ambient effect that mimics the sky
			skyLight = new PointLight();
			skyLight.y = 500;
			skyLight.color = 0xFFFFFF;
			skyLight.diffuse = 1;
			skyLight.specular = 0.5;
			skyLight.radius = 2000;
			skyLight.fallOff = 2500;
			v.scene.addChild(skyLight);
			
			lightPicker = new StaticLightPicker([sunLight, skyLight]);
			
			
			camController = new HoverDragController(v.camera, this);
			camController.radius = 800;
			
			
			//the grid
			var grid :WireframeSingleAxisGrid = new WireframeSingleAxisGrid(10,1000,1.5,WireframeSingleAxisGrid.PLANE_XZ,0x4a4a4a);
			v.scene.addChild(grid);
			
			//a cube
			var cubeGeometry:CubeGeometry = new CubeGeometry(100,100,100);
			var cubeMaterial:ColorMaterial = new ColorMaterial( 0xE65814, 0.8 );
			cubeMaterial.lightPicker = lightPicker;
			var mesh:Mesh = new Mesh(cubeGeometry, cubeMaterial);
			v.scene.addChild( mesh );
			
			return v;
			
		}
		
	}
}