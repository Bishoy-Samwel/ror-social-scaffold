require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'ActiveRecord associations' do
    it 'belongs to user' do
      expect { should belongs_to(user) }
    end
    it 'belongs to post' do
      expect { should belongs_to(post) }
    end
  end
end