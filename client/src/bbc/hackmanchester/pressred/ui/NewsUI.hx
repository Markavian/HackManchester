package bbc.hackmanchester.pressred.ui;

import bbc.hackmanchester.pressred.model.NewsModel;
import bbc.hackmanchester.pressred.model.TimetableModel;
import flash.display.DisplayObject;

/**
 * Represents a news stream
 * @author John Beech
 */
class NewsUI extends BaseUI
{
	var model:NewsModel;
	
	var rows:Array<NewsRowUI>;

	public function new() 
	{
		super();
		
		rows = new Array<NewsRowUI>();
	}
	
	public function setup(model:NewsModel)
	{
		this.model = model;
		
		model.updated.add(onModelUpdated);
		
		redraw();
	}
	
	function onModelUpdated(model)
	{
		redraw();
	}
	
	function redraw()
	{
		for (row in rows)
		{
			artwork.removeChild(row.artwork);
		}
		
		var lastRow:BaseUI = null;
		for (newsItemModel in model.newsItems)
		{
			var row = new NewsRowUI();
			row.setup(newsItemModel);
			
			addUI(row);
			
			if (lastRow != null)
			{
				alignBottom(row.artwork, lastRow.artwork);
			}
			lastRow = row;
		}
	}
	
}