class Activity < ActiveRecord::Base
	has_and_belongs_to_many :policy_markers
	has_and_belongs_to_many :sectors
	has_many :transactions
end
