Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Authentication (Rails 8 generator)
  resource :session, only: %i[ new create destroy ]
  resource :registration, only: %i[ new create ]
  resources :passwords, param: :token

  # Đăng xuất qua GET (layout theme kh\u00f4ng n\u1ea1p Turbo nên data-turbo-method không hoạt động)
  get "logout", to: "sessions#destroy", as: :logout

  # Hồ sơ cá nhân
  get "profile", to: "profiles#show"

  # Defines the root path route ("/")
  root "pages#home"

  # Quản trị — yêu cầu role admin/superadmin
  namespace :admin do
    root to: "testimonials#index"
    resources :testimonials
    resources :posts
    resources :categories, except: [:show]
    resources :tags, except: [:show]
    resources :enrollments
    resources :lessons do
      member { patch :cancel }
    end
    resources :users, except: [:show]
    resource :settings, only: %i[edit update]
  end

  # Đặt lịch học — yêu cầu đăng nhập
  resources :teachers, only: %i[index show]
  resources :bookings, only: %i[index create destroy]
  resources :availabilities, only: %i[index new create edit update destroy]
  resources :busy_dates, only: %i[create destroy]

  # Trang Courses (template gốc dùng URL /services/)
  get "services", to: redirect("/courses")
  get "course-detail", to: redirect("/courses")
  resources :courses, param: :slug, only: [:index, :show]

  # Trang Products — sản phẩm đang bán (sheet nhạc, đàn piano cũ)
  resources :products, param: :slug, only: [:index, :show]

  get "blog", to: "posts#index"

  get "contact" => "pages#contact"

  get "pricing" => "pages#pricing"

  get "testimonials" => "pages#testimonials"

  # Endpoint form liên hệ (AJAX từ app/assets/javascripts/forms/app.js)
  post "api/contact-form/entries/insert/:form_id" => "pages#contact_form_submit"
  post "api/contact-form/forms/views/:form_id" => "pages#contact_form_view"

  # Permalink kiểu WordPress cho bài viết — đặt CUỐI để không che các route khác
  get "/:year/:month/:day/:slug",
      to: "posts#show",
      constraints: { year: /\d{4}/, month: /\d{1,2}/, day: /\d{1,2}/, slug: /[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/ },
      as: :dated_post
end
