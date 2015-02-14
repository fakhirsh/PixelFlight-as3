package com.delagames.PixelFlight.sectors 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author fakhir
	 */
	public class Sector4 extends Sector 
	{
		
		public function Sector4(X:int, Y:int, state:FlxGroup) 
		{
			_state = state;
			
			[Embed(source = "../../../../../assets/maps/tiles.png")] var TileMapGFX:Class;
			
			[Embed(source="../../../../../assets/maps/sector4/mapCSV_Sector4_Collision.csv", mimeType="application/octet-stream")] var SectorCollisionData:Class;
			_collisionLayer = LoadLayer(X, Y, new SectorCollisionData(), TileMapGFX);
			_state.add(_collisionLayer);
			
			[Embed(source="../../../../../assets/maps/sector4/mapCSV_Sector4_SpawnPoints.csv", mimeType="application/octet-stream")] var SectorSpawnPointsData:Class;
			var spawnPointsLayer:FlxTilemap = LoadLayer(X, Y, new SectorSpawnPointsData(), TileMapGFX);
			ParseSpawnPoints(spawnPointsLayer);
			_state.add(spawnPointsLayer);
			
			[Embed(source = "../../../../../assets/maps/sector3/mapCSV_Sector3_Visuals.csv", mimeType = "application/octet-stream")] var SectorVisualData:Class;
			_visualLayer = LoadLayer(X, Y, new SectorVisualData(), TileMapGFX);
			//_state.add(_visualLayer);
			
			[Embed(source="../../../../../assets/maps/sector4/mapCSV_Sector4_Collectables.csv", mimeType="application/octet-stream")] var SectorCollectableLayerData:Class;
			var collectableLayer:FlxTilemap = LoadLayer(X, Y, new SectorCollectableLayerData(), TileMapGFX);
			ParseCollectables(collectableLayer);
			collectableLayer = null;
		}
		
		override protected function ReloadCollectables():void
		{
			_collectableGroup.kill();
			
			[Embed(source="../../../../../assets/maps/sector4/mapCSV_Sector4_Collectables.csv", mimeType="application/octet-stream")] var SectorCollectableLayerData:Class;
			[Embed(source = "../../../../../assets/maps/tiles.png")] var TileMapGFX:Class;
			var collectableLayer:FlxTilemap = LoadLayer(_collisionLayer.x, _collisionLayer.y, new SectorCollectableLayerData(), TileMapGFX);
			ParseCollectables(collectableLayer);
			collectableLayer = null;
			
		}
		
	}

}