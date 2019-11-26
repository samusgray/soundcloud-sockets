class User
  def initialize id
    @id        = id
    @followers = Set.new
  end

  attr_reader :id, :followers

  def register_follower user_id
    puts "register_follower"
    puts user_id
    @followers.add?(user_id)
  end

  def unregister_follower user_id
    @followers.delete(user_id)
  end
end
