USE BUDT703_Project_0502_03

/* SQL REMOVE TABLES IF EXISTS*/
DROP TABLE IF EXISTS [TIPS.Contains];
DROP TABLE IF EXISTS [TIPS.Post];
DROP TABLE IF EXISTS [TIPS.Collection];
DROP TABLE IF EXISTS [TIPS.Review];
DROP TABLE IF EXISTS [TIPS.MenuItem];
DROP TABLE IF EXISTS [TIPS.Restaurant];
DROP TABLE IF EXISTS [TIPS.User];

/* SQL CREATE TABLES */
CREATE TABLE [TIPS.User] ( 
	userID CHAR(9) NOT NULL,
	userFName VARCHAR(20),
	userLName VARCHAR(20),
	userDOJ DATE,
    userLoc CHAR(20),
    userElite BIT,
	CONSTRAINT pk_User_userID PRIMARY KEY (userID)
)

CREATE TABLE [TIPS.Restaurant] (
	restaurantID CHAR(9),
	restaurantName VARCHAR(50),
	restaurantAddr VARCHAR(20),
	restaurantWeb VARCHAR(50),
	restaurantCategory VARCHAR(30),
	restaurantPriceRange VARCHAR(3),
	CONSTRAINT pk_Restaurant_restaurantID PRIMARY KEY (restaurantID)
)

CREATE TABLE [TIPS.Review] (
	reviewID CHAR(9) NOT NULL,
	reviewRating INTEGER,
	reviewDescription VARCHAR(300),
	reviewUseful INTEGER,
	reviewFunny INTEGER,
	reviewCool INTEGER,
	reviewDate DATE,
	userID CHAR(9),
	restaurantID CHAR(9)
	CONSTRAINT pk_Review_reviewID PRIMARY KEY (reviewID),
	CONSTRAINT fk_Review_userID FOREIGN KEY (userID)
        REFERENCES [TIPS.User] (userID)
        ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Review_restaurantID FOREIGN KEY (restaurantID)
        REFERENCES [TIPS.Restaurant] (restaurantID)
        ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE [TIPS.MenuItem] (
	restaurantID CHAR(9) NOT NULL,
	itemName VARCHAR(50) NOT NULL,
	itemDesc VARCHAR(300),
	itemPrice DECIMAL(5,2)
	CONSTRAINT pk_MenuItem_restaurantID_itemName PRIMARY KEY (restaurantID, itemName),
    CONSTRAINT fk_MenuItem_restaurantID FOREIGN KEY (restaurantID)
		REFERENCES [TIPS.Restaurant] (restaurantID)
        ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE [TIPS.Collection] (
	collectionID CHAR(9) NOT NULL,
	collectionName VARCHAR(30),
	collectionDescription VARCHAR(150),
	collectionPublicity INTEGER,
	userID CHAR(9),
	CONSTRAINT pk_Collection_collectionID PRIMARY KEY (collectionID),
	CONSTRAINT fk_Collection_userID FOREIGN KEY (userID)
		REFERENCES [TIPS.User] (userID)
		ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE [TIPS.Post] (
	postID CHAR(9) NOT NULL,
	postName VARCHAR(30),
	postContent VARCHAR(300),
	postType CHAR(1),
	postDate DATE,
	userID CHAR(9),
	restaurantID CHAR(9),
	questionID CHAR(9),
	CONSTRAINT pk_Post_postID PRIMARY KEY (postID),
	CONSTRAINT fk_Post_userID FOREIGN KEY (userID)
		REFERENCES [TIPS.User] (userID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Post_restaurantID FOREIGN KEY (restaurantID)
		REFERENCES [TIPS.Restaurant] (restaurantID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Post_questionID FOREIGN KEY (questionID)
		REFERENCES [TIPS.Post] (postID)
		ON DELETE NO ACTION ON UPDATE NO ACTION
)

CREATE TABLE [TIPS.Contains] (
	collectionID CHAR(9) NOT NULL,
	restaurantID CHAR(9) NOT NULL,
	savedDate DATE,
	CONSTRAINT pk_Contains_collectionID_restaurantID PRIMARY KEY (collectionID, restaurantID),
	CONSTRAINT fk_Contains_collectionID FOREIGN KEY (collectionID)
		REFERENCES [TIPS.Collection] (collectionID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Contains_restaurantID FOREIGN KEY (restaurantID)
		REFERENCES [TIPS.Restaurant] (restaurantID)
		ON DELETE CASCADE ON UPDATE CASCADE
)

