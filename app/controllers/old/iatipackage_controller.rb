class IatipackageController < ApplicationController

  def getPackage
    @package = Package.find(params[:id])
    
  end

end
