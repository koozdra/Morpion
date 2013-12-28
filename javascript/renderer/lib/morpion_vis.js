var MorpionVis = Class.create({
	initialize: function(canvas){
		this.canvas = canvas;
		this.ctx = canvas.getContext('2d');
		this.startOffsetX = 500;
		this.startOffsetY = 500;

		this.dotSpacing = 50;

		this.circleWidth = 15;
		this.moveIndicatorWidth = 7;
	},
	clear: function(){
		this.ctx.clearRect(0,0,1500,1500);
	},
	drawCircleNumber: function(x, y, text, color){

		color = color || "rgb(255,255,255)";

		this.ctx.beginPath();
		this.ctx.arc(this.startOffsetX + x * this.dotSpacing, this.startOffsetY + y * this.dotSpacing, this.circleWidth, 0, Math.PI*2, true);
		this.ctx.closePath();
		this.ctx.fillStyle = color;
		this.ctx.fill();
		this.ctx.strokeStyle = 'rgb(0,0,0)';
		this.ctx.stroke();

		len = (text+'').length
		this.ctx.fillStyle = "rgb(0,0,0)";
		this.ctx.fillText(text, this.startOffsetX + x * this.dotSpacing - (3 * len), this.startOffsetY + y * this.dotSpacing + 3);

	},
	drawLine: function(x1, y1, x2, y2, color){

		color = color || "rgb(0,0,0)";;

		this.ctx.strokeStyle = color;
		this.ctx.beginPath();
		this.ctx.moveTo(this.startOffsetX + x1 * this.dotSpacing, this.startOffsetY + y1 * this.dotSpacing);
		this.ctx.lineTo(this.startOffsetX + x2 * this.dotSpacing, this.startOffsetY + y2 * this.dotSpacing);
		this.ctx.stroke();
	},
	connectCircles: function(x, y, lineX, lineY, dir, color){

		if (dir == 'se'){
			this.drawLine(lineX, lineY, lineX + 4, lineY + 4, color);

			this.ctx.beginPath();
			this.ctx.arc(this.startOffsetX + lineX * this.dotSpacing + (Math.sin(Math.PI/4)*this.circleWidth), this.startOffsetY + lineY * this.dotSpacing + (Math.cos(Math.PI/4)*this.circleWidth), 4, 0, Math.PI*2, true);
			this.ctx.closePath();
			this.ctx.fillStyle = "rgb(50,50,50)";
			this.ctx.fill();

			this.ctx.beginPath();
			this.ctx.arc(this.startOffsetX + (lineX + 4) * this.dotSpacing - (Math.sin(Math.PI/4)*this.circleWidth), this.startOffsetY + (lineY + 4) * this.dotSpacing - (Math.cos(Math.PI/4)*this.circleWidth), 4, 0, Math.PI*2, true);
			this.ctx.closePath();
			this.ctx.fillStyle = "rgb(50,50,50)";
			this.ctx.fill();

			if (x != lineX || y != lineY){
				this.ctx.beginPath();
				this.ctx.arc(this.startOffsetX + x * this.dotSpacing - (Math.sin(Math.PI/4)*this.circleWidth), this.startOffsetY + y * this.dotSpacing - (Math.cos(Math.PI/4)*this.circleWidth), this.moveIndicatorWidth, 0, Math.PI*2, true);
				this.ctx.closePath();
				this.ctx.fillStyle = "rgb(0,0,0)";
				this.ctx.fill();
			}


			if (x != lineX + 4 || y != lineY + 4){
				this.ctx.beginPath();
				this.ctx.arc(this.startOffsetX + x * this.dotSpacing + (Math.sin(Math.PI/4)*this.circleWidth), this.startOffsetY + y * this.dotSpacing + (Math.cos(Math.PI/4)*this.circleWidth), this.moveIndicatorWidth, 0, Math.PI*2, true);
				this.ctx.closePath();
				this.ctx.fillStyle = "rgb(0,0,0)";
				this.ctx.fill();
			}




		}
		else if (dir == 'ne'){
			this.drawLine(lineX, lineY, lineX + 4, lineY - 4, color);

			this.ctx.beginPath();
			this.ctx.arc(this.startOffsetX + lineX * this.dotSpacing + (Math.sin(Math.PI/4)*this.circleWidth), this.startOffsetY + lineY * this.dotSpacing - (Math.cos(Math.PI/4)*this.circleWidth), 4, 0, Math.PI*2, true);
			this.ctx.closePath();
			this.ctx.fillStyle = "rgb(50,50,50)";
			this.ctx.fill();

			this.ctx.beginPath();
			this.ctx.arc(this.startOffsetX + (lineX + 4) * this.dotSpacing - (Math.sin(Math.PI/4)*this.circleWidth), this.startOffsetY + (lineY - 4) * this.dotSpacing + (Math.cos(Math.PI/4)*this.circleWidth), 4, 0, Math.PI*2, true);
			this.ctx.closePath();
			this.ctx.fillStyle = "rgb(50,50,50)";
			this.ctx.fill();


			if (x != lineX || y != lineY){
				this.ctx.beginPath();
				this.ctx.arc(this.startOffsetX + x * this.dotSpacing - (Math.sin(Math.PI/4)*this.circleWidth), this.startOffsetY + y * this.dotSpacing + (Math.cos(Math.PI/4)*this.circleWidth), this.moveIndicatorWidth, 0, Math.PI*2, true);
				this.ctx.closePath();
				this.ctx.fillStyle = "rgb(0,0,0)";
				this.ctx.fill();
			}

			if (x != lineX + 4 || y != lineY - 4){
				this.ctx.beginPath();
				this.ctx.arc(this.startOffsetX + x * this.dotSpacing + (Math.sin(Math.PI/4)*this.circleWidth), this.startOffsetY + y * this.dotSpacing - (Math.cos(Math.PI/4)*this.circleWidth), this.moveIndicatorWidth, 0, Math.PI*2, true);
				this.ctx.closePath();
				this.ctx.fillStyle = "rgb(0,0,0)";
				this.ctx.fill();
			}



		}
		else if (dir == 's'){
			this.drawLine(lineX, lineY, lineX, lineY + 4, color);

			this.ctx.beginPath();
			this.ctx.arc(this.startOffsetX + lineX * this.dotSpacing, this.startOffsetY + lineY * this.dotSpacing + this.circleWidth, 4, 0, Math.PI*2, true);
			this.ctx.closePath();
			this.ctx.fillStyle = "rgb(50,50,50)";
			this.ctx.fill();

			this.ctx.beginPath();
			this.ctx.arc(this.startOffsetX + lineX * this.dotSpacing, this.startOffsetY + (lineY + 4) * this.dotSpacing - this.circleWidth, 4, 0, Math.PI*2, true);
			this.ctx.closePath();
			this.ctx.fillStyle = "rgb(50,50,50)";
			this.ctx.fill();


			// && (x != lineX || y!= lineY + 4)
			if (x != lineX || y != lineY){
				this.ctx.beginPath();
				this.ctx.arc(this.startOffsetX + x * this.dotSpacing, this.startOffsetY + y * this.dotSpacing - this.circleWidth, this.moveIndicatorWidth, 0, Math.PI*2, true);
				this.ctx.closePath();
				this.ctx.fillStyle = "rgb(0,0,0)";
				this.ctx.fill();
			}

			if (x != lineX || y != lineY + 4){
				this.ctx.beginPath();
				this.ctx.arc(this.startOffsetX + x * this.dotSpacing, this.startOffsetY + y * this.dotSpacing + this.circleWidth, this.moveIndicatorWidth, 0, Math.PI*2, true);
				this.ctx.closePath();
				this.ctx.fillStyle = "rgb(0,0,0)";
				this.ctx.fill();
			}


		}
		else if (dir == 'e'){
			this.drawLine(lineX, lineY, lineX + 4, lineY, color);


			this.ctx.beginPath();
			this.ctx.arc(this.startOffsetX + lineX * this.dotSpacing + this.circleWidth, this.startOffsetY + lineY * this.dotSpacing, 4, 0, Math.PI*2, true);
			this.ctx.closePath();
			this.ctx.fillStyle = "rgb(50,50,50)";
			this.ctx.fill();

			this.ctx.beginPath();
			this.ctx.arc((this.startOffsetX + (lineX + 4) * this.dotSpacing) - this.circleWidth, this.startOffsetY + lineY * this.dotSpacing, 4, 0, Math.PI*2, true);
			this.ctx.closePath();
			this.ctx.fillStyle = "rgb(50,50,50)";
			this.ctx.fill();


			if (x != lineX || y != lineY){
				this.ctx.beginPath();
				this.ctx.arc(this.startOffsetX + x * this.dotSpacing - this.circleWidth, this.startOffsetY + y * this.dotSpacing, this.moveIndicatorWidth, 0, Math.PI*2, true);
				this.ctx.closePath();
				this.ctx.fillStyle = "rgb(0,0,0)";
				this.ctx.fill();
			}

			if (x != lineX + 4 || y != lineY){
				this.ctx.beginPath();
				this.ctx.arc(this.startOffsetX + x * this.dotSpacing + this.circleWidth, this.startOffsetY + y * this.dotSpacing, this.moveIndicatorWidth, 0, Math.PI*2, true);
				this.ctx.closePath();
				this.ctx.fillStyle = "rgb(0,0,0)";
				this.ctx.fill();
			}


		}




	},
	drawMove: function(x, y, lineX, lineY, dir, text){

		this.drawCircleNumber(x, y, text);

		var currGlobalCompositeOperation = this.ctx.globalCompositeOperation;
		this.ctx.globalCompositeOperation = 'destination-over';

		this.connectCircles(x, y, lineX, lineY, dir);


		this.ctx.globalCompositeOperation = currGlobalCompositeOperation

	},
	drawPossibleMove: function(x, y, lineX, lineY, dir){

		var color = 'rgb(0, 128, 0)'

		this.drawCircleNumber(x, y, 'P', color);

		var currGlobalCompositeOperation = this.ctx.globalCompositeOperation;
		this.ctx.globalCompositeOperation = 'destination-over';

		this.connectCircles(x, y, lineX, lineY, dir, color);


		this.ctx.globalCompositeOperation = currGlobalCompositeOperation

	}
});