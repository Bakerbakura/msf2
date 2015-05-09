require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every "30m", first_at: Time.now + 2 * 60 do |job|
		# runs job every 30 minutes, beginning in two minutes' time.
	Typetorealsize.update
end