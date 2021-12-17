require 'swagger_helper'

RSpec.describe 'api/api', type: :request do
  path '/comments/{post_id}' do

    get 'Retrieves a blog' do
      tags 'Blogs', 'Another Tag'
      produces 'application/json', 'application/xml'
      parameter name: :id, in: :path, type: :string

      response '200', 'blog found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            title: { type: :string },
            content: { type: :string }
          },
          required: [ 'id', 'title', 'content' ]

        let(:id) { Blog.create(title: 'foo', content: 'bar').id }
        run_test!
      end

      response '404', 'blog not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end
  end
















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
end


