DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS website;
DROP TABLE IF EXISTS "user";

CREATE TABLE "user"(
                       id SERIAL PRIMARY KEY,
                       username TEXT NOT NULL UNIQUE,
                       registration_date  TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
                       passwordHash VARCHAR(60) NOT NULL
);

CREATE TABLE website(
                         id SERIAL PRIMARY KEY,
                         domain TEXT NOT NULL,
                         name TEXT NOT NULL,
                         url TEXT NOT NULL,
                         description TEXT,
                         user_id INTEGER REFERENCES "user"(id) ON DELETE SET NULL,
                         post_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
                         CONSTRAINT uq_website_domain UNIQUE (domain)
);

CREATE TABLE review(
                       id SERIAL PRIMARY KEY,
                       score INT NOT NULL CHECK (score BETWEEN 1 AND 5),
                       comment TEXT NOT NULL,
                       user_id INTEGER REFERENCES "user"(id) ON DELETE SET NULL,
                       post_date  TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
                       website_id integer REFERENCES website(id) ON DELETE CASCADE
);


INSERT INTO "user" (username, passwordHash) VALUES ('John', '$2a$10$c1LAnNjyLXpHo8ANI7TPa.iqICYV29rDRnJ3PMPbcyxzhdCP/97WG'); --testpass
INSERT INTO "user" (username, passwordHash) VALUES ('Alice', '$2a$10$q5MrVvUmeU7EdxdGCiz0ZOU/yR9S/FMMeA74v7MGv16JJMCxaA.uy'); --pass123
INSERT INTO "user" (username, passwordHash) VALUES ('Bob', '$2a$10$K3P7jjAb0Vb5OkxLi5y5quQzR2QUqL0Lbroo.lBP9tXnFhcLEXY7G'); --mesecure


INSERT INTO website (domain, name, url, description, user_id) VALUES
('google.com', 'Google', 'https://www.google.com',
 'The world’s most popular search engine with a clean interface and fast results.', 1),
('openai.com', 'OpenAI', 'https://openai.com',
 'Research and deployment company behind ChatGPT, providing AI tools and APIs.', 2),
('grok.com', 'Grok', 'https://grok.com',
 'AI assistant brand known for snappy, real-time responses.', 3);


INSERT INTO review (score, comment, user_id, website_id) VALUES
(5, 'Blazing fast search and clean results. Still my default.', 2, 1),
(4, 'Great overall; ads can crowd above the fold at times.', 3, 1),

(5, 'Clear docs, strong models, rapid iteration. Great for prototyping.', 1, 2),
(4, 'Solid APIs, occasional latency under heavy load, but improving.', 3, 2),

(3, 'Depth varies by topic. Trending in the right direction.', 1, 3),
(4, 'The scope of the answer is too broad, but very informative if you are interested in the depths of a topic.', 2, 3);