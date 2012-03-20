package views
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
	
	import utils.HoverDragController;
	
	import views.component.WireframeSingleAxisGrid;
	
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
	
	public class Canvas3D extends Sprite
	{
		/*		PUBLIC PROPERTIES		*/
		
		public static const SCENE_READY :String = 'scene_ready';
		
		/*		PRIVATE PROPERTIES		*/
		
		private var _view3D:View3D;									//the View3D instance
		private var camController:HoverDragController;   			//the camera controller
		private var sunLight :DirectionalLight;						//A light
		private var skyLight :PointLight;							//Another light
		private var lightPicker:StaticLightPicker;					//A light picker
		
		
		/*		CONSTRUCT		*/
		
		/**
		 * wait for addedToStage event before doing anything 
		 * 
		 */		
		public function Canvas3D()
		{
			super();
			this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		
		/*		GETTER/SETTERS		*/
		
		/**
		 * returns the View3D instance 
		 * @return 
		 * 
		 */		
		public function get view3D():View3D{
			return _view3D;
		}
		
		
		
		
		/*		PUBLIC		*/
		
		
		/**
		 * resize the view3D
		 * @param w
		 * @param h
		 * 
		 */		
		public function setSize(w:int, h:int):void{
			
			if (!_view3D) return;
			
			_view3D.width = w;
			_view3D.height = h;
			
		}
		
		/**
		 *start listening for enterframe events 
		 * 
		 */		
		public function start():void{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//need to call render here otherwise enterFrame events don't happen?!
			_view3D.render();
		}
		
		/**
		 * stop listening for enterframe events 
		 * 
		 */		
		public function stop():void{
			if ( hasEventListener( Event.ENTER_FRAME ))
				removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		
		/*		PRIVATE		*/
		
		/**
		 * initialise the view
		 * 
		 */		
		private function initView():void
		{
			
			if(!this._view3D)
			{
				_view3D = new View3D(); 
				_view3D.mouseEnabled = true;
				_view3D.backgroundColor = 0x393939; 
				_view3D.antiAlias = 2; 
			}
			this.addChild(_view3D); 
			
		}
		
		
		/**
		 * initialise the scene with a grid, cube
		 * draw stats
		 * 
		 */		
		private function initScene():void{
			
			//the grid
			var grid :WireframeSingleAxisGrid = new WireframeSingleAxisGrid(10,1000,1.5,WireframeSingleAxisGrid.PLANE_XZ,0x4a4a4a);
			_view3D.scene.addChild(grid);
			
			//a cube
			var cubeGeometry:CubeGeometry = new CubeGeometry(100,100,100);
			var cubeMaterial:ColorMaterial = new ColorMaterial( 0xE65814, 0.8 );
			cubeMaterial.lightPicker = lightPicker;
			var mesh:Mesh = new Mesh(cubeGeometry, cubeMaterial);
			_view3D.scene.addChild( mesh );
			
			//the stats
			var stats :AwayStats = new AwayStats(_view3D);
			addChild(stats);
			
		}
		
		/**
		 * initialise the hover drag controller for camera 
		 * 
		 */		
		private function initCamController():void{
			camController = new HoverDragController(_view3D.camera, this);
			camController.radius = 800;
		}
		
		/**
		 * set up listeners
		 * 
		 */		
		private function initListeners():void{
			_view3D.scene.addEventListener( Scene3DEvent.ADDED_TO_SCENE, onAddedToScene );
			_view3D.scene.addEventListener( Scene3DEvent.REMOVED_FROM_SCENE, onRemovedFromScene );
			
			
		}
		
		/**
		 * Initialise the lights
		 */
		private function initLights():void
		{
			//create a light for shadows that mimics the sun's position in the skybox
			sunLight = new DirectionalLight(-1, -0.4, 1);
			sunLight.color = 0xFFFFFF;
			sunLight.castsShadows = true;
			sunLight.ambient = 1;
			sunLight.diffuse = 1;
			sunLight.specular = 1;
			_view3D.scene.addChild(sunLight);
			
			//create a light for ambient effect that mimics the sky
			skyLight = new PointLight();
			skyLight.y = 500;
			skyLight.color = 0xFFFFFF;
			skyLight.diffuse = 1;
			skyLight.specular = 0.5;
			skyLight.radius = 2000;
			skyLight.fallOff = 2500;
			_view3D.scene.addChild(skyLight);
			
			lightPicker = new StaticLightPicker([sunLight, skyLight]);
		}
		
		
		/*		EVENT		*/
		
		
		/**
		 * called when this canvas3D instance has been added to stage 
		 * @param e
		 * 
		 */		
		private function onAddedToStage( e:Event ):void{
			
			initView();
			initLights();
			initCamController();
			initListeners();
			initScene();
			
			start();
			
			dispatchEvent( new Event(SCENE_READY));
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		
		/**
		 * render loop called every frame 
		 * @param ev
		 * 
		 */		
		private function onEnterFrame(e : Event) : void {
			_view3D.render();
		} 
		
		
		/**
		 * called when an Object3D is added to the scene
		 */		
		private function onAddedToScene( e:Scene3DEvent ):void{
			
		}
		
		/**
		 * called when an Object3D is removed to the scene
		 * @param e
		 * 
		 */		
		private function onRemovedFromScene( e:Scene3DEvent ):void{
			
		}
		
		
		

	}
}