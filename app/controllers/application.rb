get '/' do
	@replies = Reply.all()
	@ids = []
	@replies.each {|replay| @ids << replay.answer_id }
	@peeps = Peep.all(:id.not => @ids ,:order => [:created_at.desc])
	erb :index
end