class PostsController < ApplicationController
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
    @post.user_id = current_user.id
    @post.save
    redirect_to post_path(@post)
  end

  def edit
    # 今から編集したい投稿を一つだけ持ってくる、Post.find(params[:id])、これで編集したいレシピの情報一つというのを@recipeに入れた。あとはこれをviewsのpostsのedit.html.erbに渡してくればいい。
    @post = Post.find(params[:id])
  end

  def update
    # まずは更新するデータをとってくる、@post.find(params[:id])、@post.updateでどのカラムを更新するのかそれを許可してあげる、post_paramsこれで更新ができるのでredirect、どのように遷移するか今回はその更新した詳細画面に戻るようにする、よってrecipe_path、どのrecipeに遷移するか教えてあげる必要があるから@post、この@postとfindで見つけてきた@postは一致している。
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path(@post)
  end

  private
  def post_params
    params.require(:post).permit(:title, :body, :image)
  end

end
