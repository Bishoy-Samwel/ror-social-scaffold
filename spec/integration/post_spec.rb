require 'swagger_helper'

describe 'Posts API' do

  path '/getPosts' do

    post 'Show all POsts' do
      tags 'Posts'
      consumes 'application/json', 'application/xml'
      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string },
          id: {type: number},
          user_id: {type: number},
          created_at: {type: date},
          update_at: {type: date}
        },
        required: [ 'content' ]
      }

      response '201', 'post listed' do
        let(:post) { Post.all }
        run_test!
      end

      response '422', 'invalid request' do
        let(:post) { { 'invalid' }
        run_test!
      end
    end
  end
