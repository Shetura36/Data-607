---
title: "Data607 Discussion 12"
author: "S. Tinapunan"
date: "May 6, 2018"
output: 
  html_document: 
    keep_md: yes
---



### Netflix Recommender System

In this assignment, I am going to try and understand how the Neflix recommender system works. I created a new Netflix profile for adults with no restrictions on the shows that can be presented.

This assignment will only focus on the recommender system from a customer's perspective. 

----

### Testing the recommender system

This test is limited to a new profile and user interaction immediately after the new profile was created. 

The initial 3 selections (all kid's cartoons) were particularly selected to greatly contrast the horror category.

To test the recommender system, movies in the horror category were viewed, given the thumbs up, and added to the "My List" section. 

The demo links below present the actual screen recording of the actions and results of the actions. 

As mentioned in the conclusion section below, it appears that for a new Netflix profile, the initial list of recommendations are highly influenced by the 3 initial movies selected. 

For a new profile, viewing a movie, giving a thumbs up, or adding these new types of movies in the "My List" on the same day (or within the hour) of when the new profile is created did not have any noticeable change on the list of recommended movies. 

----

### Initiating the new profile

Demo: https://screencast-o-matic.com/watch/cFhieHbT9e

When I first started the new profile, I was asked to select 3 movies. The three movies I selected are below: 

- The Boss Baby
- Disney's Moana
- The Emoji Movie 

----

### Netflix recommendations based on initial 3 selections

Demo 1: https://screencast-o-matic.com/watch/cFhiedbT9I  (loading selections)

Demo 2: https://screencast-o-matic.com/watch/cFhieLbT9t  (different categories)

After making the 3 initial selections, Netflix recommender system started creating a list of shows and movies based on these 3 initial selections. See demo 1 link above. 

These lists of recommended shows and movies are broken down into many different categories. See demo 2 link above. There are 3 categories that are specifically generated based on the initial 3 selections. 

- More like The Boss Baby
- More like Moana
- More like The Emoji Movies

I noticed that the other categories generated can be roughly broken down into three types: (1) categories that have items that are mostly related tot he initial selection, (2) categories that have items that are mostly not related to the initial selection, and (3) categories that are mixed with items that are related to the initial selections and those that are not. 

----

#### Mostly Related to Initial Selection: 

- Popular on Netflix
- Trending Now
- Children & Family Movies
- Animation
- Family Watch Together Movies
- Goofy TV Shows
- Imaginative Animation
- Family Comedies
- Exciting Animation
- Feel-good animation
- Lazy Afternoon Movies for Kids
- Top Picks for `Test` (profile name)

#### Mostly Not Related to Initital Selection:

- Netflix Originals
- Crime TV Shows
- Exciting TV Shows
- TV Action & Adventure
- TV Dramas
- Documentaries
- Action & Adventure
- Reality TV
- Suspenseful Movies
- Anime
- Recently Added
- Drama
- Crime Movies
- Romantic Movies
- Thrillers
- Violent Action & Adventure
- Horror Movies 

### Mixed

- TV Comedies
- Comedies
- New Releases
- Critically-acclaimed Movies

----

### Watch a horror movie (fast forward to the end of the movie)


Demo: https://screencast-o-matic.com/watch/cFhifrbTRk

Demo: https://screencast-o-matic.com/watch/cFhiftbTRP

I viewed the movie "Jeepers Creepers 3" under the "Horror" category. This did not change the types of movies shown on categories like "Trending Now", "Popular on Netflix", "Top Picks for Test". 

I watched a second movie under the "Horror" category called "Clown", and again this did not change the types of movies that showed up on the list of recommendations. 


I watched a third movie under the "Horror" category called "Bedelived", and again this did not change the types of movies that showed up on the list of recommendations. 


NOTE: The assumption here is that viewing the movie (not necessarily completely watching the movie) would have an effect on the list of recommended items. 

----

### Giving a horror movie a thumbs up

Demo 1: https://screencast-o-matic.com/watch/cFhifabTSY

Demo 2: https://screencast-o-matic.com/watch/cFhifkbTSp 

Because there are many different categories, I am going to use "Top Picks for Test" as a category that I think should be reasonably responsive to end-user selections. 

I gave 3 horror movies a thumbs up, and this did not change the recommended list of movies much. The "Top Picks for Test" did not change in the type of movies shown. The page was refreshed as well. 

I gave more than 10  horror movies a thumbs up; however, this did not change the kinds of movies shown for the "Top Picks for Test" category. The page was refreshed. See demo 2 link.

----

### Adding horror movies in the "My List""

Demo: https://screencast-o-matic.com/watch/cFhifKbTWf

After adding more than 10 horror movies in the "My List". I did not notice much changes in the list of recommended shows. I did not see horror movies displayed on the "Top Picks for Test" category. 

----

### Conclusion

It appears that for a new Netflix profile, the initial list of recommendations are highly influenced by the 3 initial movies selected. 

For a new profile, viewing a movie, giving a thumbs up, or adding these new types of movies in the "My List" on the same day (or within the hour) of when the new profile is created did not have any noticeable change on the list of recommended movies. 








