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
                    "category_id": "1",
                    "tags": [
                          {
                              "name": "tag1"
                          },
                          {
                              "name": "tag2"
                          }
                        ],
                    "images": [
                          {
                            "filename": "images.jpg",
                            "content": "iVBORw0KGgoAAAANSUhEUgAAAc8AAAAqCAIAAABa5Ef5AAAa70lEQVR4Ae19CXQUVbp/RhFM",
                            "content_type": "image/jpg"
                          },
                          {
                            "filename": "oM9cMWd.png",
                            "content": "iVBORw0KGgoAAAANSUhEUgAAAc8AAAAqCAIAAABa5Ef5AAAa70lEQVR4Ae",
                            "content_type": "image/png"
                          }
                        ]
                  }
            }
    === Example Result
      {
        "title": "Article from API",
        "content": "texttext",
        "author": "user2@email.com",
        "category": "History",
        "tags": [
          {
            "name": "tag1"
          },
          {
            "name": "tag2"
          }
        ],
        "images": [
          {
            "filename": "/system/pictures/images/000/000/021/original/images.jpg?1446117749",
            "url": "http://localhost:3000/system/pictures/images/000/000/021/original/images.jpg?1446117749"
          },
          {
            "filename": "/system/pictures/images/000/000/022/original/oM9cMWd.png?1446117750",
            "url": "http://localhost:3000/system/pictures/images/000/000/022/original/oM9cMWd.png?1446117750"
          }
        ],
        "url": "http://localhost:3000/articles/34.json"
      }
    EOS
  param :article, Hash, :desc => "Article info", :required => true do
    param :title, String, "Title of the article", :required => true
    param :content, String, "Content of the article", :required => true
    param :user_id, String, "user_id of the article"
    param :category_id, String, "category_id of the article", :required => true
    param :tags, Array, :desc => "Article tags" do
      param :name, String, :desc => "Name of the tag", :required => true
    end
    param :images, Array, :desc => "Article images" do
      param :filename, String, :desc => "image filename", :required => true
      param :content, String, :desc => "image file on Base64Encoded data", :required => true
      param :content_type, String, :desc => "image content type, e.g. image/jpeg", :required => true
    end
  end
  param_group :token

  def create
    @article = current_user.articles.build(article_params)
    @article.category params[:article][:category]

    if @article.save
      if params[:article][:tags]
        params[:article][:tags].each do |tag|
          @article.tags<<Tag.where(name: tag[:name].strip).first_or_create!
        end
      end

      if params[:article][:images]
        params[:article][:images].each { |image|
          @article.pictures.create(image: parse_image_data(image))
        }
      end

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
                      "title": "Article from API v2",
                      "content": "texttext",
                      "category_id": "2",
                      "tags": [
                            {
                                "name": "tag1"
                            }
                          ],
                      "images": [
                            {
                              "filename": "images.jpg",
                              "content": "iVBORw0KGgoAAAANSUhEUgAAAc8AAAAqCAIAAABa5Ef5AAAa70lEQVR4Ae19CXQUVbp/RhFM",
                              "content_type": "image/jpg"
                            }
                          ]
                    }
            }
    === Example Result
      {
        "title": "Article from API v2",
        "content": "texttext",
        "author": "user2@email.com",
        "category": "Economics",
        "tags": [
          {
            "name": "tag1"
          }
        ],
        "images": [
          {
            "filename": "/system/pictures/images/000/000/025/original/images.jpg?1446119434",
            "url": "http://localhost:3000/system/pictures/images/000/000/025/original/images.jpg?1446119434"
          }
        ],
        "url": "http://localhost:3000/articles/36.json"
      }
    EOS
  param :article, Hash, :desc => "Article info", :required => true do
    param :title, String, "Title of the article"
    param :content, String, "Content of the article"
    param :category_id, String, "category_id of the article"
    param :tags, Array, :desc => "Article tags" do
      param :name, String, :desc => "Name of the tag", :required => true
    end
    param :images, Array, :desc => "Article images" do
      param :filename, String, :desc => "image filename", :required => true
      param :content, String, :desc => "image file on Base64Encoded data", :required => true
      param :content_type, String, :desc => "image content type, e.g. image/jpeg", :required => true
    end
  end
  param_group :token
  def update
    if @article.update(article_params)
      @article.category params[:article][:category]

      if params[:article][:tags]
        @article.tags.clear
        params[:article][:tags].each do |tag|
          @article.tags<<Tag.where(name: tag[:name].strip).first_or_create!
        end
      end

      if params[:article][:images]
        params[:article][:images].each { |image|
          @article.pictures.create(image: parse_image_data(image))
        }
      end

      render :show, status: :ok, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
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

  def parse_image_data(img)
    data = StringIO.new(Base64.decode64(img[:content]))
    data.class.class_eval { attr_accessor :original_filename, :content_type }
    data.original_filename = img[:filename]
    data.content_type = img[:content_type]
    data
  end

end