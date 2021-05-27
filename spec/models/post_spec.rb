require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Validation' do
    it 'Content can not be empty' do
      expect { should validate_presence_of(:content) }
    end
  end

  describe 'ActiveRecord associations' do
    it 'has many comments' do
      expect { should has_many(comments) }
    end
    it 'has many likes' do
      expect { should has_many(likes) }
    end
  end
end
