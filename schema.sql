CREATE TABLE articles (
  id SERIAL PRIMARY KEY,
  url text NOT NULL,
  title varchar(1000) NOT NULL,
  description varchar(1000) NOT NULL,
  created_at TIMESTAMP NOT NULL
);

