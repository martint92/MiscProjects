require 'securerandom'
require 'digest'

#This was a proof of concept program I wrote to make sure I understood how blockchain works. 

class Block
	attr_reader :hash, :timestamp, :previous_hash, :data
	def initialize(data, previous_hash = "0")
		@data = data
		@timestamp = Time.now
		@nonce = SecureRandom.hex(16).to_i
		@hash = calculate_hash
		@previous_hash = previous_hash
	end 

	def calculate_hash
		string = "#{@nonce}#{@data}#{@timestamp}#{@previous_hash}"
		Digest::SHA256.hexdigest string
	end

	def mine_block(difficulty)
		while @hash[0..difficulty] != ('0' * (difficulty + 1))
			@nonce += 1
			@hash = calculate_hash
		end 
	end 
end 

class BlockChain
	attr_reader :difficulty, :mining_reward, :chain
	attr_accessor :pending_transactions

	def initialize(difficulty = 4)
		@chain = [create_genesis_block]
		@difficulty = difficulty
		@pending_transactions = []
		@mining_reward = 100
	end 

	def show
		return "Blockchain invalid." unless valid? 
		data_array = []
		@chain[1..(@chain.length - 1)].each {|block| data_array << block.data}
		data_array
	end

	def create_genesis_block
		Block.new([])
	end 

	def last
		@chain[@chain.length - 1]
	end 

	def previous_hash
		last.hash 
	end 

	def add_block(data)
		new_block = Block.new(data, previous_hash)
		new_block.mine_block(@difficulty)
		@chain << new_block
	end

	def valid?
		@chain[1..(chain.length - 1)].each do |block|
			block_index = @chain.index(block)
			previous_block = @chain[block_index-1]
			return false if block.hash != block.calculate_hash
			return false if previous_block.hash != block.previous_hash
		end
		true
	end 
end


bc = BlockChain.new
bc.add_block("my string")
bc.add_block("your string")
bc.add_block("something else")

puts bc.show













