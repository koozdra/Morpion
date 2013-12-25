#!/usr/bin/env ruby


require '../lib/Morpion2'


puts "Sixty second searches starting with a random grid."


while true
	
	morpion = Morpion2::Morpion.new
	morpion.random_completion

	start = Time.new

	iteration = 0

	elapsed = 0
	
	while elapsed < 60
		dna = morpion.generate_dna

		3.times do
			dna[morpion.dna_line_index morpion.taken_moves.sample.line] = -1
		end


		eval_morpion = Morpion2::Morpion.new
		eval_morpion.eval_dna dna

		if eval_morpion.score > morpion.score
			now = Time.new
			elapsed = now-start
			puts "#{iteration}. #{eval_morpion.score} (#{elapsed.round(2)}) #{eval_morpion.pack}"
		end

		if eval_morpion.score >= morpion.score
			morpion = eval_morpion
		end

		iteration += 1
		now = Time.new
		elapsed = now-start
		
		
	end
	puts "----------------------------------"
end