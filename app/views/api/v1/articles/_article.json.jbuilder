json.title article.title
json.content article.content
json.author article.user.email
json.category article.category.name

json.tags article.tags, :name

json.images article.pictures do |pic|
  json.filename pic.image
  json.url image_url(pic.image)
end

json.url article_url(article, format: :json)