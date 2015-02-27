require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every "30m" do
	Typetorealsize.update
	puts "Typetorealsize updated!"
end