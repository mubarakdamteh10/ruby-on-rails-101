Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "sign-in-option", to: "sessions#index", as: :sign_in_option
  post "sign-in", to: "sessions#create", as: :sign_in
  delete "sign_out", to: "sessions#destroy", as: :sign_out

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin do
    resources :employees, controller: "/employee"
    get "showAll", to: "/employee#show_all", as: :show_all_employees

    resources :attendances, only: [ :index ], controller: "/attendances"
    get "attendance/:code", to: "/attendances#show", as: :employee_attendance
    post "attendance/:code/check_in", to: "/attendances#check_in", as: :check_in_attendance
    patch "attendance/:code/check_out", to: "/attendances#check_out", as: :check_out_attendance

    resources :payroll, only: [ :index ], controller: "/payroll" do
      collection do
        post :calculate
      end
    end
    root to: "/employee#show_all"
  end

  scope :salary do
  get "salary_calculator", to: "salary#calculator", as: :salary_calculator
  end

  # Employee restricted routes (non-namespaced)
  scope :attendances do
    get ":code", to: "attendances#show", as: :employee_attendance
    post ":code/check_in", to: "attendances#check_in", as: :check_in_attendance
    patch ":code/check_out", to: "attendances#check_out", as: :check_out_attendance
  end

  root "sessions#index"
end
