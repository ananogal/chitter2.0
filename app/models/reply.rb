class Reply
   include DataMapper::Resource
 
   belongs_to :answer, 'Peep', :key => true
   belongs_to :target, 'Peep', :key => true
 end