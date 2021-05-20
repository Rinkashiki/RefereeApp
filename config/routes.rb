Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'session#welcome'

  # Routes for session
  get 'login', to: 'session#new'

  post 'login', to: 'session#create'

  get 'welcome', to: 'session#welcome'

  get 'index', to: 'session#index'

  # Routes for users 
  resources :users, only: [ :new, :create, :index, :edit, :update, :show, :destroy]

  # Routes for images
  resources :images, only: [ :index, :new, :create, :show]

  # Routes for clips
  resources :clips, only: [ :new, :create, :index, :show, :edit, :update, :destroy]

  get 'clips/:id/add_topic', to: 'clips#add_topic', as: 'add_topic'

  get 'clips/:id/add_topic_post', to: 'clips#add_topic_post', as: 'add_topic_post'

  get 'clips/:id/quit_topic', to: 'clips#quit_topic', as: 'quit_topic'

  get 'clips/:id/quit_question', to: 'clips#quit_question', as: 'quit_question'

  get 'clips/:id/edit_decision', to: 'clips#edit_decision', as: 'edit_decision'

  get 'clips/:id/edit_sanction', to: 'clips#edit_sanction', as: 'edit_sanction'

  post 'clips/:id/update_decision', to: 'clips#update_decision', as: 'update_decision'

  post 'clips/:id/update_sanction', to: 'clips#update_sanction', as: 'update_sanction'

  # Routes for topics
  resources :topics, only: [ :new, :create, :index, :edit, :update, :show, :destroy]

  # Routes for activities
  resources :activities, only: [ :index, :new, :create, :edit, :update, :show, :destroy]

  get 'activities/:id/activity_questions', to: 'activities#activity_questions', as: 'activity_questions'

  get 'activities/:id/quit_activity_question', to: 'activities#quit_activity_question', as: 'quit_activity_question'

  get 'activities/:id/activity_users', to: 'activities#activity_users', as: 'activity_users'

  get 'activities/:id/add_activity_user', to: 'activities#add_activity_user', as: 'add_activity_user'

  get 'activities/:id/add_activity_user_post', to: 'activities#add_activity_user_post', as: 'add_activity_user_post'

  get 'activities/:id/quit_activity_user', to: 'activities#quit_activity_user', as: 'quit_activity_user'

  get 'activities/:id/edit_activity_user', to: 'activities#edit_activity_user', as: 'edit_activity_user'

  post 'activities/:id/update_activity_user', to: 'activities#update_activity_user', as: 'update_activity_user'

  # Routes for activities_users
  resources :activities_users, only: [ :index]

  get 'activities_users/doing_activity', to: 'activities_users#doing_activity', as: 'doing_activity'

  post 'activities_users/doing_activity_post', to: 'activities_users#doing_activity_post', as: 'doing_activity_post'

  get 'activities_users/finish_activity', to: 'activities_users#finish_activity', as: 'finish_activity'

  get 'activities_users/reset_activity', to: 'activities_users#reset_activity', as: 'reset_activity'

  # Routes for questions
  resources :questions, only: [:index, :new, :create, :show]

  get 'questions/:id/add_activity_question', to: 'questions#add_activity_question', as: 'add_activity_question'

  get 'questions/:id/add_clip_question', to: 'questions#add_clip_question', as: 'add_clip_question'

  # Routes for answers
  resources :answers, only: [:index, :new, :create, :show, :destroy]

  # Routes for evaluation
  resources :evaluation, only: [ :index]

  get 'evaluation/results', to: 'evaluation#results', as: 'results'  

  get 'evaluation/user_results', to: 'evaluation#user_results', as: 'user_results'
  
end
