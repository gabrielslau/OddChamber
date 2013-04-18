# 
# Gera o código a ser inserido no mapa
# 

tilesize = 32
screen_width = 1024
screen_height = 640

# 1 tela
# wireframe = [
# 	[ (0..(screen_width*3)).to_a, 0 ],
# 	[ (0..(screen_width*3)).to_a, screen_height ],
# 	[ (screen_width..(screen_width*2)).to_a, screen_height*2 ],
# 	[ 0, (0..screen_height).to_a ],
# 	[ screen_width, (0..(screen_height*2)).to_a ],
# 	[ screen_width*2, (0..(screen_height*2)).to_a ],
# 	[ screen_width*3, (0..screen_height).to_a ]
# ]

# 2 tela
wireframe = [
	[ ((screen_width+32)..1792).to_a, tilesize * 5 ],
	[ ((screen_width+32)..1792).to_a, tilesize * 6 ],
	[ ((screen_width+32)..1792).to_a, tilesize * 7 ],
	[ ((screen_width+32)..1792).to_a, tilesize * 8 ],
	[ ((screen_width+32)..1792).to_a, tilesize * 9 ],
	[ ((screen_width+32)..1792).to_a, tilesize * 10 ]
]

for quadrante in wireframe do

	truncate_x = if(quadrante.first.kind_of?(Array)) then false else true end
	truncate_y = not(truncate_x)

	sequencia = if truncate_x then quadrante.last else quadrante.first end

	for index in sequencia do
		if index % tilesize == 0 then
			
			index_x = if truncate_x then quadrante.first else index end
			index_y = if truncate_y then quadrante.last else index end

			puts '- BlockBlack:'
			puts "    :x: #{index_x.to_f}"
		    puts "    :y: #{index_y.to_f}"
		    puts '    :angle: 0'
		    puts '    :zorder: 100'
		    puts '    :factor_x: 1'
		    puts '    :factor_y: 1'
		    puts '    :alpha: 255'
		end
	end
end