CREATE TABLE articles (
  id SERIAL PRIMARY KEY,
  url text NOT NULL,
  title varchar(1000) NOT NULL,
  description varchar(1000) NOT NULL,
  created_at TIMESTAMP NOT NULL
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  article_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  contents text NOT NULL,
  created_at TIMESTAMP NOT NULL
);

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name varchar(255)
);

