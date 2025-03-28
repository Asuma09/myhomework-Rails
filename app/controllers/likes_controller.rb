class LikesController < ApplicationController
    def create
      post = Post.find(params[:post_id])
      like = post.likes.find_or_create_by(user_id: params[:user_id])
  
      if like.persisted?
        render json: { success: true, likes_count: post.likes.count }
      else
        render json: { success: false, message: "Error" }, status: :unprocessable_entity
      end
    end
  
    def destroy
      post = Post.find(params[:post_id])
      like = post.likes.find_by(user_id: params[:user_id])
  
      if like
        like.destroy
        render json: { success: true, likes_count: post.likes.count }
      else
        render json: { success: false, message: "Like not found" }, status: :unprocessable_entity
      end
    end
  end
  
  
