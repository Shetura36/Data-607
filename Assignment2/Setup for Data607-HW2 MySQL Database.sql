CREATE DATABASE DATA607_HW1;

USE DATA607_HW1;

CREATE TABLE movies (
movie_id INT NOT NULL AUTO_INCREMENT, 
movie_title VARCHAR(100),
movie_year INT,
PRIMARY KEY(movie_id)
);

CREATE TABLE movie_ratings (
rating_id INT NOT NULL AUTO_INCREMENT,
movie_id INT, 
rating INT,
PRIMARY KEY(rating_id),
FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

DROP TABLE movies; 
DROP TABLE movie_ratings;

#----------------- LOAD VALUES -----------------------#


INSERT INTO movies (movie_title, movie_year)
VALUES
('PETER RABBIT', 2018),
('BLACK PANTHER', 2018),
('JUMANJI: WELCOME TO THE JUNGLE', 2017),
('DEN OF THIEVES ', 2018),
('FIFTY SHADES FREED FAVORITE THEATER BUTTON', 2018),
('THE GREATEST SHOWMAN', 2018);

INSERT INTO movie_ratings (movie_id, rating)
VALUES
(1,5),
(2,5),
(3,5),
(4,4),
(5,3),
(6,5);

INSERT INTO movie_ratings (movie_id, rating)
VALUES
(1,4),
(2,3),
(3,3),
(4,2),
(5,4),
(6,4);

#--------------- SHOW TABLES -----------------------

SELECT * FROM movies; 
SELECT * FROM movie_ratings; 


SELECT *
FROM movie_ratings a JOIN movies b
ON a.movie_id = b.movie_id

