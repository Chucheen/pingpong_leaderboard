class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :trackable, :validatable
  validates :name, presence: true
  before_save :set_default_score
  has_many :home_matches, class_name: 'Match', foreign_key: 'home_contender_id'
  has_many :visitor_matches, class_name: 'Match', foreign_key: 'visitor_contender_id'

  def games_played
    home_matches.length + visitor_matches.length
  end

  def matches
    (home_matches + visitor_matches).sort_by(&:date_and_time)
  end

  private
  def set_default_score
    return unless new_record?
    self.score = 10
  end
end
