
var Morpion_Line = Class.create({
	initialize: function(x, y, dir){
		this.x = x;
		this.y = y;
		this.dir = dir;
	},
	equals: function(line){
		return this.x == line.x && this.y == line.y && this.dir == line.dir
	},
	points: function(){

		var start_point = this.start_point();
		var points = [];
		var dir = this.dir;

		(5).times(function(){
			points.push(start_point)
			start_point = start_point.next_point(dir)
		});

		return points
	},
	start_point: function(){
		return new Point(this.x,this.y);
	},
	overlap: function(line){
		// the directions have to match and the intersection of the points
		// must not be empty

		var points1 = this.points();
		var points2 = line.points();

		var intersection = []

		for(var i=0; i<points1.length; i++) {
			for(var j=0; j<points2.length; j++) {
				var p1 = points1[i]
				var p2 = points2[j]
				if (p1.x == p2.x && p1.y == p2.y){
					intersection.push(points1[i]);
				}

			}
		}

		return this.dir == line.dir && intersection.length > 1
	},
	equals: function(line){
		return this.x == line.x && this.y == line.y && this.dir == line.dir
	},
	next_line: function(){
		var line = null;

		if (this.dir == 's'){
			line = new Morpion_Line(this.x, this.y + 1, this.dir)
		}
		else if (this.dir == 'e'){
			line = new Morpion_Line(this.x + 1, this.y, this.dir)
		}
		else if (this.dir == 'se'){
			line = new Morpion_Line(this.x + 1, this.y + 1, this.dir)
		}
		else if (this.dir == 'ne'){
			line = new Morpion_Line(this.x + 1, this.y - 1, this.dir)
		}
		return line;
	}

});

var Morpion_Move = Class.create({
	initialize: function(x, y, line_x, line_y, line_dir){
		this.x = x;
		this.y = y;
		this.line = new Morpion_Line(line_x, line_y, line_dir);
	},
	equals: function(move){
		return this.x == move.x && this.y == move.y && this.line == move.line
	},
	toString: function(){
		return [this.x,this.y,this.line.x,this.line.y,this.line.dir].join(",");
	}
});

var Point = Class.create({
	initialize: function(x,y){
		this.x = x
		this.y = y
	},
	next_point: function(dir){
		var point = null;

		if (dir == 's'){
			point = new Point(this.x, this.y + 1)
		}
		else if (dir == 'e'){
			point = new Point(this.x + 1, this.y)
		}
		else if (dir == 'se'){
			point = new Point(this.x + 1, this.y + 1)
		}
		else if (dir == 'ne'){
			point = new Point(this.x + 1, this.y - 1)
		}
		return point;
	},
	prev: function(dir){
		var point = null;
		if (dir == 's'){
			point = new Point(this.x, this.y - 1)
		}
		else if (dir == 'e'){
			point = new Point(this.x - 1, this.y)
		}
		else if (dir == 'se'){
			point = new Point(this.x - 1, this.y - 1)
		}
		else if (dir == 'ne'){
			point = new Point(this.x - 1, this.y + 1)
		}

		return point;
	},
	equals: function(point){
		return this.x == point.x && this.y == point.y
	}

});

var Morpion = Class.create({
	initialize: function(){
		this.board = [];
		this.mask_x = 0x00001;
		this.mask_dir_map = {
			'ne' : 0x00010,
			'e' :  0x00100,
			'se' : 0x01000,
			's' :  0x10000
		};

		this.DIRECTION_INDEX = {
			'ne' : 0,
			'e' : 1,
			'se' : 2,
			's' : 3
		}

		this.BASE64_ENC_TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

		this.possible_moves = [
			new Morpion_Move(3,-1,3,-1,'s'),
			new Morpion_Move(6,-1,6,-1,'s'),
			new Morpion_Move(2,0,2,0,'e'),
			new Morpion_Move(7,0,3,0,'e'),
			new Morpion_Move(3,4,3,0,'s'),
			new Morpion_Move(7,2,5,0,'se'),
			new Morpion_Move(6,4,6,0,'s'),
			new Morpion_Move(0,2,0,2,'s'),
			new Morpion_Move(9,2,9,2,'s'),
			new Morpion_Move(-1,3,-1,3,'e'),
			new Morpion_Move(4,3,0,3,'e'),
			new Morpion_Move(0,7,0,3,'s'),
			new Morpion_Move(5,3,5,3,'e'),
			new Morpion_Move(10,3,6,3,'e'),
			new Morpion_Move(9,7,9,3,'s'),
			new Morpion_Move(2,2,0,4,'ne'),
			new Morpion_Move(2,7,0,5,'se'),
			new Morpion_Move(3,5,3,5,'s'),
			new Morpion_Move(6,5,6,5,'s'),
			new Morpion_Move(-1,6,-1,6,'e'),
			new Morpion_Move(4,6,0,6,'e'),
			new Morpion_Move(3,10,3,6,'s'),
			new Morpion_Move(5,6,5,6,'e'),
			new Morpion_Move(10,6,6,6,'e'),
			new Morpion_Move(6,10,6,6,'s'),
			new Morpion_Move(2,9,2,9,'e'),
			new Morpion_Move(7,9,3,9,'e'),
			new Morpion_Move(7,7,5,9,'ne')
		];

		this.taken_moves = [];



		this.set_point_x(3,0);
		this.set_point_x(4,0);
		this.set_point_x(5,0);
		this.set_point_x(6,0);
		this.set_point_x(6,1);
		this.set_point_x(6,2);
		this.set_point_x(6,3);
		this.set_point_x(7,3);
		this.set_point_x(8,3);
		this.set_point_x(9,3);
		this.set_point_x(9,4);
		this.set_point_x(9,5);
		this.set_point_x(9,6);
		this.set_point_x(8,6);
		this.set_point_x(7,6);
		this.set_point_x(6,6);
		this.set_point_x(6,7);
		this.set_point_x(6,8);
		this.set_point_x(6,9);
		this.set_point_x(5,9);
		this.set_point_x(4,9);
		this.set_point_x(3,9);
		this.set_point_x(3,8);
		this.set_point_x(3,7);
		this.set_point_x(3,6);
		this.set_point_x(2,6);
		this.set_point_x(1,6);
		this.set_point_x(0,6);
		this.set_point_x(0,5);
		this.set_point_x(0,4);
		this.set_point_x(0,3);
		this.set_point_x(1,3);
		this.set_point_x(2,3);
		this.set_point_x(3,3);
		this.set_point_x(3,2);
		this.set_point_x(3,1);


	},
	score: function(){
		return this.taken_moves.length
	},
	point_blank: function(x,y){
		var index = this.point_index(x,y)
		return !this.board[index]
	},
	point_dir: function(x,y,dir){
		var index = this.point_index(x,y)
		return (this.board[index] & this.mask_dir_map[dir]) != 0
	},
	set_point_dir: function(x,y,dir){
		var index = this.point_index(x,y)
		this.board[index] |= this.mask_dir_map[dir]
	},
	point_index: function(x,y){
		return (x + 15) * 40 + (y + 15)
	},
	set_point_x: function(x,y){
		var index = this.point_index (x,y)
		this.board[index] |= this.mask_x
	},
	eval_line: function(line){


		var count = 0;

		var points = line.points();

		var move_point = null;

//			console.log(points);

		points.each(function(point){
			var point_blank = this.point_blank(point.x,point.y)
			var point_dir_set = this.point_dir(point.x,point.y,line.dir)
//				console.log(point,point_blank,point_dir_set,!point_dir_set || (point_dir_set && (point == points.first() || point == points.last())))
			if (!point_blank){
				if (!point_dir_set || (point_dir_set && (point == points.first() || point == points.last()))){
					count += 1;
//						console.log(count)
				}
			}
			else{
				move_point = point;
			}
		},this);

//			console.log(count);

		var move = null;

		if (count == 4 && move_point){

			move = new Morpion_Move(move_point.x,move_point.y, line.x, line.y, line.dir);
//				console.log("adding this move:", move)
		}
		return move;
	},
	find_moves_add: function(move){

		var add_moves = []


		$(['s','e','se','ne']).each(function(dir){

			var search_line = null;

			if (dir == 's'){
				search_line = new Morpion_Line(move.x, move.y - 4, dir);
			}
			else if (dir == 'e'){
				search_line = new Morpion_Line(move.x - 4, move.y, dir);
			}
			else if (dir == 'se'){
				search_line = new Morpion_Line(move.x - 4, move.y - 4, dir);
			}
			else if (dir == 'ne'){
				search_line = new Morpion_Line(move.x - 4, move.y + 4, dir);
			}



			//console.log(this)
			(5).times((function(){

//					console.log(search_line)

				var possible_move = this.eval_line(search_line);

//					if (possible_move){
//						console.log("FOUND",possible_move);
//					}

				if (possible_move && !this.possible_moves.include(possible_move)){
					add_moves.push(possible_move);
				}

				search_line = search_line.next_line()
			}).bind(this));




		},this);


		return add_moves;
	},
	make_move:function (move){

		if (this.possible_moves.include(move)){

//				console.log("making move", move)

			move.line.points().each(function(point){
//					console.log(point,this.board[this.point_index(point.x,point.y)]);
				this.set_point_dir(point.x, point.y, move.line.dir)
//					console.log(point,this.board[this.point_index(point.x,point.y)], this.point_blank(point.x,point.y));
			},this);

			this.taken_moves.push(move)


			this.possible_moves = this.possible_moves.reject(function(possible_move){
				var s =(possible_move.x == move.x && possible_move.y == move.y) || possible_move.line.overlap(move.line)

				if (s){
//						console.log("removeing move: ", possible_move);
				}

				return s
			});




			var add_moves = this.find_moves_add(move)

			this.possible_moves = this.possible_moves.concat(add_moves);

		}
		else{
			console.log ("ERROR: Illegal move");
		}

	},
	dna_line_index: function(line){
		return (line.x + 15) * 40 * 4 + (line.y + 15) * 4 + this.DIRECTION_INDEX[line.dir]
	},
	generate_dna: function(){
		var randy = new Array(40*40*4 - this.taken_moves.length)
		randy.length.times(function(index){
			randy[index] = index
		});
		randy = randy.sortBy(function(){Math.random()});

		var dna = new Array(40*40*4)

		var max = 6399

		this.taken_moves.each(function(move,index){
			var pref = max - index;
			dna[this.dna_line_index(move.line)] = pref;

		},this);


		var randy_index = 0

		dna.length.times(function(index){
			
			var pref = dna[index]
			
			if (!pref){
				dna[index] = randy[randy_index]
				randy_index += 1
			}
		})
		
		return dna;

	},
	random_taken_move: function(){
		return this.taken_moves[Math.floor(Math.random()*this.taken_moves.length)]
	},
	random_taken_move_line_index: function(){
		var rand_taken_move = this.random_taken_move();
		var index = 0;
		if (rand_taken_move){
			index = this.dna_line_index(rand_taken_move.line);
		}
		return index
	},
	random_completion: function(){
		while (this.possible_moves.length > 0){

			this.make_move(this.possible_moves[Math.floor(Math.random()*this.possible_moves.length)])
		}
	},
	find_dna_preference: function(line, dna){
		return dna[this.dna_line_index(line)]
	},
	best_dna_move: function(dna){
		var move = null;
		if (this.possible_moves.length == 1){
			move = this.possible_moves.first()
		}
		else{
			var max_score = 0;

			this.possible_moves.each(function(possible_move){
				var score = this.find_dna_preference(possible_move.line, dna)
				if (score > max_score){
					move = possible_move;
					max_score = score
				}
			}, this);

//			move = this.possible_moves.max(function(possible_move){
//				return this.find_dna_preference(possible_move.line, dna)
//			},this);

		}

		return move
	},
	make_best_dna_move: function(dna){
		var best_dna_move = this.best_dna_move(dna)
//		console.log(best_dna_move)
		if (best_dna_move){
			this.make_move(best_dna_move)
		}

	},
	eval_dna: function(dna){
		
		while (this.possible_moves.length > 0){
			this.make_best_dna_move(dna)
		}
	},
	move_sort: function(a,b){
		var i = a.x - b.x;

		if (i == 0){
			i = a.y - b.y;
		}

		if (i == 0){
			i = a.line.x - b.line.x;
		}

		if (i == 0){
			i = a.line.y - b.line.y;
		}

		if (i == 0){
			i = this.DIRECTION_INDEX[a.line.dir] - this.DIRECTION_INDEX[b.line.dir];
		}

		//[move.x, move.y, move.line.x, move.line.y, this.DIRECTION_INDEX[move.line.dir]];




		return i;
	},
	decode_moves: function(data){
		var bin = '';
		data.toArray().each(function(ch){
			var sextuplet = this.BASE64_ENC_TABLE.indexOf(ch).toString(2)

			while (sextuplet.length < 6){
				sextuplet = '0' + sextuplet;
			}

//			console.log(sextuplet)
			bin += sextuplet
		},this);


		var index = 0
		while (index < bin.length && this.possible_moves.length > 0){
			var i = index


			var make_move = this.possible_moves.sort(this.move_sort.bind(this)).find(function(){
				var match = bin[i] == '1'
				i += 1
				return match
			})

//			console.log(make_move);

//			if (!make_move){
//				make_move = this.possible_moves.first();
//			}

			index += this.possible_moves.length

			if (make_move){
				this.make_move(make_move)
			}

		}
	}


});