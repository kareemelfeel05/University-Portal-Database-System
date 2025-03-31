CREATE DATABASE PROJECT;
GO
USE PROJECT;
GO
--DROP DATABASE PROJECT;
--IDENTITIES (1, 4, 12,  14, 15, 32, 34, 37)
--deactivate identity insert
--SET IDENTITY_INSERT LEARNER off
--1   --ENTITY
CREATE TABLE Learner (
    LearnerID INT PRIMARY KEY ,
    first_name VARCHAR(20)  ,
    last_name VARCHAR(20)  ,
    gender CHAR(1)  ,
    birth_date DATE  ,
    country VARCHAR(20)  ,
    cultural_background VARCHAR(100)  
);

Go
--2   --MULTIVALUED
CREATE TABLE Skills (
    LearnerID INT  ,
    skill VARCHAR(50)  ,
    PRIMARY KEY (LearnerID, skill),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--3   --MULTIVALUED
CREATE TABLE LearningPreference (
    LearnerID INT  ,
    preference VARCHAR(100)  ,
    PRIMARY KEY (LearnerID, preference),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--4   --WEAK ENTITY
CREATE TABLE PersonalizationProfiles (
    LearnerID INT  ,
    ProfileID INT  ,----
    preferred_content_type VARCHAR(50)  ,--50
    emotional_state VARCHAR(50)  ,
    personality_type VARCHAR(50)  ,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (LearnerID, ProfileID)
);

Go
--5   --MULTIVALUED
CREATE TABLE HealthCondition (
    LearnerID INT  ,
    ProfileID INT  ,
    condition VARCHAR(100)  ,
    PRIMARY KEY (LearnerID, ProfileID,condition),
    FOREIGN KEY (LearnerID, ProfileID) REFERENCES PersonalizationProfiles(LearnerID, ProfileID) ON DELETE CASCADE ON UPDATE CASCADE
);

Go
--6   --ENTITY
CREATE TABLE Course (
    CourseID INT PRIMARY KEY ,
    Title VARCHAR(100)  ,
    learning_objective VARCHAR(250)  ,
    credit_points INT  ,
    difficulty_level VARCHAR(50)  ,
   -- pre_requisites VARCHAR(250)  ,--------------
    description VARCHAR(500)  
);
Go

--MOSTAFA   --RELATIONSHIP
CREATE TABLE Course_Prerequisites (
	CourseID INT  ,
	PreRequisiteID INT  ,
	PRIMARY KEY (CourseID, PreRequisiteID),
	FOREIGN KEY (CourseID) REFERENCES Course(CourseID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (PreRequisiteID) REFERENCES Course(CourseID) -- ON UPDATE CASCADE -- ON DELETE CASCADE
);



--7    --WEAK ENTITY
CREATE TABLE Modules (
    ModuleID INT  ,
    CourseID INT  ,
    Title VARCHAR(100)  ,
    difficulty VARCHAR(50)  ,
    contentURL VARCHAR(250)  ,
    PRIMARY KEY (ModuleID, CourseID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--8   --MULTIVALUED
CREATE TABLE Target_traits (
    ModuleID INT  ,
    CourseID INT  ,
    Trait VARCHAR(100)  ,
    PRIMARY KEY (ModuleID, CourseID,Trait),
    FOREIGN KEY (ModuleID,CourseID) REFERENCES Modules ON DELETE CASCADE ON UPDATE CASCADE,

);
Go
--9  --MULTIVALUED
CREATE TABLE ModuleContent (
    ModuleID INT  ,
    CourseID INT  ,
    content_type VARCHAR(250)  ,
    PRIMARY KEY (ModuleID, CourseID,content_type),
    FOREIGN KEY (ModuleID,CourseID) REFERENCES Modules ON DELETE CASCADE ON UPDATE CASCADE,

);
Go
--10  --ENTITY
CREATE TABLE ContentLibrary (
    ID INT PRIMARY KEY ,
    ModuleID INT  ,
    CourseID INT  ,
    Title VARCHAR(100)  ,
    description VARCHAR(500)  ,
    metadata VARCHAR(250)  ,
    type VARCHAR(50)  ,
    content_URL VARCHAR(250)  ,
    FOREIGN KEY (ModuleID,CourseID) REFERENCES Modules ON DELETE CASCADE ON UPDATE CASCADE,

);
Go
--11  --ENTITY
CREATE TABLE Assessments (
    ID INT PRIMARY KEY ,
    ModuleID INT  ,
    CourseID INT  ,
    type VARCHAR(50)  ,
    total_marks INT  ,
    passing_marks INT  ,
    criteria VARCHAR(250)  ,
    weightage FLOAT  ,
    description VARCHAR(500)  ,
    title VARCHAR(100)  ,
    FOREIGN KEY (ModuleID,CourseID) REFERENCES Modules ON DELETE CASCADE ON UPDATE CASCADE,

);
Go
---   --RELATIONSHIP
CREATE TABLE Taken_assessments (
	LearnerID INT  ,
    AssessmentID INT  ,
    Scored_points INT  ,
    PRIMARY KEY (LearnerID, AssessmentID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (AssessmentID) REFERENCES Assessments(ID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

--12  --ENTITY
CREATE TABLE Learning_activities (
    ActivityID INT PRIMARY KEY ,
    ModuleID INT  ,
    CourseID INT  ,
    activity_type VARCHAR(50)  ,
    instruction_details VARCHAR(MAX),
    Max_points INT  ,
    FOREIGN KEY (ModuleID,CourseID) REFERENCES Modules  ON UPDATE CASCADE ON DELETE CASCADE
);
Go
--13  --ENTITY
CREATE TABLE Interaction_log (
    LogID INT PRIMARY KEY ,
    activity_ID INT  ,
    LearnerID INT  ,
    Duration TIME  ,
    Timestamp DATETIME  ,
    action_type VARCHAR(50)  ,
    FOREIGN KEY (activity_ID) REFERENCES Learning_activities(ActivityID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--14  --ENTITY
CREATE TABLE Emotional_feedback (
    FeedbackID INT PRIMARY KEY ,
    LearnerID INT  ,
    ActivityID INT  ,
    timestamp DATETIME  ,
    emotional_state VARCHAR(50)  ,
    FOREIGN KEY (ActivityID) REFERENCES Learning_activities(ActivityID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--15  --ENTITY
CREATE TABLE Learning_path (
    pathID INT PRIMARY KEY ,
    LearnerID INT  ,
    ProfileID INT  ,
    completion_status VARCHAR(50)  ,
    custom_content VARCHAR(MAX),
    adaptive_rules VARCHAR(MAX),
    FOREIGN KEY (LearnerID, ProfileID) REFERENCES PersonalizationProfiles(LearnerID, ProfileID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--16  --ENTITY
CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY ,
    name VARCHAR(100)  ,
    latest_qualification VARCHAR(100)  ,
    expertise_area VARCHAR(100)  ,
    email VARCHAR(100)  
);
Go
--17  --RELATIONSHIP
CREATE TABLE Pathreview (
    InstructorID INT  ,
    PathID INT  ,
    feedback VARCHAR(500)  ,--review
    PRIMARY KEY (InstructorID, PathID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (PathID) REFERENCES Learning_path(pathID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--18  --RELATIONSHIP
CREATE TABLE Emotionalfeedback_review (
    FeedbackID INT  ,
    InstructorID INT  ,
    feedback VARCHAR(500)  ,--review
    PRIMARY KEY (FeedbackID, InstructorID),
    FOREIGN KEY (FeedbackID) REFERENCES Emotional_feedback(FeedbackID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--19  --ENTITY
CREATE TABLE Course_enrollment (
    EnrollmentID INT PRIMARY KEY ,
    CourseID INT  ,
    LearnerID INT  ,
    completion_date DATE  ,
    enrollment_date DATE  ,
    status VARCHAR(50)  ,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--20  --RELATIONSHIP
CREATE TABLE Teaches (
    InstructorID INT  ,
    CourseID INT  ,
    PRIMARY KEY (InstructorID, CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--21  --ENTITY
CREATE TABLE Leaderboard (
    BoardID INT PRIMARY KEY ,
    season VARCHAR(50)  
);
Go
--22  --RELATIONSHIP
CREATE TABLE Ranking (
    BoardID INT  ,
    LearnerID INT  ,
    CourseID INT  ,
    rank INT  ,
    total_points INT  ,
    PRIMARY KEY (BoardID, LearnerID),
    FOREIGN KEY (BoardID) REFERENCES Leaderboard(BoardID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--23  --ENTITY
CREATE TABLE Learning_goal (
    ID INT PRIMARY KEY ,
    status VARCHAR(MAX),
    deadline DATETIME  ,
    description VARCHAR(MAX)
);
Go
--24  --RELATIONSHIP
CREATE TABLE LearnersGoals (
    GoalID INT  ,
    LearnerID INT  ,
    PRIMARY KEY (GoalID, LearnerID),
    FOREIGN KEY (GoalID) REFERENCES Learning_goal(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--25  --ENTITY
CREATE TABLE Survey (
    ID INT PRIMARY KEY ,
    Title VARCHAR(100)  
);
Go
--26  --MULTIVALUED
CREATE TABLE SurveyQuestions (
    SurveyID INT  ,
    Question VARCHAR(255)  ,
    PRIMARY KEY (SurveyID, Question),
    FOREIGN KEY (SurveyID) REFERENCES Survey(ID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--27  --RELATIONSHIP
CREATE TABLE FilledSurvey (
    SurveyID INT  ,
    Question VARCHAR(255)  ,
    LearnerID INT  ,
    Answer VARCHAR(500)  ,
    PRIMARY KEY (SurveyID, Question, LearnerID),
    FOREIGN KEY (SurveyID, Question) REFERENCES SurveyQuestions(SurveyID, Question) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--28   --ENTITY
CREATE TABLE Notification (
    ID INT PRIMARY KEY ,
    timestamp DATETIME  ,
    message VARCHAR(500)  ,
    urgency_level VARCHAR(50)  ,
);
Go
--29      --RELATIONSHIP
CREATE TABLE ReceivedNotification (
    NotificationID INT  ,
    LearnerID INT  ,
    ReadStatus BIT   DEFAULT 0,
    PRIMARY KEY (NotificationID, LearnerID),
    FOREIGN KEY (NotificationID) REFERENCES Notification(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE
);

Go
--30  --ENTITY
CREATE TABLE Badge (
    BadgeID INT PRIMARY KEY ,
    title VARCHAR(100)  ,
    description VARCHAR(255)  ,
    criteria VARCHAR(255)  ,
    points INT  
);
Go
--31  --ENTITY
CREATE TABLE SkillProgression (
    ID INT PRIMARY KEY ,
    proficiency_level VARCHAR(50)  ,
    LearnerID INT  ,
    skill_name VARCHAR(50)  ,
    timestamp DATETIME  ,
    FOREIGN KEY (LearnerID, skill_name) REFERENCES Skills(LearnerID, skill) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--32  --ENTITY
CREATE TABLE Achievement (
    AchievementID INT PRIMARY KEY ,
    LearnerID INT  ,
    BadgeID INT  ,
    description VARCHAR(MAX),
    date_earned DATE  ,
    type VARCHAR(50)  ,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BadgeID) REFERENCES Badge(BadgeID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--33  --ENTITY
CREATE TABLE Reward (
    RewardID INT PRIMARY KEY ,
    value INT  ,
    description VARCHAR(255)  ,
    type VARCHAR(50)  
);
Go
--34  --ENTITY
CREATE TABLE Quest (
    QuestID INT PRIMARY KEY ,
    difficulty_level VARCHAR(50)  ,
    criteria VARCHAR(50)  ,
    description VARCHAR(50)  ,
    title VARCHAR(50)  
);
Go
--35  --ENTITY
CREATE TABLE Skill_Mastery (
    QuestID INT  ,
    skill VARCHAR(100)  ,
    PRIMARY KEY (QuestID),
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--36  --ENTITY
CREATE TABLE Collaborative (
    QuestID INT  ,
    deadline DATETIME  ,
    max_num_participants INT  ,
    PRIMARY KEY (QuestID),
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go

-------------------------
--RELATIONSHIP
CREATE TABLE LearnerCollaboration(----------------
	QuestID INT  ,
	LearnerID INT  ,
    completion_status VARCHAR(50)  ,---------
	PRIMARY KEY (QuestID, LearnerID),
	FOREIGN KEY (QuestID) REFERENCES Collaborative(QuestID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go

--RELATIONSHIP
CREATE TABLE LearnerMastery(----------------
	QuestID INT  ,
	LearnerID INT  ,
    completion_status VARCHAR(50)  ,---------
	PRIMARY KEY (QuestID, LearnerID),
	FOREIGN KEY (QuestID) REFERENCES Skill_Mastery(QuestID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go



--37  --ENTITY
CREATE TABLE Discussion_forum (
    forumID INT PRIMARY KEY ,
    ModuleID INT  ,
    CourseID INT  ,
    title VARCHAR(50)  ,
    last_active DATETIME  ,
    timestamp DATETIME  ,
    description VARCHAR(50)  ,
    FOREIGN KEY (ModuleID,CourseID) REFERENCES Modules ON DELETE CASCADE ON UPDATE CASCADE
);
Go



--38  --RELATIONSHIP
CREATE TABLE LearnerDiscussion (
    ForumID INT  ,
    LearnerID INT  ,
    Post VARCHAR(500)  ,
    time DATETIME  ,
    PRIMARY KEY (ForumID, LearnerID,Post),
    FOREIGN KEY (ForumID) REFERENCES Discussion_forum(forumID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go


--39  --ENTITY
CREATE TABLE QuestReward (
    RewardID INT  ,
    QuestID INT  ,
    LearnerID INT  ,
    Time_earned DATETIME  ,
    PRIMARY KEY (RewardID, QuestID, LearnerID),
    FOREIGN KEY (RewardID) REFERENCES Reward(RewardID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go


-------------------------------------------------------------------------------
-- NOT IN THE SCHEMA
--Updated by Mostafa  --RELATIONSHIP
CREATE TABLE InstructorDiscussion (
    ForumID INT  ,
    InstructorID INT  ,
    Post VARCHAR(500)  ,
    time DATETIME  ,
    PRIMARY KEY (ForumID, InstructorID, Post),
    FOREIGN KEY (ForumID) REFERENCES Discussion_forum(forumID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go

-- updated by Youssef

CREATE TABLE Join_quest(
	QuestID INT  ,
	LearnerID INT  ,
	PRIMARY KEY (QuestID, LearnerID),
	FOREIGN KEY (QuestID) REFERENCES Quest(QuestID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE
);
Go
--TRIGGERS
----------------------------------------------------------------------------------------------------------------------------
CREATE TRIGGER [dbo].[Trigger1] ON [dbo].[LearnerDiscussion]
AFTER INSERT
AS
BEGIN
UPDATE Discussion_forum
SET last_active = GETDATE()
WHERE forumID IN (SELECT forumID FROM inserted)
END
Go

CREATE TRIGGER [dbo].[Trigger2] ON [dbo].[InstructorDiscussion]
AFTER INSERT
AS
BEGIN
UPDATE Discussion_forum
SET last_active = GETDATE()
WHERE forumID IN (SELECT forumID FROM inserted)
END
Go

CREATE TRIGGER [dbo].[trg_Skill_Mastery_Disjoint] ON [dbo].[Skill_Mastery]
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Collaborative c
        ON i.QuestID = c.QuestID
    )
    BEGIN
        RAISERROR ('QuestID already exists in Collaborative, disjoint constraint violated.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER [dbo].[trg_Collaborative_Disjoint] ON [dbo].[Collaborative]
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Skill_Mastery sm
        ON i.QuestID = sm.QuestID
    )
    BEGIN
        RAISERROR ('QuestID already exists in Skill_Mastery, disjoint constraint violated.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER [dbo].[Trigger3] ON [dbo].[LearnerCollaboration]
AFTER INSERT
AS
BEGIN
INSERT INTO Join_quest (QuestID, LearnerID) VALUES((SELECT TOP(1) QuestID FROM inserted), (SELECT TOP(1) LearnerID FROM INSERTED))
END
Go

CREATE TRIGGER [dbo].[Trigger4] ON [dbo].[LearnerMastery]
AFTER INSERT
AS
BEGIN
INSERT INTO Join_quest (QuestID, LearnerID) VALUES((SELECT TOP(1) QuestID FROM inserted), (SELECT TOP(1) LearnerID FROM INSERTED))
END
Go

