class Spree::Chimpy::SubscribersController < ApplicationController
  respond_to :html, :json

  def create
    @subscriber = Spree::Chimpy::Subscriber.where(email: subscriber_params[:email]).first_or_initialize
    @subscriber.email = subscriber_params[:email]
    @subscriber.subscribed = subscriber_params[:subscribed]
    is_subscribed = Spree::Chimpy::Subscriber.subscriber_exist?(@subscriber.email)
    if @subscriber.save && is_subscribed
      flash[:notice] = Spree.t(:success, scope: [:chimpy, :subscriber])
    else
      error_message = if !is_subscribed
        Spree.t(:email_available, scope: [:chimpy, :subscriber])
      else
        if !@subscriber.email?
          Spree.t(:email_not_enter, scope: [:chimpy, :subscriber])
        else
          Spree.t(:failure, scope: [:chimpy, :subscriber])
        end
      end
      flash[:error] = error_message
    end
    referer = request.referer || root_url # Referer is optional in request.
    redirect_to referer
  end

  private

    def subscriber_params
      params.require(:chimpy_subscriber).permit(:email, :subscribed)
    end
end
