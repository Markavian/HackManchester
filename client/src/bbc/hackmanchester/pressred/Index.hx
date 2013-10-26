package bbc.hackmanchester.pressred;

import bbc.hackmanchester.pressred.controller.ScreenController;
import bbc.hackmanchester.pressred.controller.DataController;
import bbc.hackmanchester.pressred.screen.Screen;
import bbc.hackmanchester.pressred.screen.SplashScreen;
import bbc.hackmanchester.pressred.screen.ScreenWithTitle;
import bbc.hackmanchester.pressred.model.GlobalTree;
import bbc.hackmanchester.pressred.singleton.EventBus;
import bbc.hackmanchester.pressred.ui.TabUI;

import flash.display.Sprite;
import flash.events.Event;

/**
 * Index for main app.
 * @author John Beech
 */
class Index
{
	public var artwork:Sprite;
	public var screens:Sprite;
	
	public var tree:GlobalTree;
	public var screenController:ScreenController;
	public var dataController:DataController;
	
	public var tabs:TabUI;
	public var splashScreen:SplashScreen;
	public var streamScreen:ScreenWithTitle;
	public var personScreen:ScreenWithTitle;
	public var starScreen:ScreenWithTitle;
	public var awardScreen:ScreenWithTitle;
	public var timetableScreen:ScreenWithTitle;
	public var biogScreen:ScreenWithTitle;

	public function new() 
	{
		artwork = new Sprite();
		screens = new Sprite();
	}
	
	public function setup()
	{
		tree = new GlobalTree();
		
		tabs = new TabUI();
		tabs.setup();
		artwork.addChild(tabs.artwork);
		
		screenController = new ScreenController();
		screenController.setup(screens);
		
		dataController = new DataController();
		dataController.setup(tree);
		
		// top level tab screens
		splashScreen = cast addScreen(new SplashScreen());
		splashScreen.setup(tree.hackTimer);
		
		streamScreen = cast addScreen(new ScreenWithTitle());
		streamScreen.setup("Streams", "img/stream-icon.png");
		
		personScreen = cast addScreen(new ScreenWithTitle());
		personScreen.setup("Personal Info", "img/person-icon.png");
		
		starScreen = cast addScreen(new ScreenWithTitle());
		starScreen.setup("Starred Items", "img/star-icon.png");
		
		awardScreen = cast addScreen(new ScreenWithTitle());
		awardScreen.setup("League Table", "img/awards-icon.png");
		
		// second level screens
		timetableScreen = cast addScreen(new ScreenWithTitle());
		timetableScreen.setup("Timetable", "img/time-table-icon.png");
		
		biogScreen = cast addScreen(new ScreenWithTitle());
		biogScreen.setup("Who's Who?", "img/biog-icon.png");
		
		registerEvents();
		
		artwork.addChild(screens);
	}
	
	function addScreen(screen:Screen):Screen
	{
		screenController.addScreen(screen);
		return screen;
	}
	
	function registerEvents()
	{
		artwork.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		EventBus.showSplashScreen.add(onShowSplashScreen);
		EventBus.showStreamScreen.add(onShowStreamScreen);
		EventBus.showPersonScreen.add(onShowPersonScreen);
		EventBus.showStarScreen.add(onShowStarScreen);
		EventBus.showAwardsScreen.add(onShowAwardScreen);
		EventBus.showTimetableScreen.add(onShowTimetableScreen);
		EventBus.showBiogScreen.add(onShowBiogScreen);
	}
	
	function onShowSplashScreen(model)
	{
		screenController.showScreen(splashScreen);
	}
	
	function onShowStreamScreen(model)
	{
		screenController.showScreen(streamScreen);
	}
	
	function onShowPersonScreen(model)
	{
		screenController.showScreen(personScreen);
	}
	
	function onShowStarScreen(model)
	{
		screenController.showScreen(starScreen);
	}
	
	function onShowAwardScreen(model)
	{
		screenController.showScreen(awardScreen);
	}
	
	function onShowTimetableScreen(model)
	{
		screenController.showScreen(timetableScreen);
	}
	
	function onShowBiogScreen(model)
	{
		screenController.showScreen(biogScreen);
	}
	
	public function resize()
	{
		var newScale = artwork.stage.stageWidth / Screen.WIDTH;
		if (artwork.scaleX != newScale)
		{
			artwork.scaleX = artwork.scaleY = newScale;
		}
	}
	
	function onEnterFrame(e)
	{
		resize();
	}
	
}