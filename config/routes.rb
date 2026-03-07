Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  resources :employees, controller: "employee"
  get "showAll", to: "employee#show_all", as: :show_all_employees

  resources :attendances, only: [ :index ]
  get "attendances/:code", to: "attendances#show", as: :employee_attendance
  post "attendances/:code/check_in", to: "attendances#check_in", as: :check_in_attendance
  patch "attendances/:code/check_out", to: "attendances#check_out", as: :check_out_attendance

  root "employee#show_all"
end
