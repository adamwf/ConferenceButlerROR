class Ability < ActiveRecord::Base
	include CanCan::Ability

	def initialize(admin_user)
	    case admin_user.role
	      when 'corporate-user'
	        can :read, ActiveAdmin::Page, :name => "Dashboard"
	        # can :manage, Adds
	        # can :manage, Trending
	        # can :manage,Shop
	        # can :manage,Discover
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
	  #     when 'Mover'
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
