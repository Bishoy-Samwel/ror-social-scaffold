class ApiController < ActionController::API
    # protect_from_forgery with: :null_session
  
    def posts_index
      render json: timeline_posts
    end

    def show_comments
      @post_comments = Post.find(params[:post_id]).comments
      render json: @post_comments
    end

    def create_comment
      @comment = Comment.create(comment_params)
      render json: @comment
      if @comment.save
        render json: @comment
        # redirect_to posts_path, notice: 'Comment was successfully created.'
      else
        puts "not saving"
        # redirect_to posts_path, alert: @comment.errors.full_messages.join('. ').to_s
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

    def comment_params
      params.permit(:content, :user_id, :post_id)
    end
  end
  