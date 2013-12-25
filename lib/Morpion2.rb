
require 'digest/sha1'

module Morpion2
	DIRECTION_INDEX = {
		:ne => 0,
		:e => 1,
		:se => 2,
		:s => 3
	}

	CLOCK_ROTATE_DIRS = {
		:e => :s,
		:s => :e,
		:ne => :se,
		:se => :ne
	}

	BASE64_ENC_TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

	class Morpion

		attr_accessor :possible_moves, :taken_moves, :board

		def initialize

			@board = Array.new(1600){0}

			@mask_x = 0b00001
			@mask_dir_map = {
				:ne => 0b00010,
				:e =>  0b00100,
				:se => 0b01000,
				:s =>  0b10000
			}

			@possible_moves = [
				Morpion_Move.new(3,-1,3,-1,:s),
				Morpion_Move.new(6,-1,6,-1,:s),
				Morpion_Move.new(2,0,2,0,:e),
				Morpion_Move.new(7,0,3,0,:e),
				Morpion_Move.new(3,4,3,0,:s),
				Morpion_Move.new(7,2,5,0,:se),
				Morpion_Move.new(6,4,6,0,:s),
				Morpion_Move.new(0,2,0,2,:s),
				Morpion_Move.new(9,2,9,2,:s),
				Morpion_Move.new(-1,3,-1,3,:e),
				Morpion_Move.new(4,3,0,3,:e),
				Morpion_Move.new(0,7,0,3,:s),
				Morpion_Move.new(5,3,5,3,:e),
				Morpion_Move.new(10,3,6,3,:e),
				Morpion_Move.new(9,7,9,3,:s),
				Morpion_Move.new(2,2,0,4,:ne),
				Morpion_Move.new(2,7,0,5,:se),
				Morpion_Move.new(3,5,3,5,:s),
				Morpion_Move.new(6,5,6,5,:s),
				Morpion_Move.new(-1,6,-1,6,:e),
				Morpion_Move.new(4,6,0,6,:e),
				Morpion_Move.new(3,10,3,6,:s),
				Morpion_Move.new(5,6,5,6,:e),
				Morpion_Move.new(10,6,6,6,:e),
				Morpion_Move.new(6,10,6,6,:s),
				Morpion_Move.new(2,9,2,9,:e),
				Morpion_Move.new(7,9,3,9,:e),
				Morpion_Move.new(7,7,5,9,:ne)
			]

			@taken_moves = []

			#  R  XXXX
			#     X  X
			#     X  X
			#  XXXX  XXXX
			#  X        x
			#  X        x
			#  XXXX  XXXX
			#     X  X
			#     X  X
			#     XXXX
			
			# R = (0,0)

			set_point_x(3,0);
			set_point_x(4,0);
			set_point_x(5,0);
			set_point_x(6,0);
			set_point_x(6,1);
			set_point_x(6,2);
			set_point_x(6,3);
			set_point_x(7,3);
			set_point_x(8,3);
			set_point_x(9,3);
			set_point_x(9,4);
			set_point_x(9,5);
			set_point_x(9,6);
			set_point_x(8,6);
			set_point_x(7,6);
			set_point_x(6,6);
			set_point_x(6,7);
			set_point_x(6,8);
			set_point_x(6,9);
			set_point_x(5,9);
			set_point_x(4,9);
			set_point_x(3,9);
			set_point_x(3,8);
			set_point_x(3,7);
			set_point_x(3,6);
			set_point_x(2,6);
			set_point_x(1,6);
			set_point_x(0,6);
			set_point_x(0,5);
			set_point_x(0,4);
			set_point_x(0,3);
			set_point_x(1,3);
			set_point_x(2,3);
			set_point_x(3,3);
			set_point_x(3,2);
			set_point_x(3,1);

		end

		def encode_moves


			bin = encode_binary

			base64_enc = ''

			bin.scan(/.{1,6}/).each do |sextuplet|
				sextuplet = sextuplet.ljust(6,'0')
				base64_enc += BASE64_ENC_TABLE[sextuplet.to_i(2)]
			end

			base64_enc
		end

		def encode_binary

			morpion = Morpion.new

#			bin = '';
#			@taken_moves.each do |move|
#				morpion.possible_moves.sort_by { |move| [move.x, move.y, move.line.x, move.line.y, DIRECTION_INDEX[move.line.dir]] }.each do |possible_move|
#					bin = (move == possible_move) ? bin + '1' : bin + '0'
#				end
#
#				if !morpion.possible_moves.include? move
#					puts "here is the error"
#				end
#
#				morpion.make_move move
#			end
			
			bin = '';
			@taken_moves.each do |move|

				if !morpion.possible_moves.include? move
					raise "encode binary error"
				end

				morpion.possible_moves.sort_by { |move| [move.x, move.y, move.line.x, move.line.y, DIRECTION_INDEX[move.line.dir]] }.each do |possible_move|
					bin = (move == possible_move) ? bin + '1' : bin + '0'
				end

				morpion.make_move move

#				puts "bin: #{morpion.taken_moves.length}: #{move}"
			end
			bin
		end

		def generate_dna2

			randy = Array.new(40*40*4 - @taken_moves.length){|index| index}.sort_by{rand}
			dna = Array.new(40*40*4)

			
			max = 6399

			@taken_moves.each_with_index do |move, index|
				pref = max-index

				dna[dna_line_index move.line] = pref
			end

			randy_index = 0
			dna.each_with_index do |pref,index|
				if !pref
					dna[index] = randy[randy_index]
					randy_index += 1
				end
			end
			dna
		end
		
		def generate_dna
			
			dna = Array.new(40*40*4){rand}
			@taken_moves.each_with_index do |move, index|
				dna[dna_line_index move.line] = (@taken_moves.length + 1) - index
			end

			dna
		end
		
		def generate_dna3
			
			dna = Array.new(40*40*4){rand}
			moves = Array.new(@taken_moves.length){|index| index}.sort_by{rand}
			@taken_moves.each_with_index do |move, index|
				dna[dna_line_index move.line] = moves[index]
			end

			dna
		end

		def random_completion
			while move = make_random_move
#				puts "#{taken_moves.length}: #{move}"
			end
		end
		
		def make_random_move
			make_move @possible_moves[rand(@possible_moves.length)] if !@possible_moves.empty?
		end

		def score
			taken_moves.length
		end

		def dna_line_index (line)
			(line.x + 15) * 40 * 4 + (line.y + 15) * 4 + DIRECTION_INDEX[line.dir]
		end

		def decode_moves data

			bin = ''
			data.each_char do |char|
				sextuplet = BASE64_ENC_TABLE.index(char).to_s(2).rjust(6,'0')
				bin += sextuplet
			end
			
			index = 0

#			puts "decode_moves"

			

			while index < bin.length && !@possible_moves.empty?
				i = index
				make_move = @possible_moves.sort_by { |move| [move.x, move.y, move.line.x, move.line.y, DIRECTION_INDEX[move.line.dir]] }.find do
					match = bin[i] == '1'
					i += 1
					match
				end

#				puts "make move: #{make_move} #{score} #{index} #{bin.length} #{@possible_moves.length}"

#				make_move = @possible_moves.first if !make_move
#
				index += @possible_moves.length

				make_move make_move if make_move

			end

		end

		def make_best_dna_move dna

			move = best_dna_move dna

			make_move move if move
		end
		
		def make_best_dna_move2 dna

			move = best_dna_move dna

			make_move2 move if move
		end
		
		def dna_completion dna
			while make_best_dna_move dna
				
			end
		end

		def pack
			bin = pack_binary

			base64_enc = ''

			bin.scan(/.{1,6}/).each do |sextuplet|
				sextuplet = sextuplet.ljust(6,'0')
				base64_enc += BASE64_ENC_TABLE[sextuplet.to_i(2)]
			end

			base64_enc
		end
		
		
		def moves_in_layers
			layers = []
			
			
			layer = {}
			


			layer_num = 1
			tot = 0

			taken_move_index = {}


			@taken_moves.each do |taken_move|
				taken_move_index[taken_move] = true
			end

			builder = Morpion2::Morpion.new

			taboo_moves = {}

			while builder.possible_moves.length > 0 && !taken_move_index.empty?
				
				layer = {:taken=>[],:taboo=>[]}
				
				poss_moves = builder.possible_moves.find_all do |possible_move|
					!taboo_moves[possible_move]
				end

				used = 0

				poss_moves.sort_by{|move| [move.x, move.y, move.line.x, move.line.y, DIRECTION_INDEX[move.line.dir]]}.each do |possible_move|
					if taken_move_index[possible_move]
						
						builder.make_move possible_move
						
						layer[:taken] << possible_move
						
						taken_move_index.delete possible_move
						
						used += 1
					else
						taboo_moves[possible_move] = true
						
						layer[:taboo] << possible_move
						
					end
				end
				tot += used
				
				layers << layer
				
				layer_num += 1

			end

			layers
		end
		
		
		def pack_binary
			bin = ''


			layer_num = 1
			tot = 0

			taken_move_index = {}


			@taken_moves.each_with_index do |taken_move, index|
				taken_move_index[taken_move] = true
			end

			builder = Morpion2::Morpion.new

			taboo_moves = {}

			while builder.possible_moves.length > 0 && !taken_move_index.empty?
				poss_moves = builder.possible_moves.find_all do |possible_move|
					!taboo_moves[possible_move]
				end

				used = 0

				poss_moves.sort_by{|move| [move.x, move.y, move.line.x, move.line.y, DIRECTION_INDEX[move.line.dir]]}.each do |possible_move|
					if taken_move_index[possible_move]
						bin += '1'
						builder.make_move possible_move

						taken_move_index.delete possible_move

						used += 1
					else
						taboo_moves[possible_move] = true
						bin += '0'
					end
				end
				tot += used

				layer_num += 1

			end

			bin
		end
		
		def unpack pack
			bin = ''
			pack.each_char do |char|
				sextuplet = BASE64_ENC_TABLE.index(char).to_s(2).rjust(6,'0')
				bin += sextuplet
			end

			unpack_binary bin
		end

		def unpack_binary bin
			
			#zeros at the end are there just for padding
#			bin = bin[0,(bin.rindex '1')]
			
#			taboo_moves = {}
#
#			i = 0
#			while @possible_moves.length > 0
#				poss_moves = @possible_moves.find_all do |possible_move|
#					!taboo_moves[possible_move]
#				end
#				poss_moves.sort_by{|move| [move.x, move.y, move.line.x, move.line.y, Morpion2::DIRECTION_INDEX[move.line.dir]]}.each do |possible_move|
#
#					if bin[i] == '1'
#						make_move possible_move
#
#					else
#						taboo_moves[possible_move] = true
#					end
#					i += 1
#				end
#			end
			
			taboo_moves = {}

			i = 0
			while @possible_moves.length > 0 && i < bin.length
				poss_moves = @possible_moves.find_all do |possible_move|
					!taboo_moves[possible_move]
				end
				poss_moves.sort_by{|move| [move.x, move.y, move.line.x, move.line.y, Morpion2::DIRECTION_INDEX[move.line.dir]]}.each do |possible_move|

					if bin[i] == '1'
						make_move possible_move

					else
						taboo_moves[possible_move] = true
					end
					i += 1
				end
				raise "MORPION ERROR (unpack_binary): not a valid encoding" if i < bin.length && poss_moves.empty?
			end
			
			taboo_moves
		end


		def find_dna_preference line, dna
			dna[dna_line_index(line)]
		end
		
		def ordered_move_string
			@taken_moves.collect{|move| "#{move.x},#{move.y}"}.sort.join('|')
			
		end

		def ordered_move_string2
			@taken_moves.collect{|move| "|#{move.x},#{move.y}"}.sort
		end
		
		
		#not a huge difference here
		def ordered_move_string_hash
			Digest::SHA1.hexdigest ordered_move_string
		end
		
		def ordered_move_string_hash2
			Digest::SHA1.hexdigest ordered_move_string
		end
		
		

		
		def best_dna_move dna
			move = nil
			if @possible_moves.length == 1
				move = @possible_moves.first
			else
				move = @possible_moves.max_by{|possible_move|
					find_dna_preference possible_move.line, dna
				}
			end

			move
		end

		def eval_dna dna
			make_best_dna_move dna while !@possible_moves.empty?
		end
		
		def eval_dna2 dna
			make_best_dna_move2 dna while !@possible_moves.empty?
		end
		

		def set_point_dir x,y,dir
			index = point_index x,y
			@board[index] |= @mask_dir_map[dir]
		end

		def find_moves_remove move

			@possible_moves.find_all do |possible_move|
				(possible_move.x == move.x && possible_move.y == move.y) || possible_move.line.overlap?(move.line)
			end

		end

		def make_move move

			move.line.points.each do |point|
				set_point_dir point.x, point.y, move.line.dir
			end

			@taken_moves << move

			@possible_moves.delete_if do |possible_move|
				(possible_move.x == move.x && possible_move.y == move.y) || possible_move.line.overlap?(move.line)
			end

			add_moves = find_moves_add move

			@possible_moves += add_moves
		end
		
		def make_move2 move

			move.line.points.each do |point|
				set_point_dir point.x, point.y, move.line.dir
			end

			@taken_moves << move

			@possible_moves.delete_if do |possible_move|
				(possible_move.x == move.x && possible_move.y == move.y) || possible_move.line.overlap?(move.line)
			end

			add_moves = find_moves_add move

			@possible_moves += add_moves
		end
		

		def find_moves_add move

			add_moves = []

			# search for possible moves to add
			[:s,:e,:se,:ne].each do |dir|

				if dir == :s
					search_line = Morpion_Line.new(move.x, move.y - 4, dir)
				elsif dir == :e
						search_line = Morpion_Line.new(move.x - 4, move.y, dir)
				elsif dir == :se
						search_line = Morpion_Line.new(move.x - 4, move.y - 4, dir)
				elsif dir == :ne
						search_line = Morpion_Line.new(move.x - 4, move.y + 4, dir)
				end
				
				
				(0..5).each do
					possible_move = eval_line search_line

					if possible_move && !@possible_moves.include?(possible_move)
						add_moves << possible_move
					end


					search_line = search_line.next_line

				end


			end

			add_moves
		end

		def point_dir? x,y,dir
			index = point_index x,y
			@board[index] & @mask_dir_map[dir] != 0
		end

		def point_blank? x,y
			index = point_index x,y
		#	puts "point blank: #{x}, #{y} #{@board[index]}"
			@board[index] == 0
		end

		def eval_line line
			count = 0

			points = line.points

			move_point = nil

			points.each do |point|


				point_blank = point_blank?(point.x,point.y)
				point_dir_set = point_dir?(point.x,point.y,line.dir)

				if !point_blank
					if !point_dir_set || (point_dir_set && (point == points.first || point == points.last))
						count += 1
					end
				else
					move_point = point
				end

			end

			move = nil

			if count == 4 && move_point
				move = Morpion_Move.new(move_point.x,move_point.y, line.x, line.y, line.dir)
			end


			move
		end

		def point_index x,y
			(x + 15) * 40 + (y + 15)
		end
		

		def set_point_x x,y
			index = point_index x,y
			@board[index] |= @mask_x
		end
		
		def point_x? x,y
			index = point_index x,y
			@board[index] & @mask_x != 0
		end


		class Point

			attr_accessor :x, :y
			def initialize(x, y)
				@x = x
				@y = y
			end

			def to_s
				"(#{x}, #{y})"
			end

			def hash
				@x.hash ^ @y.hash
			end

			def ==(point)
				self.class.equal?(point.class) && @x == point.x && @y == point.y
			end

			def eql?(point)
				self.class.equal?(point.class) && @x == point.x && @y == point.y
			end



			def next(dir)
				point = Point.new(x, y + 1) if dir == :s
				point = Point.new(x + 1, y) if dir == :e
				point = Point.new(x + 1, y + 1) if dir == :se
				point = Point.new(x + 1, y - 1) if dir == :ne
				point
			end



			def prev(dir)
				point = Point.new(x, y - 1) if dir == :s
				point = Point.new(x - 1, y) if dir == :e
				point = Point.new(x - 1, y - 1) if dir == :se
				point = Point.new(x - 1, y + 1) if dir == :ne
				point
			end


		end

		class Morpion_Line
			attr_accessor :x, :y, :dir

			def initialize(x, y, dir)
				@x = x
				@y = y
				@dir = dir
			end

			def hash
				@x.hash ^ @y.hash ^ @dir.hash
			end

			def ==(line)
				self.class.equal?(line.class) && @x == line.x && @y == line.y && @dir == line.dir
			end

			def eql?(line)
				self.class.equal?(line.class) && @x == line.x && @y == line.y && @dir == line.dir
			end

			def to_s
				"#{x},#{y},#{dir}"
			end

			def start_point
				Point.new(x, y)
			end

			def points
				start = start_point
				points = []
				(0..4).each do
					points << start
					start = start.next(@dir)
				end
				points
			end

			
			def overlap?(line)
				# the directions have to match and the intersection of the points
				# must not be empty
				dir == line.dir && (points & line.points).length > 1
			end
			
			
			def end_point
				point = Point.new(x, y + 4) if dir == :s
				point = Point.new(x + 4, y) if dir == :e
				point = Point.new(x + 4, y + 4) if dir == :se
				point = Point.new(x + 4, y - 4) if dir == :ne

				point
			end

			def mid_point
				point = Point.new(x, y + 2) if dir == :s
				point = Point.new(x + 2, y) if dir == :e
				point = Point.new(x + 2, y + 2) if dir == :se
				point = Point.new(x + 2, y - 2) if dir == :ne

				point
			end

			def next_line
				line = Morpion_Line.new(x, y + 1, dir) if dir == :s
				line = Morpion_Line.new(x + 1, y, dir) if dir == :e
				line = Morpion_Line.new(x + 1, y + 1, dir) if dir == :se
				line = Morpion_Line.new(x + 1, y - 1, dir) if dir == :ne
				line
			end

			def previous_line
				line = Morpion_Line.new(x, y - 1, dir) if dir == :s
				line = Morpion_Line.new(x - 1, y, dir) if dir == :e
				line = Morpion_Line.new(x - 1, y - 1, dir) if dir == :se
				line = Morpion_Line.new(x - 1, y + 1, dir) if dir == :ne
				line
			end

			def next_logical_line
				line = Morpion_Line.new(x, y + 4, dir) if dir == :s
				line = Morpion_Line.new(x + 4, y, dir) if dir == :e
				line = Morpion_Line.new(x + 4, y + 4, dir) if dir == :se
				line = Morpion_Line.new(x + 4, y - 4, dir) if dir == :ne
				line
			end

			def previous_logical_line
				line = Morpion_Line.new(x, y - 4, dir) if dir == :s
				line = Morpion_Line.new(x - 4, y, dir) if dir == :e
				line = Morpion_Line.new(x - 4, y - 4, dir) if dir == :se
				line = Morpion_Line.new(x - 4, y + 4, dir) if dir == :ne
				line
			end
		end
		
		class Morpion_Move
			attr_accessor :x, :y, :line

			def initialize(x, y, line_x, line_y, line_dir)
				@x = x
				@y = y
				@line = Morpion_Line.new(line_x, line_y, line_dir)
			end

			def hash
				@x.hash ^ @y.hash ^ @line.hash
			end

			def ==(move)
				self.class.equal?(move.class) && @x == move.x && @y == move.y && @line == move.line
			end

			def eql?(move)
				self.class.equal?(move.class) && @x == move.x && @y == move.y && @line == move.line
			end

			def edge_move?
				diff_x = @x - @line.x
				diff_y = @y - @line.y

				#puts "#{diff_x} #{diff_y}"

				(diff_x == 0 && diff_y = 0) ||
				(diff_x == 4 && diff_y = -4) ||
				(diff_x == 4 && diff_y = 0) ||
				(diff_x == 4 && diff_y = 4) ||
				(diff_x == 0 && diff_y = 4)

			end

			def point
				Point.new x,y
			end

			def to_s
				"#{x}, #{y} - (#{line})"
			end
			
			def to_js
				"#{x},#{y},#{line.x},#{line.y},#{line.dir}"
			end
			
			def to_pentasol
				dirs = {
					:ne => '/',
					:e => '-',
					:se => '\\',
					:s => '|'
				}
				
				midpoint = line.mid_point
				
				factor = 0
				
				if line.dir == :s
					factor = midpoint.y - y
				else
					factor = midpoint.x - x
				end
				
				
				
				"(#{x + 25},#{y + 25}) #{dirs[line.dir]} #{factor}"
			end
		end

		def js_move_string

			parts = []
			@taken_moves.each do |move|
				parts << js_move(move)
			end

			parts.join('|')
		end

		def js_move move
			"#{move.x},#{move.y},#{move.line.x},#{move.line.y},#{move.line.dir}"
		end

		def duplicate2
	
#			morpion = Morpion.new
##			morpion.possible_moves = @possible_moves.dup
##			morpion.board = @board.dup
##			morpion.taken_moves = @taken_moves.dup
#			morpion.decode_moves encode_moves
#
#			morpion
			
#			morpion = Morpion.new
#			
#			@taken_moves.each do |taken_move|
#				morpion.make_move taken_move
#			end
#			
#			morpion

			Marshal.load( Marshal.dump(self) )
			
			
		end
		
		def duplicate
			morpion = Morpion.new
			
			morpion.possible_moves = @possible_moves.clone
			morpion.board = @board.clone
			morpion.taken_moves = @taken_moves.clone
			
			morpion
		end

		def rotate_move_clock

		end

		def pop_loose_moves
			pop_moves find_loose_moves
		end

		def pop_moves moves
			moves.each {|move| pop_move move}
			moves
		end

		def pop_move move

#			puts "POPPING: #{move}"

			loose_moves = find_loose_moves

			if loose_moves.include? move
				@taken_moves.delete move

				#each point in the line of the move we are about to make
				move.line.points.each do |point|
					index = point_index point.x,point.y
#					before = @board[index]
					@board[index] &= ~@mask_dir_map[move.line.dir]
#					puts "#{point} before: #{before.to_s(2).rjust(5,'0')} after: #{@board[index].to_s(2).rjust(5,'0')}"
				end

#				# correct first point if removed an index belonging to another line
#				start_point  = move.line.start_point
#				prev_start_point = move.line.start_point.prev move.line.dir
#				if point_dir? prev_start_point.x, prev_start_point.y, move.line.dir
#					previous_logical_line = move.line.previous_logical_line
#					overlap_move = @taken_moves.find{|taken_move| taken_move.line === previous_logical_line}
#					set_point_dir start_point.x, start_point.y, move.line.dir if overlap_move
#				end
#
#				# correct last point if removed an index belonging to another line
#				end_point  = move.line.end_point
#				next_end_point = move.line.end_point.next move.line.dir
#				if point_dir? next_end_point.x, next_end_point.y, move.line.dir
#					next_logical_line = move.line.next_logical_line
#					overlap_move = @taken_moves.find{|taken_move| taken_move.line === next_logical_line}
#					set_point_dir end_point.x, end_point.y, move.line.dir if overlap_move
#				end

				@taken_moves.each do |taken_move|
					if move.line.dir == taken_move.line.dir
						taken_move.line.points.each do |point|
							set_point_dir point.x, point.y, move.line.dir
						end
					end
				end

				adding_moves = find_moves_add move

				adding_moves << move

				# search previous points in line direction to remove moves
				search_line = move.line
				(0..2).each do
					search_line = search_line.previous_line
					if possible_move = eval_line(search_line)
						adding_moves << possible_move
					end

				end

				# search next points in line direction to remove moves
				search_line = move.line
				(0..2).each do

					search_line = search_line.next_line
					if possible_move = eval_line(search_line)
						adding_moves << possible_move
					end

				end

				@possible_moves += adding_moves

				@possible_moves.uniq!


				@possible_moves.delete_if do |possible_move|
					b = !(eval_line possible_move.line)

#					if possible_move.x == -2 && possible_move.y == 5
#						puts "HERE: #{eval_line possible_move.line}"
#					end

#					if b
#						puts "removing possible_move: #{possible_move}"
#					end
					b
				end

			else
				puts "Popping move that is not a loose move"
			end
			

			move


		end



		def find_loose_moves
			point_used_index = {}
			loose_moves = @taken_moves.find_all do |taken_move|
				

				taken_move.line.points.each do |point|
					c = point_used_index[point]
					point_used_index[point] = 0 if !c
					point_used_index[point] += 1
				end

				v = @board[point_index taken_move.x,taken_move.y]
				v == 2 || v == 4 || v == 8 || v == 16
			end

			loose_moves.delete_if do |loose_move|
				point_used_index[Point.new(loose_move.x,loose_move.y)] > 1
			end

			loose_moves

		end

		def rotate_clock

			morpion = Morpion.new

			@taken_moves.each do |taken_move|

#				puts " original: #{taken_move}"

				taken_move.x -= 4.5
				taken_move.y -= 4.5
				taken_move.line.x -= 4.5
				taken_move.line.y -= 4.5

				taken_move.x , taken_move.y = -taken_move.y , taken_move.x
				taken_move.line.x , taken_move.line.y = -taken_move.line.y , taken_move.line.x

				taken_move.x += 4.5
				taken_move.y += 4.5
				taken_move.line.x += 4.5
				taken_move.line.y += 4.5

				taken_move.x = taken_move.x.to_i
				taken_move.y = taken_move.y.to_i
				taken_move.line.x = taken_move.line.x.to_i
				taken_move.line.y = taken_move.line.y.to_i

				taken_move.line.dir = CLOCK_ROTATE_DIRS[taken_move.line.dir]

#				puts " rotate: #{taken_move} #{morpion.possible_moves.include? taken_move}"
				if !morpion.possible_moves.include? taken_move
#					puts "  #{taken_move.line}"
					4.times do
						taken_move.line = taken_move.line.previous_line
					end
#					puts "  #{taken_move.line}"
				end

#				puts "  final: #{taken_move}"

				morpion.make_move taken_move
			end

			@possible_moves = morpion.possible_moves
			@board = morpion.board
			@taken_moves = morpion.taken_moves

		end
		
		def remove_move_search min_score_accept


			taken_move_index = {}

			@taken_moves.each do |taken_move|
				taken_move_index[taken_move] = true
			end

			builder = Morpion2::Morpion.new

			taboo_moves = {}

			improvements = []
			
			index = {}
			
			morpion_dna = generate_dna
			
			while builder.possible_moves.length > 0
				poss_moves = builder.possible_moves.find_all do |possible_move|
					!taboo_moves[possible_move]
				end

				used = 0

				poss_moves.sort_by{|move| [move.x, move.y, move.line.x, move.line.y, Morpion2::DIRECTION_INDEX[move.line.dir]]}.each do |possible_move|
					if taken_move_index[possible_move]

						remove_moves = builder.find_moves_remove(possible_move) - [possible_move]

						remove_moves.each do |remove_move|
							time = 0
							while time < 2
								eval_dna = morpion_dna.clone
								index1 = dna_line_index remove_move.line
								index2 = dna_line_index possible_move.line

								eval_dna[index1], eval_dna[index2] = eval_dna[index2], eval_dna[index1]

								eval_morpion = Morpion2::Morpion.new
								eval_morpion.eval_dna eval_dna
								
								hash = eval_morpion.ordered_move_string_hash
								
								if eval_morpion.score >= min_score_accept && !index[hash]
#									puts " rms - #{used}: #{eval_morpion.score}"
									index[hash] = true
									improvements << eval_morpion
									time = 0
								end
								time += 1
							end
							
						end

						builder.make_move possible_move
						used += 1
					else
						taboo_moves[possible_move] = true

					end
				end

			end

			improvements
		end
		
		
		
		
		def proximity_end_search level_trials, min_score_accept
			
			improvements = []
			
			eval_morpion = self.duplicate
			
			
			
			index = {}
			
			min_score_accepted = 1000
			
			begin
				eval_morpion.pop_loose_moves
				
				high = eval_morpion.score
				low = eval_morpion.score
				
				counter = 0
				while counter < level_trials
					test_morpion = eval_morpion.duplicate

#					test_morpion.random_completion
					
					while !test_morpion.possible_moves.empty?
						if test_morpion.taken_moves.empty?
							test_morpion.make_random_move
						else
							last_move = test_morpion.taken_moves.last
							make_move = test_morpion.possible_moves.min_by do |possible_move|
									d = (possible_move.x - last_move.x)**2 + (possible_move.y - last_move.y)**2
									
									[d,rand]
							end
							test_morpion.make_move make_move
						end
					end
					
					
					hash = test_morpion.ordered_move_string_hash
					
					if test_morpion.score >= min_score_accept && !index[hash]
						index[hash] = true
						improvements << test_morpion
						counter = 0
						
						min_score_accepted = [eval_morpion.score,min_score_accepted].min
						
					end
					
					high = [test_morpion.score, high].max
					low = [test_morpion.score, low].min
					
					counter += 1
				end
			end while high > score - 10 && improvements.length < 20 && eval_morpion.score > 10
			
#			puts " e:low #{min_score_accepted} (#{(min_score_accepted.to_f/score()*100).round(2)})"
			
			improvements
		end
		
		def pure_add_end_search level_trials, min_score_accept
			
			improvements = []
			
			eval_morpion = self.duplicate
			
			
			
			index = {}
			
			min_score_accepted = 1000
			
			begin
				eval_morpion.pop_loose_moves
				
				high = eval_morpion.score
				low = eval_morpion.score
				
				counter = 0
				while counter < level_trials
					test_morpion = eval_morpion.duplicate

#					test_morpion.random_completion
					
					while !test_morpion.possible_moves.empty?
						if test_morpion.taken_moves.empty?
							test_morpion.make_random_move
						else
							last_move = test_morpion.taken_moves.last
							make_move = test_morpion.possible_moves.max_by do |possible_move|
									d = 1
									
									if test_morpion.find_moves_add(possible_move).length > 0
							
										d = 1000
									end
									
									[d,rand]
							end
							test_morpion.make_move make_move
						end
					end
					
					
					hash = test_morpion.ordered_move_string_hash
					
					if test_morpion.score >= min_score_accept && !index[hash]
						index[hash] = true
						improvements << test_morpion
						counter = 0
						
						min_score_accepted = [eval_morpion.score,min_score_accepted].min
						
					end
					
					high = [test_morpion.score, high].max
					low = [test_morpion.score, low].min
					
					counter += 1
				end
			end while high > score - 10 && improvements.length < 20 && eval_morpion.score > 10
			
#			puts " e:low #{min_score_accepted} (#{(min_score_accepted.to_f/score()*100).round(2)})"
			
			improvements
		end
		
		def end_search level_trials, min_score_accept
			
			improvements = []
			
			eval_morpion = self.duplicate2
			
			
			
			index = {}
			
			new_found = false
			
			min_pops = 10
			pops = 0
			
			begin
				eval_morpion.pop_loose_moves
				
				pops += 1
				
				high = eval_morpion.score
				low = eval_morpion.score
				
				counter = 0
				
				new_found = false
				
				while counter < level_trials
					test_morpion = eval_morpion.duplicate

					test_morpion.random_completion
					
					hash = test_morpion.ordered_move_string_hash
					
					if test_morpion.score >= min_score_accept && !index[hash]
						index[hash] = true
						improvements << test_morpion
						counter = 0
						new_found = true
					end
					
#					high = [test_morpion.score, high].max
#					low = [test_morpion.score, low].min
					high = test_morpion.score if test_morpion.score > high
					
					counter += 1
				end
#			end while high > score - 10 && improvements.length < 20 && eval_morpion.score > 10
#			end while high > score - 10 #&& eval_morpion.score > 10
			end while eval_morpion.score >= self.score * 0.4
			
#			puts " e:low #{min_score_accepted} (#{(min_score_accepted.to_f/score()*100).round(2)})"
			
			improvements
		end
		
		
		def quick_end_search min_score_accept
			
			improvements = []
			
			eval_morpion = self.duplicate
			
			
			
			begin
				eval_morpion.pop_loose_moves
				
				high = eval_morpion.score
				low = eval_morpion.score
				
				
				test_morpion = eval_morpion.duplicate

				test_morpion.random_completion

				hash = test_morpion.ordered_move_string_hash

				if test_morpion.score >= min_score_accept
					improvements << test_morpion
				end
				
				high = [test_morpion.score, high].max

			end while high > score - 10 && eval_morpion.score > 10
			
			improvements
		end
		
		def detailed_search min_accept
			
		end
		
		def drop_search min_score_accept

			
			improvements = []
			@taken_moves.each_with_index do |taken_move, move_index|
				dna = generate_dna

				dna[dna_line_index taken_move.line] = 0

				eval_morpion = Morpion2::Morpion.new
				eval_morpion.eval_dna dna

				
				if eval_morpion.score >= min_score_accept
					improvements << eval_morpion
#					puts " #{global_counter} (#{time}): #{move_index}. (#{index.length+1}) #{eval_morpion.score} #{eval_morpion.pack}"
				end


			end
			
			improvements

		end
		
		
	end
	
	

	

end
