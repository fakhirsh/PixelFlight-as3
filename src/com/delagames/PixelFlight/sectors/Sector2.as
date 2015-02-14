package com.delagames.PixelFlight.sectors 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author fakhir
	 */
	public class Sector2 extends Sector 
	{
		
		public function Sector2(X:int, Y:int, state:FlxGroup) 
		{
			_state = state;
			
			[Embed(source = "../../../../../assets/maps/tiles.png")] var TileMapGFX:Class;
			
			[Embed(source = "../../../../../assets/maps/sector2/mapCSV_Sector2_Collisions.csv", mimeType = "application/octet-stream")] var Sector1CollisionData:Class;
			_collisionLayer = LoadLayer(X, Y, new Sector1CollisionData(), TileMapGFX);
			_state.add(_collisionLayer);
			
			[Embed(source = "../../../../../assets/maps/sector2/mapCSV_Sector2_SpawnPoints.csv", mimeType = "application/octet-stream")] var Sector1SpawnPointsData:Class;
			var spawnPointsLayer:FlxTilemap = LoadLayer(X, Y, new Sector1SpawnPointsData(), TileMapGFX);
			ParseSpawnPoints(spawnPointsLayer);
			_state.add(spawnPointsLayer);
			
			[Embed(source = "../../../../../assets/maps/sector2/mapCSV_Sector2_Visuals.csv", mimeType = "application/octet-stream")] var Sector1VisualData:Class;
			_visualLayer = LoadLayer(X, Y, new Sector1VisualData(), TileMapGFX);
			//_state.add(_visualLayer);
			
			[Embed(source = "../../../../../assets/maps/sector2/mapCSV_Sector2_Collectables.csv", mimeType = "application/octet-stream")] var Sector1CollectableLayerData:Class;
			var collectableLayer:FlxTilemap = LoadLayer(X, Y, new Sector1CollectableLayerData(), TileMapGFX);
			ParseCollectables(collectableLayer);
			collectableLayer = null;
			
		}
		
		override protected function ReloadCollectables():void
		{
			_collectableGroup.kill();
			
			[Embed(source = "../../../../../assets/maps/sector2/mapCSV_Sector2_Collectables.csv", mimeType = "application/octet-stream")] var Sector1CollectableLayerData:Class;
			[Embed(source = "../../../../../assets/maps/tiles.png")] var TileMapGFX:Class;
			var collectableLayer:FlxTilemap = LoadLayer(_collisionLayer.x, _collisionLayer.y, new Sector1CollectableLayerData(), TileMapGFX);
			ParseCollectables(collectableLayer);
			collectableLayer = null;
			
		}
	}

}