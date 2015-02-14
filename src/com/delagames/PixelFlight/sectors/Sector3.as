package com.delagames.PixelFlight.sectors 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author fakhir
	 */
	public class Sector3 extends Sector 
	{
		
		public function Sector3(X:int, Y:int, state:FlxGroup) 
		{
			_state = state;
			
			[Embed(source = "../../../../../assets/maps/tiles.png")] var TileMapGFX:Class;
			
			[Embed(source = "../../../../../assets/maps/sector3/mapCSV_Sector3_Collision.csv", mimeType = "application/octet-stream")] var Sector3CollisionData:Class;
			_collisionLayer = LoadLayer(X, Y, new Sector3CollisionData(), TileMapGFX);
			_state.add(_collisionLayer);
			
			[Embed(source = "../../../../../assets/maps/sector3/mapCSV_Sector3_SpawnPoints.csv", mimeType = "application/octet-stream")] var Sector3SpawnPointsData:Class;
			var spawnPointsLayer:FlxTilemap = LoadLayer(X, Y, new Sector3SpawnPointsData(), TileMapGFX);
			ParseSpawnPoints(spawnPointsLayer);
			_state.add(spawnPointsLayer);
			
			[Embed(source = "../../../../../assets/maps/sector3/mapCSV_Sector3_Visuals.csv", mimeType = "application/octet-stream")] var Sector3VisualData:Class;
			_visualLayer = LoadLayer(X, Y, new Sector3VisualData(), TileMapGFX);
			//_state.add(_visualLayer);
			
			[Embed(source = "../../../../../assets/maps/sector3/mapCSV_Sector3_Collectables.csv", mimeType = "application/octet-stream")] var Sector3CollectableLayerData:Class;
			var collectableLayer:FlxTilemap = LoadLayer(X, Y, new Sector3CollectableLayerData(), TileMapGFX);
			ParseCollectables(collectableLayer);
			collectableLayer = null;
		}
		
		override protected function ReloadCollectables():void
		{
			_collectableGroup.kill();
			
			[Embed(source = "../../../../../assets/maps/sector3/mapCSV_Sector3_Collectables.csv", mimeType = "application/octet-stream")] var Sector3CollectableLayerData:Class;
			[Embed(source = "../../../../../assets/maps/tiles.png")] var TileMapGFX:Class;
			var collectableLayer:FlxTilemap = LoadLayer(_collisionLayer.x, _collisionLayer.y, new Sector3CollectableLayerData(), TileMapGFX);
			ParseCollectables(collectableLayer);
			collectableLayer = null;
			
		}
		
	}

}