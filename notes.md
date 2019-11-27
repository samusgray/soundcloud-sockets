Research:
- Ruby threads
- Brief scala intro

Ideas:
  * cap and lower case of string matching
  *


Objects:

* Message
    payload: 666|F|60|50
    sequence: 666
    type: Follow
    sender: 60
    recipient: 50





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
