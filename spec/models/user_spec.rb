require 'rails_helper'
require 'faker'

RSpec.describe User, type: :model do
  let(:u1) { User.create(name: 'Bishoy', email: 'Bishoy@gmail.com', password: '246888') }
  let(:u2) { User.create(name: 'Felix', email: 'Felix@gmail.com', password: '246888') }

  it 'Sends a friend request to a another user' do
    u1.send_request(u2)
    expect(Friendship.where(sender_id: u1.id, receiver_id: u2.id).exists?).to eql(true)
  end

  it 'Returns list of pending requests' do
    u1.send_request(u2)
    pending_request = u1.pending_friends.find { |item| item[:id] == u2.id }

    expect(pending_request.nil?).to eql(false)
  end

  it 'Returns list of friend requests' do
    u1.send_request(u2)
    pending_request = u2.friend_requests.find { |item| item[:id] == u1.id }

    expect(pending_request.nil?).to eql(false)
  end

  it 'Confirms the friend request and add the user to friends list!' do
    u1.send_request(u2)
    u2.confirm_request(u1)

    expect(u2.friends.find { |item| item[:id] == u1.id }.nil?).to eql(false)
    expect(u1.friends.find { |item| item[:id] == u2.id }.nil?).to eql(false)
  end

  describe 'ActiveRecord associations' do
    it 'has many posts' do
      expect { should has_many(posts) }
    end
    it 'has many comments' do
      expect { should has_many(comments) }
    end
    it 'has many likes' do
      expect { should has_many(likes) }
    end
    it 'has many  confirmed friendship' do
      expect { should has_many(confirmed_friendships) }
    end
    it 'has many friends' do
      expect { should has_many(friends) }
    end
    it 'has many inverse_friendships' do
      expect { should has_many(friend_requests).with_foreign_key }
    end
  end
end
