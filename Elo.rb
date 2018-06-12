#Elo.rb

# Elo system for maintaining ratings of class objects relative to each other. 

# K, or the Kfactor, is the constant used to determine how much a rating should sway. 
# Lower numbers are going to give ratings that are closer together, each rating
# point means more. A higher Kfactor will devalue(inflate) each individual rating point.


def Elo(white, black, result, m = 4)
	# m represents the number of games a person played in a tournament
	# When the USCF released a chart displaying the estimated K based on rating
	# they assumed 4 games per tournament. In playing only one game, rather than a tournament 
	# It will create a large distribution of Elos if m only ever equals 1. 

	# TODO Possible solution would be to only calculate Elo's once a week, rather than after
	# each game. Think it over. 
	def k_factor(player, m)
		def effective_games(player, num_games)
			num_games > 50 ? n = 50 : n = num_games
			player.rating > 2355 ? n_r = 50 : n_r = (50.0 / Math.sqrt(0.662 + (0.00000739 * ((2569 - player.rating) ** 2))))
			n > n_r ? n_e = n_r : n_e = n 
			n_e
		end 
		num_games = m + player.num_games
		k = 800 / (effective_games(player, num_games) + m )
		k
	end 

	win_loss = { 
		"1-0" => [1, 0],
		"0-1" => [0, 1],
		"1/2-1/2" => [0.5, 0.5],
	}
	result = win_loss[result]

	expect_w = (1.0/(1.0+(10.0**((black.rating-white.rating)/400.0)))) #Probability of winning (pow) for white
	expect_b = (1.0/(1.0+(10.0**((white.rating-black.rating)/400.0))))
	white.rating = white.rating + (k_factor(white, m)*(result[0] - expect_w)) 	#Adjust the winners Elo
	black.rating = black.rating + (k_factor(black, m)*(result[1] - expect_b))	#Adjust the losers Elo
end 


# The class object using the Elo system must have a base rating initialized, and allow
# the attribute to be edited
class Player
	attr_accessor :rating, :num_games
	def initialize
		@rating = 800.0
		@num_games = 20
	end 
end 

martin = Player.new 
jack = Player.new 

puts martin.rating  		# => 800
puts jack.rating    		# => 800

# Elo(white, black, result)
Elo(martin, jack, "1-0")	
puts "Martin Wins"		
puts martin.rating.round	# => 812
puts jack.rating.round 		# => 788

