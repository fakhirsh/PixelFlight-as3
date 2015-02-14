package com.delagames.PixelFlight.sectors 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author fakhir
	 */
	public class Sector6 extends Sector 
	{
		
		public function Sector6(X:int, Y:int, state:FlxGroup) 
		{
			_state = state;
			
			[Embed(source = "../../../../../assets/maps/tiles.png")] var TileMapGFX:Class;
			
			[Embed(source = "../../../../../assets/maps/sector6/mapCSV_Sector6_Collisions.csv", mimeType = "application/octet-stream")] var SectorCollisionData:Class;
			_collisionLayer = LoadLayer(X, Y, new SectorCollisionData(), TileMapGFX);
			_state.add(_collisionLayer);
			
			[Embed(source = "../../../../../assets/maps/sector6/mapCSV_Sector6_SpawnPoints.csv", mimeType = "application/octet-stream")] var SectorSpawnPointsData:Class;
			var spawnPointsLayer:FlxTilemap = LoadLayer(X, Y, new SectorSpawnPointsData(), TileMapGFX);
			ParseSpawnPoints(spawnPointsLayer);
			_state.add(spawnPointsLayer);
			
			[Embed(source = "../../../../../assets/maps/sector6/mapCSV_Sector6_Visuals.csv", mimeType = "application/octet-stream")] var SectorVisualData:Class;
			_visualLayer = LoadLayer(X, Y, new SectorVisualData(), TileMapGFX);
			//_state.add(_visualLayer);
			
			[Embed(source = "../../../../../assets/maps/sector6/mapCSV_Sector6_Collectables.csv", mimeType = "application/octet-stream")] var SectorCollectableLayerData:Class;
			var collectableLayer:FlxTilemap = LoadLayer(X, Y, new SectorCollectableLayerData(), TileMapGFX);
			ParseCollectables(collectableLayer);
			collectableLayer = null;
		}
		
		override protected function ReloadCollectables():void
		{
			_collectableGroup.kill();
			
			[Embed(source = "../../../../../assets/maps/sector6/mapCSV_Sector6_Collectables.csv", mimeType = "application/octet-stream")] var SectorCollectableLayerData:Class;
			[Embed(source = "../../../../../assets/maps/tiles.png")] var TileMapGFX:Class;
			var collectableLayer:FlxTilemap = LoadLayer(_collisionLayer.x, _collisionLayer.y, new SectorCollectableLayerData(), TileMapGFX);
			ParseCollectables(collectableLayer);
			collectableLayer = null;
			
		}
		
	}

}