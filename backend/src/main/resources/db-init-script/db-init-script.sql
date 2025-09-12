DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS website;
DROP TABLE IF EXISTS "user";

CREATE TABLE "user"(
                       id SERIAL PRIMARY KEY,
                       username text not null unique,
                       registration_date  TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
                       password varchar(100) not null
);

CREATE TABLE website(
                         id SERIAL PRIMARY KEY,
                         url text not null,
                         user_id integer not null REFERENCES "user"(id),
                         post_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

CREATE TABLE review(
                       id SERIAL PRIMARY KEY,
                       score int not null,
                       comment text not null,
                       user_id integer not null REFERENCES "user"(id),
                       post_date  TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
                       website_id integer REFERENCES website(id) ON DELETE CASCADE
);



INSERT INTO "user" (username, password) VALUES ('John Doe', 'pw123');
INSERT INTO "user" (username, password) VALUES ('Béla', 'apple1');
INSERT INTO "user" (username, password) VALUES ('Harry Potter', 'harrypotter123');


INSERT INTO website (url, user_id) VALUES ('google.com', 1);
INSERT INTO website (url, user_id) VALUES ('openai.com',  2);
INSERT INTO website (url, user_id) VALUES ('grok.com',  3);


INSERT INTO review (score, comment, user_id, website_id) VALUES (5, 'My fav for searching', 2,1);
INSERT INTO review (score, comment, user_id, website_id) VALUES (3, 'Worse since using Gemini but overall okay.', 3,1);