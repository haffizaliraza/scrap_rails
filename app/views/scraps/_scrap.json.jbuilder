json.extract! scrap, :id, :keywords, :urls, :created_at, :updated_at
json.url scrap_url(scrap, format: :json)
