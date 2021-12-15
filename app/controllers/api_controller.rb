class ApiController < ApplicationController
    before_action :authenticate_user!
    protect_from_forgery with: :null_session
  
    def index
      @post = Post.new
      render json: timeline_posts
    end
    def create
      @post = current_user.posts.new(post_params)
  
      if @post.save
        redirect_to posts_path, notice: 'Post was successfully created.'
      else
        timeline_posts
        render :index, alert: 'Post was not created.'
      end
    end
    def show_comment
        @post_comments = Post.find(params[:post_id]).comments
        render json: @post_comments
      end

      def create_comment
        @comment = Comment.new(comment_params)
        @comment.post_id = params[:post_id]
        @comment.user = User.find(params[:user_id])
        render json: @comment
    
        if @comment.save
          redirect_to posts_path, notice: 'Comment was successfully created.'
        else
          redirect_to posts_path, alert: @comment.errors.full_messages.join('. ').to_s
        end
      end

    private
  
    def timeline_posts
      @timeline_posts = current_user.posts
      current_user.friends.each do |friend|
        @timeline_posts += friend.posts.ordered_by_most_recent
      end
      @timeline_posts
    end
  
    def post_params
      params.require(:post).permit(:content)
    end
  end
  