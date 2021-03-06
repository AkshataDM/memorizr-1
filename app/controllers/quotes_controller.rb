class QuotesController < ApplicationController

  before_filter :authenticate_user!, except: :create

  protect_from_forgery except: :create

  def create
    user = User.find_by_submit_token(params[:token])
    @note = Quote.create_with_page(quote_params(user: user))
    redirect_to params[:url]
  rescue ActiveRecord::RecordInvalid
    flash[:alert] = $!.to_s
  end

  def update
    @note = Quote.find(params[:id])
    unless @note.mine?(current_user)
      raise Exceptions::UserNotAuthorized, 'Unauthorized!'
    end
    @note.update_attribute(:body, params[:body])
    render nothing: true
  rescue Exceptions::UserNotAuthorized, ActiveRecord::RecordInvalid
    render text: $!.to_s
  end

private

  def quote_params(args={})
    params.permit(:body, :url, :page).merge(args)
  end
end
