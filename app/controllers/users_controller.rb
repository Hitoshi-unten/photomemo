class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  def index
    @users = User.all
  end

  def show
    # 一人の情報を持ってくる、Userモデルから.find一つのユーザー情報だけ持ってくる、どのユーザーの情報を持ってくるか不明だから、params[:id]、
    # 一人のユーザの情報をとってきて@userという変数に入れる。@userという変数をビューに渡す、この流れ、アクションで変数を定義してビューに渡す。
    # params[:id]これ何のidをとってきているかというと、これ数字、どこからparams[:id]をとってきているかというと、実はurl、naokiというところにカーソルを当てると、左下にusers/1と出る、この1と1いうのをとってきている。ユーザーモデルに登録してある
    @user = User.find(params[:id])
  end

  # urlにeditと直打ちして遷移できなくする
  def edit
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path, alert: '不正なアクセスです。'
    end
  end
  
  def update
    # 実際にユーザーを編集してデータベースに登録する、
    # @userどのユーザーを更新するのかを見つけるこれがparams[:id]、@userこれをupdateする、書き方が独特、@userが更新ができたら、redirect_toユーザーの詳細画面に遷移するのでuser_pathとする
    # まずどのユーザを更新するのかを見つけてきて、@userに行く、@userを更新する、redirect_toユーザーの詳細画面に戻る、出てきたuser_paramsを定義する必要がある
    # もう一度updateアクションを見ていく、まずユーザーを探してきて、どのユーザーを更新するのか、そのユーザーをアップデートする、どのユーザーをアップデートするのかというと:username, :email, :profile, :profile_image
    # 実はuser_paramsというのを定義しないとrailsではエラーが出てしまう、これ何をしているかというと、privateの下に書くことによって、users_controllerの中でしか、user_paramsというのは呼び出せない、usernameとかデータの
    # 情報はコントローラの中でしか呼び出されない、よってこうすることでセキュリティに強くなる、外部からデータベースの情報を取り出されない、なのでこんなめんどくさいことをしている、あとユーザーアップデートしてユーザーの詳細画面に戻る
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: '更新に成功しました。'
    else
      render :edit
    end
  end

  private
  # これはprivateの下に書く必要がある、params.require(:user).permitで更新するカラム名(:username,:email,:profile,:profile_image)これでuser_paramsが定義できる
  def user_params
    params.require(:user).permit(:username, :email, :profile, :profile_image)
  end
end
