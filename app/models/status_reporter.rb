class StatusReporter

  def self.outgoing(user, other_user)
    # user as the follower - follows/requested/none
    if other_user.requested_by?(user)
      "requested"
    elsif user.following?(other_user)
      "follows"
    else
      "none"
    end
  end

  def self.incoming(user, other_user)
    # user as the followed - followed_by/requested_by/none
    if user.requested_by?(other_user)
      "requested_by"
    elsif other_user.following?(user)
      "followed_by"
    else
      "none"
    end
  end

end