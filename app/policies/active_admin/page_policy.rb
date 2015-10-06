module ActiveAdmin
  class PagePolicy < ApplicationPolicy
    def show?
      case record.name
      when "Dashboard"
        user.is_admin?
      else
        false
      end
    end
  end
end
