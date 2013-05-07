class Status < ActiveRecord::Base
	attr_accessible :user_id, :required_amount, :amount_raised, :by_date, :met, :comments
	belongs_to :user
end
