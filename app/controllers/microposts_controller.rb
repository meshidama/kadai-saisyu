class MicropostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:edit, :update, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'タスクを投稿しました。'
      redirect_to root_url
    else
      @pagy, @microposts = pagy(current_user.feed_microposts.order(id: :desc))
      flash.now[:danger] = 'タスクの投稿に失敗しました。'
      render 'toppages/index'
    end
  end
  
  def edit
  end
  
  def update
    if @micropost.update(micropost_params)
      flash[:success] = 'タスク は正常に更新されました'
      redirect_to root_url
    else
      flash.now[:danger] = 'タスク は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'タスクを削除しました。'
    redirect_back(fallback_location: root_path)
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :kanryou)
  end
  
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    unless @micropost
      redirect_to root_url
    end
  end
end
