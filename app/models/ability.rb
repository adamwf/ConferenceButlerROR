class Ability < ActiveRecord::Base
	include CanCan::Ability

	def initialize(admin_user)
	    case admin_user.role
	      when 'corporate-user'
	        can :read, ActiveAdmin::Page, :name => "Dashboard"
	        if admin_user.adds.eql?(true) 
	        	can :manage, Advertisement 
	        end
	        can :manage, Trending 
	        if admin_user.feeds.eql?(true)
		        can :manage,Post 
		        can :manage,Video
		    end
	      when 'super-admin'
	        can :manage, :all
	        cannot :destroy, AdminUser, id: 1 
	    end
  	end

  	# def initialize(user)
	  #   case user.role
	  #     when 'organizer'
	  #       can :read, ActiveAdmin::Page, :name => "Dashboard"
	  #       can :read, User
	  #       can :read,Package
	  #       can :read,HowUKnow
	  #       can :read,ContactU
	  #       can :read,Discount
	  #     when 'manager'
	  #       can :read, ActiveAdmin::Page, :name => "Dashboard"
	  #       can :manage, User
	  #       can :read,LocalMove
	  #       can :read,StudyAbroad
	  #       can :read,Package
	  #       can :read,HowUKnow
	  #       can :read,ContactU
	  #       can :read,Discount
	  #     when 'super-admin'
	  #       can :manage, :all
	  #       cannot :destroy, AdminUser, id: 1 
	  #   end
  	# end
end
