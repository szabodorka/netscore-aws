DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS website;
DROP TABLE IF EXISTS "user";

CREATE TABLE "user"(
                       id SERIAL PRIMARY KEY,
                       username text not null unique,
                       registration_date  TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
                       passwordHash VARCHAR(60) NOT NULL
);

CREATE TABLE website(
                         id SERIAL PRIMARY KEY,
                         url text not null,
                         user_id INTEGER REFERENCES "user"(id) ON DELETE SET NULL,
                         post_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

CREATE TABLE review(
                       id SERIAL PRIMARY KEY,
                       score int not null,
                       comment text not null,
                       user_id INTEGER REFERENCES "user"(id) ON DELETE SET NULL,
                       post_date  TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
                       website_id integer REFERENCES website(id) ON DELETE CASCADE
);


INSERT INTO "user" (username, passwordHash) VALUES ('John', '$2a$10$c1LAnNjyLXpHo8ANI7TPa.iqICYV29rDRnJ3PMPbcyxzhdCP/97WG'); --testpass
INSERT INTO "user" (username, passwordHash) VALUES ('Béla', '$2a$10$q5MrVvUmeU7EdxdGCiz0ZOU/yR9S/FMMeA74v7MGv16JJMCxaA.uy'); --pass123
INSERT INTO "user" (username, passwordHash) VALUES ('Harry Potter', '$2a$10$K3P7jjAb0Vb5OkxLi5y5quQzR2QUqL0Lbroo.lBP9tXnFhcLEXY7G'); --mesecure


INSERT INTO website (url, user_id) VALUES ('google.com', 1);
INSERT INTO website (url, user_id) VALUES ('openai.com',  2);
INSERT INTO website (url, user_id) VALUES ('grok.com',  3);


INSERT INTO review (score, comment, user_id, website_id) VALUES (5, 'My fav for searching', 2,1);
INSERT INTO review (score, comment, user_id, website_id) VALUES (3, 'Worse since using Gemini but overall okay.', 3,1);