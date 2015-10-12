class Api::V1::ArticlesController < Api::V1::BaseController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all

    if user = User.find_by_id(params[:user_id])
      @articles = user.articles
    elsif category = Category.find_by_id(params[:category_id])
      @articles = category.articles
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = current_user.articles.build(article_params)
    @article.category params[:article][:category]


    if @article.save
      render :show, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.json { render :show, status: :ok, location: @article }
      else
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :content, :user_id, :category_id)
    end
end
