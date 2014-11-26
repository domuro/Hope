DROP TABLE "RibbonType";
DROP TABLE "MediaType";
DROP TABLE "Friendship";
DROP TABLE "User";
DROP TABLE "Story";
DROP TABLE "Message";
DROP TABLE "UserRibbon";
DROP TABLE "UserReadStory";
DROP TABLE "Media";

CREATE TABLE "RibbonType" (
"RibbonTypeID" serial8 NOT NULL,
"RibbonType" text NOT NULL,
PRIMARY KEY ("RibbonTypeID")
);

CREATE TABLE "MediaType" (
"MediaTypeID" serial8 NOT NULL,
"MediaType" text NOT NULL,
PRIMARY KEY ("MediaTypeID")
);

CREATE TABLE "Friendship" (
"FriendshipID" serial8 NOT NULL,
"UserID1" int8 NOT NULL,
"UserID2" int8 NOT NULL,
"U1Confirm" bool NOT NULL DEFAULT FALSE,
"U2Confirm" bool NOT NULL DEFAULT FALSE,
"CreatedAt" timestamp NOT NULL DEFAULT now(),
PRIMARY KEY ("FriendshipID")
);

CREATE TABLE "User" (
"UserID" serial8 NOT NULL,
"Email" text,
"Password" text,
"UserName" text,
"ProfilePic" varchar(16) DEFAULT 0,
PRIMARY KEY ("UserID") ,
CONSTRAINT "UsernameUnique" UNIQUE ("UserName")
);

CREATE TABLE "Story" (
"StoryID" serial8 NOT NULL,
"UserID" int8 NOT NULL,
"MediaID" int8,
"Message" text,
"CreatedAt" timestamp NOT NULL,
PRIMARY KEY ("StoryID")
);

CREATE TABLE "Message" (
"MessageID" serial8 NOT NULL,
"UserIDTo" int8 NOT NULL,
"UserIDFrom" int8 NOT NULL,
"StoryID" int8,
"MediaType" text,
"MediaID" int8,
"Message" text,
"Read" bool DEFAULT False,
"CreatedAt" timestamp DEFAULT now(),
PRIMARY KEY ("MessageID")
);

CREATE TABLE "UserRibbon" (
"UserRibbonID" serial8 NOT NULL,
"UserID" int8 NOT NULL,
"RibbonTypeID" int8,
"CreatedAt" timestamp DEFAULT now(),
PRIMARY KEY ("UserRibbonID")
);

CREATE TABLE "UserReadStory" (
"UserReadStoryID" serial8 NOT NULL,
"UserID" int8 NOT NULL,
"StoryID" int8 NOT NULL,
"Liked" bool,
"CreatedAt" timestamp DEFAULT now(),
PRIMARY KEY ("UserReadStoryID")
);

CREATE TABLE "Media" (
"MediaID" serial8 NOT NULL,
"MediaType" text NOT NULL,
"Hash" varchar(16) NOT NULL,
"CreatedAt" timestamp NOT NULL,
PRIMARY KEY ("MediaID") ,
CONSTRAINT "MediaHashUnique" UNIQUE ("Hash")
);


ALTER TABLE "Story" ADD CONSTRAINT "UserID" FOREIGN KEY ("UserID") REFERENCES "User" ("UserID");
ALTER TABLE "Message" ADD CONSTRAINT "fk_UserIDTo" FOREIGN KEY ("UserIDTo") REFERENCES "User" ("UserID");
ALTER TABLE "Message" ADD CONSTRAINT "fk_StoryID" FOREIGN KEY ("StoryID") REFERENCES "Story" ("StoryID");
ALTER TABLE "UserRibbon" ADD CONSTRAINT "UserRIbbon_UserID" FOREIGN KEY ("UserID") REFERENCES "User" ("UserID");
ALTER TABLE "UserReadStory" ADD CONSTRAINT "UserReadStory_UserID" FOREIGN KEY ("UserID") REFERENCES "User" ("UserID");
ALTER TABLE "UserReadStory" ADD CONSTRAINT "UserReadStory_StoryID" FOREIGN KEY ("StoryID") REFERENCES "Story" ("StoryID");
ALTER TABLE "Friendship" ADD CONSTRAINT "Friendship_UserID1" FOREIGN KEY ("UserID1") REFERENCES "User" ("UserID");
ALTER TABLE "UserRibbon" ADD CONSTRAINT "UserRibbon_RibbonType" FOREIGN KEY ("RibbonTypeID") REFERENCES "RibbonType" ("RibbonTypeID");
ALTER TABLE "Friendship" ADD CONSTRAINT "Friendship_UserID2" FOREIGN KEY ("UserID2") REFERENCES "User" ("UserID");
ALTER TABLE "Story" ADD CONSTRAINT "MediaID" FOREIGN KEY ("MediaID") REFERENCES "Media" ("MediaID");
