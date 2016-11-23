module MatchesHelper
  def opponent_name(match)
    if current_user == match.home_contender
      return match.visitor_contender.name
    end
    match.home_contender.name
  end

  def match_score(match)
    default_score = [match.home_contender_score, match.visitor_contender_score]
    if current_user == match.home_contender
      return default_score.join('-')
    end
    return default_score.reverse.join('-')
  end

  def match_result(match)
    match.result_by_requester current_user == match.home_contender ? :home : :visitor
  end
end
