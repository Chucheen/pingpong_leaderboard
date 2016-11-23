class MatchesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all.order(score: :desc)
  end

  def new
    @match = Match.new
  end

  def create
    @match = Match.new(match_parameters.merge(home_contender_id: current_user.id))
    if @match.save
      flash[:notice] = "Match saved"
      redirect_to root_path
    else
      flash.now[:error] = @match.errors.to_a
      render 'new'
    end
  end

  def history
    @matches = current_user.matches.sort_by(&:date_and_time).reverse
  end

  def match_parameters
    params.require(:match).permit(
        :date_and_time,
        :visitor_contender_id,
        :home_contender_score,
        :visitor_contender_score
    )
  end

end
