require 'fileutils'
require 'yaml'

# I wrote this script to help me keep track of how much time I spent reseraching for a professor

class Project
	attr_accessor :history

	def initialize(project_name)
		@history = []
		@clock = "out"
		@timestamp = 
		@logs = []
		@name = project_name 
		@path = "/Users/martin/Desktop/#{@name}.txt"
	end 

	def clock_in
		if @clock == "in"
			puts "You are already clocked in."
		else 
			@clock = "in"
			@timestamp = Time.now 
			response = "Clock In  at #{@timestamp}"
			@history << response 
			puts response
		end 
		save 
	end 

	def clock_out
		if @clock == "out"
			puts "You are already clocked out."
		else 
			@clock = "out"
			co = Time.now 
			response = "Clock Out at #{co}"
			@history << response
			@logs << [@timestamp, co]
			puts response
			seconds = co - @timestamp
			puts "You worked a total of #{show_time(seconds)} hours"
		end 
		save 
	end 

	def status
		if @clock == "in"
			seconds = Time.now - @timestamp
			puts "You clocked in at #{@timestamp}"
			puts "You have been worked for #{show_time(seconds)} hours"
		else 
			puts "You are clocked out"
		end 
	end 

	def show_time(seconds)
		Time.at(seconds).utc.strftime("%H:%M:%S")
	end 

	def hrs_this_week
		today = Time.now
		sunday = today.yday - today.wday
		saturday = sunday + 6
		seconds = 0
		@logs.each do |log|
			seconds += (log[1] - log[0]) if log[0].yday.between?(sunday, saturday)
		end 
		puts show_time(seconds)
	end

	def hrs_last_week
		today = Time.now
		sunday = today.yday - today.wday - 7
		saturday = sunday + 6
		seconds = 0
		@logs.each do |log|
			seconds += (log[1] - log[0]) if log[0].yday.between?(sunday, saturday)
		end 
		puts show_time(seconds) 
	end 

	def total_hours 
		seconds = 0
		@logs.each do |log|
			seconds += (log[1] - log[0])
		end 
		puts show_time(seconds) 
	end

	def save
		File.open(@path, 'w').puts YAML.dump(self)
	end 

	def clear_logs
		FileUtils.rm(@path)
		puts "All Logs Deleted"
	end 
end 

def load_file(project)
	if Dir.entries('/Users/martin/Desktop').include? ("#{project}.txt")
		YAML.load(File.open("/Users/martin/Desktop/#{project}.txt", 'r').read)
	else
		File.open("/Users/martin/Desktop/#{project}.txt", 'a+')
		system "chflags hidden ~/Desktop/#{project}.txt"
		Project.new(project)
	end 
end 


def actions(argument, project, *args)
	foo = load_file(project)
	case argument 
	when 'in' then foo.clock_in
	when 'out' then foo.clock_out
	when 'hrs_this_week' then foo.hrs_this_week
	when 'total_hours' then foo.total_hours
	when 'hrs_last_week' then foo.hrs_last_week
	when 'status' then foo.status
	when 'clear_logs' then foo.clear_logs
	else
		puts "Unknown Argument"
	end 
end 

actions(*ARGV)


