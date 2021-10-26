class PostsController < ApplicationController
  # ログインしていない人のアクセス制限をする deviseを導入したら使えるようになるヘルパー、before_action :authenticate_user!このように書くとログインしていない人は全てのアクションにアクセスができなくなる。しかし今回は一覧画面インデックスアクションへのアクセスは許可したいのでexcept: [:index]とする、こうすることでindexアクション以外のアクションはログインしていない人はアクセスできなくなる。これで非ログインユーザーのアクセス制限ができる。
  before_action :authenticate_user!, except: [:index]
  def index
    # モデル名ドットオールとするとデータベースに登録されている投稿の情報が全て配列で@postsという変数に渡される。この@postsをindex.html.erbに渡してあげる。
    @posts = Post.all
  end

  def show
    # こうすることでurlから番号をとってくる。
    @post = Post.find(params[:id])
  end

  def new
    # postモデルから空のモデルを持ってくるとする。Post.newとすると空のモデルが渡される。
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    # 誰が投稿したのか、@recipeのuser_idをここで入れる必要がある。これはログインしている人、だからcurrent_user.idとする、user_idのところのカラムに今ログインしている人のid、つまり誰が投稿しているのかがこれで保持される。
    # バリデーションをかけることによって、セーブされる時とされない時がある。もしもセーブされたらif、バリデーションにかかってしまったらelse
    # renderはアクションを介さずビューを返すもの。今回はnewアクションを介さずにpostsのnew.html.erbを返す。ここのnewで使われる@postはnewアクションの@postではなくcreateアクション内の＠postになる
    # flashメッセージを表示する、投稿に成功したら、notice: '投稿に成功しました。'flashメッセージが表示される。
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post), notice: '投稿に成功しました。'
    else
      render :new
    end
  end

    # 今から編集したい投稿を一つだけ持ってくる、Post.find(params[:id])、これで編集したいレシピの情報一つというのを@recipeに入れた。あとはこれをviewsのpostsのedit.html.erbに渡してくればいい。
    # editアクションに遷移した時のこと、考え方としては、もしも、@postに結びついているユーザーとcurrent_userの値が等しくなかったら、posts_path投稿の一覧画面に遷移すると書く、!=ノットイコール、postに紐づいているユーザーとcurrent_userが等しくなかったら、
    # 不正なアクセスです、alertメッセージを表示
    # rollback transactionはバリデーションにひっかかってデータベースに保存されていないという合図になる
  def edit
    @post = Post.find(params[:id])
    if @post.user != current_user
      redirect_to posts_path, alert: '不正なアクセスです。'
    end
  end

  def update
    # まずは更新するデータをとってくる、@post.find(params[:id])、@post.updateでどのカラムを更新するのかそれを許可してあげる、post_paramsこれで更新ができるのでredirect、どのように遷移するか今回はその更新した詳細画面に戻るようにする、よってrecipe_path、どのrecipeに遷移するか教えてあげる必要があるから@post、この@postとfindで見つけてきた@postは一致している。
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: '更新に成功しました。'
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    recipe.destroy
    redirect_to posts_path
  end

  private
  def post_params
    params.require(:post).permit(:title, :body, :image)
  end

end
