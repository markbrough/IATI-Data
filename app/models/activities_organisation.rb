class ActivitiesOrganisation < ActiveRecord::Base

  belongs_to :activity
  belongs_to :organisation

end
