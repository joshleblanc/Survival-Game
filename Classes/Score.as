﻿package  {		import starling.text.TextField;	import flash.text.TextFormat;	import flash.display.BlendMode;	public class Score extends TextField {		public function Score()		{			//displays the current score.			x = 0;			y = 180;			height = 500;			width = 500;			var format:TextFormat = new TextFormat();			format.size=56;			format.align = "center";			blendMode = BlendMode.LAYER;			alpha = .25;		}	}	}