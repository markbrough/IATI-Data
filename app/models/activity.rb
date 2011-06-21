class Activity < ActiveRecord::Base
	has_and_belongs_to_many :policy_markers
	has_and_belongs_to_many :sectors
	has_many :transactions
	belongs_to :countryregion

	has_many :activity_organisations

	has_many :funding_activity_organisations, :class_name => "ActivitiesOrganisation", 
		      :conditions => {:rel_type => 1}

	has_many :extending_activity_organisations, :class_name => "ActivitiesOrganisation", 
		      :conditions => {:rel_type => 2}

	has_many :implementing_activity_organisations, :class_name => "ActivitiesOrganisation", 
		      :conditions => {:rel_type => 3}

	has_and_belongs_to_many :organisations

	has_many :funding_organisations,  :through => :funding_activity_organisations, :source => :organisation
	has_many :extending_organisations,:through => :extending_activity_organisations,:source => :organisation
	has_many :implementing_organisations,:through => :implementing_activity_organisations,:source => :organisation

end
