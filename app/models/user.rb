class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships, class_name: 'Friendship', foreign_key: 'sender_id'
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'receiver_id'

  has_many :confirmed_friendships, -> { where status: true }, class_name: 'Friendship', foreign_key: 'sender_id'
  has_many :friends, through: :confirmed_friendships, source: :receiver

  has_many :pending_requests, -> { where status: false }, class_name: 'Friendship', foreign_key: 'sender_id'
  has_many :pending_friends, through: :pending_requests, source: :receiver

  has_many :inverted_friendships, -> { where status: false }, class_name: 'Friendship', foreign_key: 'receiver_id'
  has_many :friend_requests, through: :inverted_friendships, source: :sender

  def send_request(user)
    friendships.create(sender_id: id, receiver_id: user.id) unless Friendship.requested_before?(id, user.id)
  end

  def confirm_request(user)
    friendship = inverse_friendships.find { |fs| fs.sender == user }
    friendships.create(sender_id: user.id, receiver_id: user.id, status: true)
    friendship.status = true
    friendship.save
  end

  def reject_request(user)
    friendship = inverse_friendships.find { |fs| fs.sender == user }
    friendship.destroy
  end

  def friend?(user)
    friends.include?(user)
  end
end
