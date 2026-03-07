class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user_role, :admin?, :employee?, :current_employee

  def current_user_role
    session[:role]
  end

  def admin?
    current_user_role == "admin"
  end

  def employee?
    current_user_role == "employee"
  end

  def current_employee
    @current_employee ||= Employee.find_by(code: session[:employee_code]) if session[:employee_code]
  end
end
