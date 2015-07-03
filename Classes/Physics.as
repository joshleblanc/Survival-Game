﻿package  {	import starling.events.Event;	import starling.display.MovieClip;	public class Physics extends MovieClip	{		public var par;		public var xVel:Number = 0;		public var yVel:Number = 0;		public var xAcc:Number = 0;		public var yAcc:Number = 0;		public var xSpeed:Number = 0;		public var ySpeed:Number = 0;				public var friction:Number = .92;				public var screenWidth = 500;		public var screenHeight = 500;				public const zac = .5;				public function Physics() 		{			//listens for physics to be added to something			addEventListener(Event.ADDED_TO_STAGE, onAdd);					}		private function onAdd(e:Event):void		{			par = parent;		}		public function zombieMovement(xVal:Number, yVal:Number)		{			//follow the player, if hero's above; move up etc.			if(xVal > par.x)			{				xAcc = zac;			}			if(xVal < par.x)			{				xAcc = -zac;			}			if(yVal > par.y)			{				yAcc = zac;			}			if(yVal < par.y)			{				yAcc = -zac;			}			//Trying to account for the speed up when moving diagonally... 			if(xAcc > 0 && yAcc > 0)			{				var pyt = Math.pow(xAcc, 2) + Math.pow(yAcc, 2);				xAcc = Math.sqrt(pyt) /2;				yAcc = Math.sqrt(pyt) / 2;			}			//calculations to try and make movement "slippery"			xSpeed += xAcc;			ySpeed += yAcc;			xSpeed *= friction;			ySpeed *= friction;						xVel = xSpeed;			yVel = ySpeed;						par.x += xVel;			par.y += yVel;		}		public function reset()		{			//resets object			par.x = 150;			par.y = 150;			xVel = 0;			yVel = 0;			yAcc = 0;			xAcc = 0;			xSpeed = 0;			ySpeed = 0;		}		public function heroMovement(xVal:Number, yVal:Number)		{			//calculations to make the hero movements slippery			xAcc = xVal;			yAcc = yVal;			//trace("yAcc: ", yAcc);			//trace("xAcc: ", xAcc);			xSpeed += xAcc;			ySpeed += yAcc;			xSpeed *= friction;			ySpeed *= friction;						xVel = xSpeed;			yVel = ySpeed;			par.x += xVel;			par.y += yVel;						//keeps the hero on screen			if(par.x > screenWidth)			{				par.x = 0;				//xSpeed = 0;			}			if(par.x < 0 - par.width / 2)			{				par.x = screenWidth;				//xSpeed = 0;			}			if(par.y > screenHeight)			{				par.y = 0;				//ySpeed = 0;			}			if(par.y < 0)			{				par.y = screenHeight;				//ySpeed = 0;			}		}	}	}