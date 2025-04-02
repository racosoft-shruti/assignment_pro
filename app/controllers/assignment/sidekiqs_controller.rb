class Assignment::SidekiqsController < ApplicationController

  def activation_of_users
    user_id = params[:user_id]
    Sidekiq::ActivateUsersJob.perform_async(user_id)
  end
end
