class Api::V1::ArticlesController < Api::V1::BaseController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def_param_group :token do
    param :access_token, String, :desc => "Your API token", :required => true
  end

  api :GET, "/articles", "List all articles"
  api :GET, "/users/:user_id/articles", "List all articles for user"
  api :GET, "/categories/:category_id/articles", "List all articles for category"
  description <<-EOS
    === Example Request
      GET
      /api/v1/articles?access_token=111d9e316c81d421be9f9f5af6a5ca3390557256957beb8b71c9b6829dba8028&page=1&limit=3
    === Example Result
      [
        {
          "id": 4,
          "title": "user2 can't edit article 4",
          "content": "2222.",
          "user_id": "4",
          "url": "http://localhost:3000/articles/4.json"
        },
        {
          "id": 5,
          "title": "user2 can edit article 5",
          "content": "aaaaaa.",
          "user_id": "3",
          "url": "http://localhost:3000/articles/5.json"
        },
        {
          "id": 6,
          "title": "edit article with API",
          "content": "text text text",
          "user_id": "3",
          "url": "http://localhost:3000/articles/6.json"
        }
      ]
    EOS
  param :page, String, :desc => "paginate results"
  param :limit, String, :desc => "number of entries per request (default 25)"
  param_group :token
  def index
    @articles = Article.all.page(params[:page]).per(params[:limit])
    if user = User.find_by_id(params[:user_id])
      @articles = user.articles.page(params[:page]).per(params[:limit])
    elsif category = Category.find_by_id(params[:category_id])
      @articles = category.articles.page(params[:page]).per(params[:limit])
    end
  end

  api :GET, "/articles/:id", "Show an article by id"
  description <<-EOS
    === Example Request
      GET
      /api/v1/articles/5?access_token=111d9e316c81d421be9f9f5af6a5ca3390557256957beb8b71c9b6829dba8028
    === Example Result
      [
        {
          "id": 5,
          "title": "user2 can edit article 5",
          "content": "aaaaaa.",
          "user_id": "3",
          "created_at": "2015-10-12T13:45:32.569Z",
          "updated_at": "2015-10-13T07:59:05.680Z"
        }
      ]
    EOS
  param_group :token
  def show
  end

  api :POST, "/articles", "Create an Article"
  description <<-EOS
    === Example Request
      POST
      /api/v1/articles?access_token=111d9e316c81d421be9f9f5af6a5ca3390557256957beb8b71c9b6829dba8028
      Content-Type: application/json
      body: {
              "article": {
                "title": "Article from API",
                "content": "texttext",
                "category_id": "1"
              }
            }
    === Example Result
      {
        "id": 18,
        "title": "Article from API",
        "content": "texttext",
        "user_id": "3",
        "created_at": "2015-10-15T10:19:39.390Z",
        "updated_at": "2015-10-15T10:19:39.390Z"
      }
    EOS
  param :article, Hash, :desc => "Article info", :required => true do
    param :title, String, "Title of the article", :required => true
    param :content, String, "Content of the article", :required => true
    param :user_id, String, "user_id of the article"
    param :category_id, String, "category_id of the article", :required => true
  end
  param_group :token
  def create
    @article = current_user.articles.build(article_params)
    @article.category params[:article][:category]

    if @article.save
      render :show, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  api :PUT, "/articles/:id", "Update an Article"
  description <<-EOS
    === Example Request
      PUT
      /api/v1/articles/4?access_token=111d9e316c81d421be9f9f5af6a5ca3390557256957beb8b71c9b6829dba8028
      Content-Type: application/json
      body: {
                "article": {
                      "title": "Article Title",
                      "content": "content",
                      "category_id": "1"
                    }
            }
    === Example Result
      {
        "id": 4,
        "title": "Article Title",
        "content": "content",
        "user_id": "4",
        "created_at": "2015-10-08T12:54:33.809Z",
        "updated_at": "2015-10-15T10:26:30.087Z"
      }
    EOS
  param :article, Hash, :desc => "Article info", :required => true do
    param :title, String, "Title of the article"
    param :content, String, "Content of the article"
    param :category_id, String, "category_id of the article"
  end
  param_group :token
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.json { render :show, status: :ok, location: @article }
      else
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  api :DELETE, "/articles/:id", "Destroy an Article"
  description <<-EOS
    === Example Request
      DELETE
      /api/v1/articles/15?access_token=111d9e316c81d421be9f9f5af6a5ca3390557256957beb8b71c9b6829dba8028
    === Example Result
      Status 204 No Content
    EOS
  param_group :token
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
