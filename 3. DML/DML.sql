USE BUDT703_Project_0502_03

--Objective 1
--Display restaurants in each category in decreasing order of Rating

DROP VIEW v_RestaurantDisplay
GO
CREATE VIEW v_RestaurantDisplay AS
SELECT AVG(w.reviewRating) AS 'Rating', r.restaurantName AS 'Restaurant Name', r.restaurantCategory AS 'Restaurant Category'
FROM [TIPS.Review] w INNER JOIN [TIPS.Restaurant] r
ON w.restaurantID = r.restaurantID
GROUP BY r.restaurantCategory, r.restaurantName
ORDER BY restaurantCategory, Rating DESC OFFSET 0 ROWS
GO 

SELECT * FROM v_RestaurantDisplay 

--Display (upto) top 5 restaurants in each category in decreasing order of Rating. In case of a tie, both restaurants are printed.

DROP VIEW v_TopFiveRestaurants
GO
CREATE VIEW v_TopFiveRestaurants AS
SELECT rs.Rating, rs.restaurantName AS 'Restaurant Name', rs.restaurantCategory AS 'Restaurant Category'
FROM (
    SELECT AVG(w.reviewRating) AS 'Rating', r.restaurantName, r.restaurantCategory, Rank()
    OVER (PARTITION BY r.restaurantCategory ORDER BY AVG(w.reviewRating) DESC) AS Rank
    FROM [TIPS.Review] w INNER JOIN [TIPS.Restaurant] r
    ON w.restaurantID = r.restaurantID
    GROUP BY r.restaurantCategory, r.restaurantName 
) rs WHERE Rank <= 5
GO

SELECT * FROM v_TopFiveRestaurants

-- What is the highest rated restaurant in the breakfast category

DROP VIEW v_HighRateRestinBreakfast
GO
CREATE VIEW v_HighRateRestinBreakfast AS
SELECT TOP 1 rt.restaurantID AS 'Restaurant ID', rt.restaurantName AS 'Restaurant Name', rt.restaurantAddr AS 'Restaurant Address', rt.restaurantWeb AS 'Restaurant Web', rt.restaurantCategory AS 'Restaurant Category', rt.restaurantPriceRange AS 'Restaurant Price Range', (rv.reviewRating) AS 'Average Rating'
FROM [TIPS.Restaurant] rt, [TIPS.Review] rv
WHERE rv.restaurantID = rt.restaurantID AND rt.restaurantCategory = 'Breakfast'
GROUP BY rt.restaurantID, rt.restaurantName, rt.restaurantAddr, rt.restaurantCategory, rt.restaurantWeb, rt.restaurantPriceRange, rv.reviewRating
ORDER BY AVG (rv.reviewRating) DESC
GO 

SELECT * FROM v_HighRateRestinBreakfast

--Objective 2
--Display restaurants in each price range in decreasing order of rating

DROP VIEW v_RestaurantinPriceRange
GO
CREATE VIEW v_RestaurantinPriceRange AS
SELECT AVG(w.reviewRating) AS 'Rating', r.restaurantName AS 'Restaurant Name', r.restaurantPriceRange AS 'Restaurant Price Range'
FROM [TIPS.Review] w INNER JOIN [TIPS.Restaurant] r
ON w.restaurantID = r.restaurantID
GROUP BY r.restaurantPriceRange, r.restaurantName
ORDER BY r.restaurantPriceRange, AVG(w.reviewRating) DESC OFFSET 0 ROWS 
GO 

SELECT * FROM v_RestaurantinPriceRange


--Display top 5 restaurants in each price range in decreasing order of rating. In case of a tie, both restaurants are printed.

DROP VIEW v_TopFiveRestinPriceRange
GO
CREATE VIEW v_TopFiveRestinPriceRange AS
SELECT rs.Rating, rs.restaurantName AS 'Restaurant Name', rs.restaurantPriceRange AS 'Restaurant Price Range'
FROM (
    SELECT AVG(w.reviewRating) AS 'Rating', r.restaurantName , r.restaurantPriceRange , Rank()
    OVER (PARTITION BY r.restaurantPriceRange ORDER BY AVG(w.reviewRating) DESC) AS Rank
    FROM [TIPS.Review] w INNER JOIN [TIPS.Restaurant] r
    ON w.restaurantID = r.restaurantID
    GROUP BY r.restaurantPriceRange, r.restaurantName
) rs WHERE Rank <= 5
GO 

SELECT * FROM v_TopFiveRestinPriceRange

--Objective 3
--We find the number of 1-star, 2-star, 3-star, 4-star and 5-star reviews for a chosen restaurant. 
--In this case, we have chosen 'Preserve' restaurant.

DROP VIEW v_StarsForChosenRestaurant
GO
CREATE VIEW v_StarsForChosenRestaurant AS
SELECT reviewRating AS 'Review Rating', COUNT(*) AS 'Frequency' FROM [TIPS.Review]
WHERE restaurantID = (SELECT restaurantID FROM [TIPS.Restaurant] WHERE restaurantName = 'Preserve')
GROUP BY reviewRating
ORDER BY reviewRating DESC OFFSET 0 ROWS
GO 

SELECT * FROM v_StarsForChosenRestaurant

--Objective 4
--We find the number of 1-star, 2-star, 3-star, 4-star and 5-star reviews for a chosen user. 
--In this case, we have chosen 'Kevin W.' as the user.

DROP VIEW v_UserRatings
GO
CREATE VIEW v_UserRatings AS
SELECT reviewRating AS 'Review Rating', COUNT(*) AS 'Frequency' FROM [TIPS.Review]
WHERE userID = (SELECT userID FROM [TIPS.User] WHERE userFName = 'Kevin' AND userLName = 'W.')
GROUP BY reviewRating
ORDER BY reviewRating DESC OFFSET 0 ROWS
GO

SELECT * FROM v_UserRatings

--Objective 5
--We find the top 5 most popular collections.

DROP VIEW v_MostPopularCollection
GO
CREATE VIEW v_MostPopularCollection AS
SELECT TOP 5 collectionID AS 'Collection ID', collectionName AS 'Collection Name', collectionDescription AS 'Collection Description', collectionPublicity AS 'Collection Publicity', userID AS 'User ID' FROM [TIPS.Collection]
ORDER BY collectionPublicity DESC
GO 

SELECT * FROM v_MostPopularCollection

--Objective 6
--Here, we display the top 5 most useful reviews for a chosen restaurant. In this case, we have
--chosen Kemoll's Chophouse as the restaurant.

DROP VIEW v_TopFiveReviewsRestaurant
GO
CREATE VIEW v_TopFiveReviewsRestaurant AS
SELECT TOP 5 * FROM [TIPS.Review]
WHERE restaurantID = (SELECT restaurantID FROM [TIPS.Restaurant] WHERE restaurantName = 'Kemoll''s Chophouse')
ORDER BY reviewUseful DESC
GO

SELECT * FROM v_TopFiveReviewsRestaurant

--Objective 7
--We display the top 5 categories with the least number of restaurants

DROP VIEW v_TopFiveCategories
GO
CREATE VIEW v_TopFiveCategories AS
SELECT TOP 5 COUNT(*) AS 'No. of Restaurants', restaurantCategory AS 'Restaurant Category' FROM [TIPS.Restaurant]
GROUP BY restaurantCategory
ORDER BY COUNT(*) ASC
GO 

SELECT * FROM v_TopFiveCategories

--Objective 8
--We display the top 5 categories with the most number of restaurants

DROP VIEW v_TopFiveCatRestaurants
GO
CREATE VIEW v_TopFiveCatRestaurants AS
SELECT TOP 5 COUNT(*) AS 'No. of Restaurants', restaurantCategory AS 'Restaurant Category' FROM [TIPS.Restaurant]
GROUP BY restaurantCategory
ORDER BY COUNT(*) DESC
GO

SELECT * FROM v_TopFiveCatRestaurants

--Objective 9
--Top 10 users who have posted the maximum number of reviews. We also display the elite users.

DROP VIEW v_TopTenUserMaxReviews
GO
CREATE VIEW v_TopTenUserMaxReviews AS
SELECT TOP 10 u.userID AS 'User ID', u.userFName AS 'First Name', u.userLName AS 'Last Name', u.userDOJ AS 'Date of Join', u.userLoc AS 'Location', u.userElite AS 'Elite User', COUNT(*) AS 'Review Count'
FROM [TIPS.User] u INNER JOIN [TIPS.Review] r
ON u.userID = r.userID
GROUP BY u.userID, u.userFName, u.userLName, u.userLoc, u.userDOJ, u.userElite
GO

SELECT * FROM v_TopTenUserMaxReviews
--From the results, it can be inferred that 6 out of the 10 reviewers are elite users.

--Top 10 users who have posted the maximum number of posts. We also display the elite users.

DROP VIEW v_MostPostUser
GO
CREATE VIEW v_MostPostUser AS
SELECT TOP 10 u.userID AS 'User ID', u.userFName AS 'First Name', u.userLName AS 'Last Name', u.userDOJ AS 'Date of Join', u.userLoc AS 'Location', u.userElite AS 'Elite User', COUNT(*) AS 'Post Count'
FROM [TIPS.User] u INNER JOIN [TIPS.Post] p
ON u.userID = p.userID
GROUP BY u.userID, u.userFName, u.userLName, u.userLoc, u.userDOJ, u.userElite
GO 

SELECT * FROM v_MostPostUser
--From the results, it can be inferred that 6 out of the 10 people are elite users.

--Objective 10
--We display the top 3 most recent posts for a chosen restaurant

DROP VIEW v_TopThreeMostRecentPosts
GO
CREATE VIEW v_TopThreeMostRecentPosts AS
SELECT TOP 3 postID AS 'Post ID', postName AS 'Post Name', postContent AS 'Post Content', postType AS 'Post Type',
postDate AS 'Post Date', userID AS 'User ID', restaurantID AS 'Restaurant ID' 
FROM [TIPS.Post]
WHERE restaurantID = 
(SELECT restaurantID FROM [TIPS.Restaurant] WHERE restaurantName = 'Sugarfire Smoke House')
ORDER BY postDate DESC
GO

SELECT * FROM v_TopThreeMostRecentPosts
------------------------------------------------------------------------------------------------------------------------------------------

--Extra objectives

--Objective 11
--What are the favorite restaurant categories for elite user in descending order

DROP VIEW v_FavCatEliteUser
GO
CREATE VIEW v_FavCatEliteUser AS
SELECT rt.restaurantCategory AS 'Restaurant Category', AVG (rv.reviewRating) as 'Average Rating'
FROM [TIPS.Restaurant] rt, [TIPS.Review] rv, [TIPS.User] u
WHERE rv.restaurantID = rt.restaurantID AND rv.userID =u.userID AND u.userElite=1
GROUP BY rt.restaurantCategory
ORDER BY AVG (rv.reviewRating) DESC OFFSET 0 ROWS
GO

SELECT * FROM v_FavCatEliteUser


--Objective 12
--What are the restaurants in the collection of a chosen user. 
--In this case, we have chosen Kevin W. as the user

DROP VIEW v_CollUserRestaurants
GO
CREATE VIEW v_CollUserRestaurants AS 
SELECT r.restaurantID AS 'Restaurant ID', r.restaurantName AS 'Restaurant Name', r.restaurantAddr AS 'Restaurant Address', r.restaurantWeb AS 'Restaurant Web', r.restaurantCategory AS 'Restaurant Category', r.restaurantPriceRange AS 'Restaurant Price Range'
FROM [TIPS.User] u, [TIPS.Collection] cl, [TIPS.Restaurant] r, [TIPS.Contains] ct
WHERE cl.userID=u.userID AND ct.collectionID=cl.collectionID AND ct.restaurantID= r.restaurantID AND u.userFName='Kevin' AND u.userLName='W.'
GO

SELECT * FROM v_CollUserRestaurants

--Objective 13
-- WHO are asking or answering questions about vegetarien(vegan) or gluten

DROP VIEW v_QnVeganGluten
GO
CREATE VIEW v_QnVeganGluten AS
SELECT u.userID AS 'User ID', u.userFName AS 'First Name', u.userLName AS 'Last Name', p.postName AS 'Post Name', p.postContent AS 'Post Content'
FROM [TIPS.User] u, [TIPS.Post] p
WHERE p.userID=u.userID AND ((p.postContent LIKE '%gluten%' OR p.postName LIKE '%gluten%') OR (p.postContent LIKE '%veg%' OR p.postName LIKE '%veg%'))
GO

SELECT * FROM v_QnVeganGluten

--Objective 14
-- Find all crab dishes and rank all crab dishes by price from low to high

DROP VIEW v_CrabDishes
GO
CREATE VIEW v_CrabDishes AS
SELECT r.restaurantID AS 'Restaurant ID',r.restaurantName AS 'Restaurant Name', m.itemName AS 'Item Name', m.itemDesc AS 'Item Description', m.itemPrice AS 'Item Price'
FROM [TIPS.Restaurant] r, [TIPS.MenuItem] m
WHERE m.restaurantID = r.restaurantID AND m.itemDesc LIKE '%crab%'
ORDER BY m.itemPrice OFFSET 0 ROWS
GO

SELECT * FROM v_CrabDishes




