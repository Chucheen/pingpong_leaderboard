class Match < ActiveRecord::Base
  belongs_to :home_contender, class_name: 'User', foreign_key: 'home_contender_id'
  belongs_to :visitor_contender, class_name: 'User', foreign_key: 'visitor_contender_id'

  validates :date_and_time, presence: true
  validates :home_contender, :visitor_contender, presence: true
  validates :your_score, :their_score, presence: true
  validate :score_valid?
  before_save :update_scores

  def result_by_requester(type)
    if type == :home
      return your_score > their_score ? 'W' : 'L'
    end
    return your_score > their_score ? 'L' : 'W'
  end

  private
  def score_valid?
    return unless your_score.present? && their_score.present?
    if your_score != 21 && their_score != 21
      errors.add(:base, 'One contender should have 21 points')
    end

    if your_score == 21 && their_score == 21
      errors.add(:base, 'Only one contender can have 21 points')
    end

    valid_values = 0..21
    if !valid_values.include?(your_score) || !valid_values.include?(their_score)
      errors.add(:base, 'The only valid values goes from 0 to 21')
    end
  end

  def your_score
    home_contender_score
  end

  def their_score
    visitor_contender_score
  end

  def update_scores

    home_rating = home_contender.score
    visitor_rating = visitor_contender.score

    #k_value = home_rating < 2400 && visitor_rating < 2400 ? 32 : home_rating
    k_value = 32 unless k_value

    home_result = result_by_requester(:home) == 'W' ? 1 : 0
    visitor_result = 1 - (result_by_requester(:visitor) == 'W' ? 0 : 1)
    #Calculate expected results
    home_expectation = 1/(1+10**((visitor_rating - home_rating)/400.0)) #the .0 is important to force float operations!))
    visitor_expectation = 1/(1+10**((home_rating - visitor_rating)/400.0))

    #Calculate new ratings
    home_new_rating = home_rating + (k_value*(home_result - home_expectation))
    visitor_new_rating = visitor_rating + (k_value*(visitor_result - visitor_expectation))

    home_new_rating = home_new_rating.round
    visitor_new_rating = visitor_new_rating.round

    home_contender.score = home_new_rating
    visitor_contender.score = visitor_new_rating

    home_contender.save
    visitor_contender.save

  end
end
