require 'swagger_helper'

RSpec.describe 'api/api', type: :request do
  path '/comments/{post_id}' do

    get 'Retrieves a Comment' do
      tags 'Comments', 'Another Tag'
      produces 'application/json', 'application/xml'
      parameter name: :id, type: :string

      response '200', 'Comment found' do
        schema type: :object,
          properties: {
            content: { type: :string },
            post_id: {type: :integer},
            user_id: {type: :integer},
            created_at: {type: :date},
            update_at: {type: :date}
          },
          required: [ 'id', 'user_id', 'post_id', 'content', 'created_at', 'updated_at' ]

        let(:id) { Comment.create(id: 2, user_id: 1, post_id: 1, content: "sdsds", created_at: "2021-12-15 12:25:17.388417000", updated_at: "2021-12-15 12:25:17.388417000").id }
        run_test!
      end

      response '404', 'Comment not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

  path 'comments/add/{user_id}/{post_id}/{content}' do
    post 'Create a Comment' do
      tags 'Comments'
      consumes 'application/json', 'application/xml'
      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string },
          post_id: {type: :integer},
          user_id: {type: :integer},
          created_at: {type: :date},
          update_at: {type: :date}
        },
        required: [ 'content' ]
      }

      response '201', 'post listed' do
        let(:comment) { { content: 'new content' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:comment) { { name: 'old content' } }
        run_test!
      end
    end
  end
end
end
