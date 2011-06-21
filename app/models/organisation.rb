class Organisation < ActiveRecord::Base
#  has_and_belongs_to_many :activities

  has_many :activity_organisations
  has_many :funds_activity_organisations, :class_name => "ActivitiesOrganisation", 
              :conditions => {:rel_type => 1}
  has_many :extends_activity_organisations, :class_name => "ActivitiesOrganisation", 
              :conditions => {:rel_type => 2}
  has_many :implements_activity_organisations, :class_name => "ActivitiesOrganisation", 
              :conditions => {:rel_type => 3}


  has_and_belongs_to_many :activities


  has_many :funds,  :through => :funds_activity_organisations, :source => :activity
  has_many :extends,:through => :extends_activity_organisations,:source => :activity
  has_many :implements,:through => :implements_activity_organisations,:source => :activity

end

