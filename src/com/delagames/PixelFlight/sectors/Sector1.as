package com.delagames.PixelFlight.sectors 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author fakhir
	 */
	public class Sector1 extends Sector 
	{
		
		public function Sector1(X:int, Y:int, state:FlxGroup) 
		{
			_state = state;
			
			[Embed(source = "../../../../../assets/maps/tiles.png")] var TileMapGFX:Class;
			
			[Embed(source = "../../../../../assets/maps/sector1/mapCSV_Sector1_Collisions.csv", mimeType = "application/octet-stream")] var Sector1CollisionData:Class;			
			_collisionLayer = LoadLayer(X, Y, new Sector1CollisionData(), TileMapGFX);
			_state.add(_collisionLayer);
			
			[Embed(source = "../../../../../assets/maps/sector1/mapCSV_Sector1_SpawnPoints.csv", mimeType = "application/octet-stream")] var Sector1SpawnPointsData:Class;
			var spawnPointsLayer:FlxTilemap = LoadLayer(X, Y, new Sector1SpawnPointsData(), TileMapGFX);
			ParseSpawnPoints(spawnPointsLayer);
			_state.add(spawnPointsLayer);
			
			[Embed(source = "../../../../../assets/maps/sector1/mapCSV_Sector1_Visuals.csv", mimeType = "application/octet-stream")] var Sector1VisualData:Class;
			_visualLayer = LoadLayer(X, Y, new Sector1VisualData(), TileMapGFX);
			//_state.add(_visualLayer);
			
			[Embed(source = "../../../../../assets/maps/sector1/mapCSV_Sector1_Collectables.csv", mimeType = "application/octet-stream")] var Sector1CollectableLayerData:Class;
			var collectableLayer:FlxTilemap = LoadLayer(X, Y, new Sector1CollectableLayerData(), TileMapGFX);
			ParseCollectables(collectableLayer);
			collectableLayer = null;
			
			var s:FlxSprite;
			[Embed(source = "../../../../../assets/art/mouse_icon.png")] var MouseIconGFX:Class;
			s = new FlxSprite(120, 80, MouseIconGFX);
			_state.add(s);
			
			var lbl:FlxText = new FlxText(123, 130, 50, "OR");
			lbl.color = 0xffffffff;
			lbl.size = 10;
			_state.add(lbl);
			
			[Embed(source = "../../../../../assets/art/space_icon.png")] var SpaceIconGFX:Class;
			s = new FlxSprite(90, 160, SpaceIconGFX);
			_state.add(s);
			
			lbl = new FlxText(123, 190, 220, "Tip: Press and hold button for constant boost");
			lbl.color = 0xffffffff;
			lbl.size = 13;
			_state.add(lbl);
			
			lbl = new FlxText(0, 350, FlxG.width, "Press 'm' to mute/unmute");
			lbl.size = 14;
			lbl.alignment = "center";
			lbl.color = 0xffffffff;
			_state.add(lbl);
			
			lbl = new FlxText(0, 368, FlxG.width, "Press 'p' to pause/unpause");
			lbl.size = 14;
			lbl.alignment = "center";
			lbl.color = 0xffffffff;
			_state.add(lbl);
		}
		
		override protected function ReloadCollectables():void
		{
			_collectableGroup.kill();
			
			[Embed(source = "../../../../../assets/maps/sector1/mapCSV_Sector1_Collectables.csv", mimeType = "application/octet-stream")] var Sector1CollectableLayerData:Class;
			[Embed(source = "../../../../../assets/maps/tiles.png")] var TileMapGFX:Class;
			var collectableLayer:FlxTilemap = LoadLayer(_collisionLayer.x, _collisionLayer.y, new Sector1CollectableLayerData(), TileMapGFX);
			ParseCollectables(collectableLayer);
			collectableLayer = null;
			
		}
	}

}