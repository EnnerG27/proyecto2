class CommentsController < ApplicationController
  before_action :set_article
  before_action :set_comment, only: [:destroy, :edit, :update]
  before_action :authenticate_user!, only: [:create, :destroy]
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @article, notice: 'Comment added successfully.'
    else
      redirect_to @article, alert: 'Failed to add comment.'
    end
  end

  def edit
    @comment = @article.comments.find(params[:id])
  end
  

  def update
    @comment = @article.comments.find(params[:id])
  
    if @comment.update(comment_params)
      redirect_to article_path(@article), notice: 'Comment was successfully updated.'
    else
      render 'edit' # Si la actualización falla, vuelve a la página de edición
    end
  end
  

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])

    if @comment.user == current_user
      @comment.destroy
      redirect_to @article, notice: 'Comment deleted successfully.'
    else
      redirect_to @article, alert: 'You are not authorized to delete this comment.'
    end
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_comment
    @comment = @article.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
