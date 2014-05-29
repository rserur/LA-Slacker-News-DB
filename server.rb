require 'sinatra'
require 'json'
require 'uri'
require 'pg'

def get_articles
  connection = PG.connect(dbname: 'slacker_news')
  results = connection.exec('SELECT * FROM articles')
  connection.close

  results
end

def submit_article(url, title, description)
  sql = "INSERT INTO articles (url, title, description, created_at)" + "VALUES ($1, $2, $3, NOW())"
  connection = PG.connect(dbname: 'slacker_news')
  connection.exec_params(sql, [url, title, description])
  connection.close
end

def get_single_article(article)
  sql = "SELECT * FROM articles WHERE id = $1"
  connection = PG.connect(dbname: 'slacker_news')
  results = connection.exec(sql, [article])
  connection.close

  results
end
def get_comments(article)
  sql = "SELECT comments.id, comments.article_id, comments.user_id, comments.contents AS contents,
    comments.created_at AS created_at, users.name AS username FROM comments
    JOIN users ON comments.user_id = users.id WHERE comments.article_id = $1"
  connection = PG.connect(dbname: 'slacker_news')
  results = connection.exec(sql, [article])
  connection.close

  results
end


# URL validation method found @ http://stackoverflow.com/questions/7167895/whats-a-good-way-to-validate-links-urls-in-rails-3
def valid?(uri)
  !!URI.parse(uri)
rescue URI::InvalidURIError
  false
end

get '/articles' do

  @news = get_articles

  erb :index

end

get '/x' do

  erb :submit

end

post '/x' do

  # variables for form data
  @title = params[:title]
  @url = params[:url]
  @text = params[:text]

  if @title == "" || @url == "" || @text == ""

    @message = "*Sorry, a title, url, and description is required for article submission."

    erb :submit

  elsif !valid?(@url)

    @message = "Sorry, that url is invalid. Try again."

    erb :submit

  elsif @text.length < 20

    @message = "Sorry, descriptions must be 20 characters or more."

    erb :submit

  else

    # CSV.open('news.csv', 'a') do |row|
    #   row << [@title, @url, @text]
    # end

    submit_article(@url, @title, @text)

    redirect '/'
  end

end

get '/articles/:article_id/comments' do

  @news = get_single_article(params[:article_id])

  @comments = get_comments(params[:article_id])

  erb :'comments.html'

end
