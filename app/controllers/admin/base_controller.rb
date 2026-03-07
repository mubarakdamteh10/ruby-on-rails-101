module Admin
  class BaseController < ApplicationController
    before_action :ensure_admin!

    private

    def ensure_admin!
      unless admin?
        redirect_to sign_in_option_path, alert: "Access denied. Admin privileges required."
      end
    end
  end
end
