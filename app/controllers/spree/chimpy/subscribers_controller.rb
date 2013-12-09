class Spree::Chimpy::SubscribersController < ApplicationController
  respond_to :html

  def create
    @subscriber = Spree::Chimpy::Subscriber.where(email: subscriber_params[:email]).first_or_initialize
    @subscriber.update_attributes(subscriber_params)
    if @subscriber.save
      Spree::Chimpy::Subscription.new(@subscriber).subscribe
      flash[:notice] = Spree.t(:success, scope: [:chimpy, :subscriber])
    else
      flash[:error] = Spree.t(:failure, scope: [:chimpy, :subscriber])
    end

    respond_with @subscriber, location: request.referer
  end

  private
    
    def subscriber_params
      params.require(:chimpy_subscriber).permit(:email, :subscribed)
    end
end
