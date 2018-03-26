CREATE DATABASE DATA607_GROUP7_PROJECT3; 

USE DATA607_GROUP7_PROJECT3; 

CREATE TABLE job_website_info(
website_id INT, 
website_name VARCHAR(100),
PRIMARY KEY(website_id)
);

CREATE TABLE job_urls (
job_url_id INT, 
website_id INT,
job_url VARCHAR(500),
selector VARCHAR(100),
PRIMARY KEY(job_url_id)
);

CREATE TABLE job_rawText (
job_url_id INT,
raw_text VARCHAR(65535),
PRIMARY KEY(job_url_id)
);

CREATE TABLE job_cleanText (
process_id INT, 
job_url_id INT,
clean_text VARCHAR(65535),
PRIMARY KEY(process_id, job_url_id)
);

CREATE TABLE term_document_matrix(
process_id INT, 
term VARCHAR(500),
frequency INT,
job_url_id INT,
PRIMARY KEY(process_id, term)
);

CREATE TABLE term_frequency_adjusted(
process_id INT,
term VARCHAR(500),
frequency INT,
PRIMARY KEY(process_id, term)
)







