class SiteController < ApplicationController

def index
	@banked_hours = total_bank_hours # This calls method in application_controller to calculate total site hours exchanged. This number can then be displayed on site index page.
end 

def about 
end

def contact
end

end
