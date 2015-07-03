﻿package {
	import starling.events.KeyboardEvent;	import starling.events.Event;	import starling.display.MovieClip;
		import flash.utils.Timer;	import flash.events.TimerEvent;
	import flash.ui.Keyboard;	import flash.events.MouseEvent;	import com.coreyoneil.collision.CollisionList;	import starling.text.TextField;	import flash.net.SharedObject;	import flash.text.TextFormat;		import flash.display.BlendMode;	import flash.net.FileReference;	import flash.net.FileFilter;	import flash.utils.ByteArray;	import flash.errors.EOFError;	import starling.display.Sprite;
	public class SurvivalGame extends starling.display.Sprite	{		public var hero				:Hero;		public var downKeyPressed	:Boolean = false;		public var upKeyPressed		:Boolean = false;		public var leftKeyPressed	:Boolean = false;		public var rightKeyPressed	:Boolean = false;		public var rKeyPressed		:Boolean = false;		public var replaying		:Boolean = false;		public var sKeyPressed 		:Boolean = false;		public var pp				:Boolean = false;		public var timer			:Timer;		public var army				:Array;		public var acc				:Number = 1.01;		public var collisionList	:CollisionList;		public var collisions		:Array;		public var diff				:int = 10;		public var rand				:int;				public var score			:Score;		public var hScore			:HScore;		public var highscore		:SharedObject;		public var replay			:Array;		public var tempReplay		:Array;		public var tempScore		:int;		public var replayLoad		:FileReference;		public var ba				:ByteArray;		public function SurvivalGame()		{			//initializes the game and variables.			ba = new ByteArray;			replayLoad = new FileReference;			//grabs the local highscore			highscore = SharedObject.getLocal("highscores");			//if no local highscore exists, display 0.			if(highscore.data.score == null)			{				highscore.data.score = 0;				highscore.data.replay = null;			}						score = new Score();			hScore = new HScore();			addChild(hScore);			addChild(score);			replay = new Array();			timer = new Timer(25);			timer.start();			timer.addEventListener(TimerEvent.TIMER, onTick);			addEventListener(Event.ADDED_TO_STAGE, onAdd);						//add hero			hero = new Hero();			addChild(hero);						army = new Array();			collisionList = new CollisionList(hero);		}		private function onTick(e:TimerEvent)		{			//if a replay isn't playing, calculate a new random number every tick, otwise, random is 101.			if(replaying == false)			{				rand = Math.random() * 100;			}			else			{				rand = 101;			}			//Makes a new replay objects, which holds the players x and y values			var repObject = new Object(); 			repObject.xVal = hero.x;			repObject.yVal = hero.y;			score.text = (timer.currentCount).toString();			hScore.text = highscore.data.score;			//Every 100 points, add 1 to diff. This will give a higher chance of enemies spawning every 100 points.			if(timer.currentCount % 100 == 0)			{				diff++;			}			//check for collisions			collisions = collisionList.checkCollisions();			//if the random number is less than the diff, spawn a new zombie, add the zombie to the collision list, and add the zombie's starting x/y coordinates to the replay object.			if (rand < diff)			{				var newZombie = new Zombie();				army.push(newZombie);				addChild(newZombie);				collisionList.addItem(newZombie);				repObject.zXVal = newZombie.posX;				repObject.zYVal = newZombie.posY;			}			//add the replay object to the array "replay", which holds your best replay.			replay.push(repObject);			//remove zombies when amount on the screen is greated than the difficulty + 5			if(army.length == 10 + diff)			{				removeChild(army[0]);				collisionList.removeItem(army[0]);				army[0] = null;				army.splice(0,1);			}			//sends the hero's x and y coords to the zombie so he can chase him			for each (var zombie:Zombie in army)			{				zombie.chase(hero.x, hero.y);			}			//if there's any collisions with the hero, react accordingly.			if (collisions.length > 0)			{				onHit();			}			//controls			if (downKeyPressed)			{				hero.moveABit(0,acc);			}			else			{				hero.still();			}			if (upKeyPressed)			{				hero.moveABit(0,-acc);			}			else			{				hero.still();			}			if (rightKeyPressed)			{				hero.moveABit(acc,0);			}			else			{				hero.still();			}			if (leftKeyPressed)			{				hero.moveABit(-acc,0);			}			else			{				hero.still();			}			if((leftKeyPressed && upKeyPressed) || (leftKeyPressed && downKeyPressed) || (rightKeyPressed && upKeyPressed) || (rightKeyPressed && downKeyPressed))			{				acc = Math.sqrt(Math.pow(1.01,2)/2);			}			else			{				acc = 1.01;			}			//Start the replay of the highscore when "r" is pressed.			if(rKeyPressed)			{				trace("replay");				if(highscore.data.score > 0)				{					trace(highscore.data.replay);					onHit();					tempReplay = highscore.data.replay;					tempScore = highscore.data.score;					replaying = true;					hero.physics.reset();				}							}			//if playing a replay, play the replay.			if(replaying == true)			{				replayPlay();			}		}				//handles playing the replay.		private function replayPlay()		{			//grab the hero's coords out of the replay			hero.x = highscore.data.replay[timer.currentCount].xVal;			hero.y = highscore.data.replay[timer.currentCount].yVal;			//if the a zombie is added to the game in the replay, add a zombie to the current screen.			if(highscore.data.replay[timer.currentCount].zXVal != undefined)			{				var zombie = new Zombie();				zombie.x = highscore.data.replay[timer.currentCount].zXVal;				zombie.y = highscore.data.replay[timer.currentCount].zYVal;				addChild(zombie);				collisionList.addItem(zombie);				army.push(zombie);			}		}		private function open(e:Event)		{			//When opening a replay manually, stop the timer.			timer.stop();		}		private function onHit()		{			//Stop the timer, reset the diff.			timer.stop();			diff = 10;			//If the hero was while playing and the current score is higher than the highscore, replace the local highscore.			if(replaying == false)			{				if(timer.currentCount > highscore.data.score)				{					highscore.data.score = timer.currentCount;					highscore.data.replay = replay;						highscore.flush();				}			}			//Otherwise, turn off the replay and reset the score and replay				else			{				replaying = false;				highscore.data.replay = tempReplay;				highscore.data.score = tempScore;			}			//remove all the zombies from the array			for each (var zombie:Zombie in army)			{				removeChild(zombie);				zombie = null;			}			for(var i = army.length; i >= 0; i--)			{				army.splice(i,1);			}			//remove all collisions from the collision array			for(var i = collisions.length; i >= 0; i--)			{				collisions.splice(i,1);			}			//Begin recording a new replay, start a new collision list, and reset hero			replay = new Array();			collisionList = new CollisionList(hero);			collisions = collisionList.checkCollisions();			hero.x = 250;			hero.y = 250;			army = new Array();			timer.reset();			timer.start();		}		private function onAdd(e:Event)		{			//add keyboard listeners after the game starts			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);		}		private function onKeyPressed(e:KeyboardEvent)		{			//handles key presses			switch (e.keyCode)			{				case Keyboard.UP :					upKeyPressed = true;					break;				case Keyboard.DOWN :					downKeyPressed = true;					break;				case Keyboard.LEFT :					leftKeyPressed = true;					break;				case Keyboard.RIGHT :					rightKeyPressed = true;					break;				case 82:					rKeyPressed = true;					trace("r hit");					break;				case 16:					if(pp == false)					{						timer.stop();						pp = true;					}					else					{						timer.start();						pp = false;					}					break;				case 83:					if(replaying == false)					{						var save = new FileReference;						timer.stop();						save.addEventListener(Event.CANCEL, cancel);						save.addEventListener(Event.COMPLETE, sDone);												ba.writeObject(highscore.data.replay); //Saves replay						ba.writeDouble(highscore.data.score); //saves score						ba.compress();												save.save(ba, "Replay - "+highscore.data.score.toString()+".hsr");					} 					break;				case 76:					if(replaying == false)					{						replayLoad.browse();						replayLoad.addEventListener(Event.SELECT, fileSelect);						timer.stop();					}			}		}		private function sDone(e:Event)		{			//start the game again once saving of replay is complete.			timer.start();		}		private function fileSelect(e:Event)		{			//select a replay to load			replayLoad.load();		}			private function cancel(e:Event)		{			//Start the timer if cancelled			timer.start();		}		private function onKeyRelease(e:KeyboardEvent)		{			//handle key releases			switch (e.keyCode)			{				case Keyboard.UP :					upKeyPressed = false;					break;				case 16:					upKeyPressed = false;					break;				case Keyboard.DOWN :					downKeyPressed = false;					break;				case Keyboard.LEFT :					leftKeyPressed = false;					break;				case Keyboard.RIGHT :					rightKeyPressed = false;					break;				case 82:					rKeyPressed = false;					break;			}		}	}}