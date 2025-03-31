--CREATE DATABASE PROJECT
GO
USE PROJECT;
GO
--1 As an Admin, I should be able to:
-- 1. ViewInfo: Retrieve all the information for any student using their ID.
CREATE or alter  PROCEDURE ViewInfo (@LearnerID INT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        SELECT * FROM Learner WHERE LearnerID = @LearnerID;
    END
    ELSE
    BEGIN
        SELECT 'Learner not found' AS Message;
    END
END;
GO

-- 2. LearnerInfo: Retrieve all the information from all the profiles of a certain learner.
CREATE or alter PROCEDURE LearnerInfo (@LearnerID INT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        SELECT * FROM PersonalizationProfiles WHERE LearnerID = @LearnerID;
    END
    ELSE
    BEGIN
        SELECT 'Learner not found' AS Message;
    END
END;
GO

-- 3. EmotionalState: Retrieve the latest emotional state of a learner.
CREATE or alter PROCEDURE EmotionalState (@LearnerID INT, @emotional_state VARCHAR(50) OUTPUT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        SELECT TOP 1 @emotional_state = emotional_state
        FROM Emotional_feedback
        WHERE LearnerID = @LearnerID
        ORDER BY timestamp DESC;
    END
    ELSE
    BEGIN
        SELECT 'Learner not found' AS Message;
    END
END;
GO

-- 4. LogDetails: View the latest interaction logs for a certain learner.
CREATE or alter PROCEDURE LogDetails (@LearnerID INT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        SELECT * FROM Interaction_log 
        WHERE LearnerID = @LearnerID 
        ORDER BY Timestamp DESC;
    END
    ELSE
    BEGIN
        SELECT 'Learner not found' AS Message;
    END
END;
GO

-- 5. InstructorReview: View all the emotional feedbacks that a certain instructor reviewed.
CREATE or alter PROCEDURE InstructorReview (@InstructorID INT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Instructor WHERE InstructorID = @InstructorID)
    BEGIN
        SELECT ef.*, er.feedback
        FROM Emotional_feedback ef
        JOIN Emotionalfeedback_review er ON ef.FeedbackID = er.FeedbackID
        WHERE er.InstructorID = @InstructorID;
    END
    ELSE
    BEGIN
        SELECT 'Instructor not found' AS Message;
    END
END;
GO

-- 6. CourseRemove: Delete a course from the database when it's no longer being taught.
CREATE or alter PROCEDURE CourseRemove (@CourseID INT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course WHERE CourseID = @CourseID)
    BEGIN
        DELETE FROM Course WHERE CourseID = @CourseID;
        SELECT 'Course removed successfully' AS Confirmation;
    END
    ELSE
    BEGIN
        SELECT 'Course not found' AS Message;
    END
END;
GO

-- 7. Highestgrade: View the assessment with the highest maximum points for each course.
CREATE or alter PROCEDURE Highestgrade 
AS
BEGIN
    SELECT a1.*
    FROM Assessments a1
    WHERE a1.total_marks = (
        SELECT MAX(a2.total_marks) 
        FROM Assessments a2 
        WHERE a2.CourseID = a1.CourseID
    );
END;
GO

-- 8. InstructorCount: View all the courses taught by more than one instructor.
CREATE or alter PROCEDURE InstructorCount 
AS
BEGIN
    SELECT c.*
    FROM Course c
    WHERE (SELECT COUNT(InstructorID) FROM Teaches WHERE CourseID = c.CourseID) > 1;
END;
GO

-- 9. ViewNot: View all the notifications sent to a certain learner.
CREATE or alter PROCEDURE ViewNot (@LearnerID INT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        SELECT n.*
        FROM Notification n
        JOIN ReceivedNotification rn ON n.ID = rn.NotificationID
        WHERE rn.LearnerID = @LearnerID;
    END
    ELSE
    BEGIN
        SELECT 'Learner not found' AS Message;
    END
END;
GO

-- 10. CreateDiscussion: Create a new discussion forum for a given module.
CREATE or alter PROCEDURE CreateDiscussion 
    @ModuleID INT, 
    @CourseID INT, 
    @title VARCHAR(100), 
    @description VARCHAR(255)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Modules WHERE @ModuleID = ModuleID AND @CourseID = CourseID)
    BEGIN
        DECLARE @ForumID INT;
        SET @ForumID = (SELECT MAX(forumID) FROM Discussion_forum) + 1;
        
        -- Insert the new discussion forum
        INSERT INTO Discussion_forum (forumID, ModuleID, CourseID, title, last_active, timestamp, description)
        VALUES (@ForumID, @ModuleID, @CourseID, @title, GETDATE(), GETDATE(), @description);
        
        SELECT 'Forum created successfully' AS Confirmation;
    END
    ELSE
    BEGIN
        SELECT 'No such module or course exists' AS Confirmation;
    END
END;
GO
---------------------sec-----------
-- 11. RemoveBadge: Remove a certain badge from the database.
-- 11. RemoveBadge: Delete a badge by its ID.
CREATE OR ALTER PROCEDURE RemoveBadge (@BadgeID INT)
AS
BEGIN
    -- Check if the Badge exists
    IF EXISTS (SELECT 1 FROM Badge WHERE BadgeID = @BadgeID)
    BEGIN
        -- Delete the Badge
        DELETE FROM Badge WHERE BadgeID = @BadgeID;
        SELECT 'Badge removed successfully' AS Confirmation;
    END
    ELSE
    BEGIN
        -- Badge does not exist
        SELECT 'BadgeID does not exist' AS Confirmation;
    END
END;
GO

-- 12. CriteriaDelete: Delete all the available quests that belong to a certain criterion.
CREATE OR ALTER PROCEDURE CriteriaDelete (@criteria VARCHAR(50))
AS
BEGIN
    -- Check if the criterion exists
    IF EXISTS (SELECT 1 FROM Quest WHERE criteria = @criteria)
    BEGIN
        DELETE FROM Quest WHERE criteria = @criteria;
        SELECT 'Quests with the given criterion removed successfully' AS Confirmation;
    END
    ELSE
    BEGIN
        SELECT 'No quests found with the specified criterion' AS Message;
    END
END;
GO

-- 13. NotificationUpdate: Mark notifications as read or delete them.
CREATE OR ALTER PROCEDURE NotificationUpdate (@LearnerID INT, @NotificationID INT, @ReadStatus BIT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM ReceivedNotification rn WHERE rn.LearnerID=@LearnerID AND rn.NotificationID=@NotificationID)
    BEGIN
    DELETE ReceivedNotification
    WHERE LearnerID = @LearnerID AND NotificationID = @NotificationID;
    END
    ELSE
    PRINT 'No such learner of notification exists'
END;
GO

-- 14. EmotionalTrendAnalysis: View emotional feedback trends from a specific time until up to date for each learner to support well-being.
CREATE OR ALTER PROCEDURE EmotionalTrendAnalysis (@CourseID INT, @ModuleID INT, @TimePeriod DATETIME)
AS
BEGIN
    -- Check if the course and module exist
    IF EXISTS (SELECT 1 FROM Modules WHERE ModuleID = @ModuleID AND CourseID = @CourseID)
    BEGIN
        SELECT LearnerID, emotional_state, timestamp
        FROM Emotional_feedback ef
        JOIN Learning_activities la ON ef.ActivityID = la.ActivityID
        WHERE la.CourseID = @CourseID AND la.ModuleID = @ModuleID
        AND timestamp BETWEEN @TimePeriod AND GETDATE()
        ORDER BY timestamp DESC;
    END
    ELSE
    BEGIN
        SELECT 'Specified course or module does not exist' AS Message;
    END
END;
GO

----------------------------------------------------------------------------------------------------------------------------
--2 As an Learner, I should be able to:
/*
 
1) Update my profile with new details.
Signature:
Name: ProfileUpdate.
Input: @learnerID int, @ProfileID int, @PreferedContentType varchar(50), @emotional_state varchar(50), @PersonalityType varchar(50).
Output: Nothing.
*/
GO
CREATE OR ALTER PROCEDURE ProfileUpdate
    @learnerID INT,
    @ProfileID INT,
    @PreferedContentType VARCHAR(50),
    @emotional_state VARCHAR(50),
    @PersonalityType VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM PersonalizationProfiles WHERE LearnerID = @learnerID AND ProfileID = @ProfileID)
    BEGIN
        UPDATE PersonalizationProfiles
        SET preferred_content_type = @PreferedContentType,
            emotional_state = @emotional_state,
            personality_type = @PersonalityType
        WHERE LearnerID = @learnerID AND ProfileID = @ProfileID;
    END
    ELSE
    BEGIN
        PRINT 'Error: LearnerID or ProfileID does not exist.';
    END
END;
GO

/*
2) Calculate the total points I earned from the rewards.
Signature:
Name: TotalPoints.
Input: @LearnerID int, @RewardType varchar(50).
Output: Total number of points.
*/
GO
CREATE OR ALTER PROCEDURE TotalPoints
    @LearnerID INT,
    @RewardType VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM QuestReward WHERE LearnerID = @LearnerID)
    BEGIN
        DECLARE @TotalPoints INT;

        SELECT @TotalPoints = SUM(value)
        FROM Reward
        JOIN QuestReward ON Reward.RewardID = QuestReward.RewardID
        WHERE QuestReward.LearnerID = @LearnerID
        AND Reward.type = @RewardType;

        IF @TotalPoints IS NULL
            SET @TotalPoints = 0;

        SELECT @TotalPoints AS TotalPoints;
    END
    ELSE
    BEGIN
        PRINT 'Error: LearnerID does not have any rewards.';
    END
END;
GO

/*
3) Display all the courses I’m currently enrolled in.
Signature:
Name: EnrolledCourses.
Input: @LearnerID int.
Output: Table containing all courses I’m enrolled in.
*/
GO
CREATE OR ALTER PROCEDURE EnrolledCourses
    @LearnerID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course_enrollment WHERE LearnerID = @LearnerID)
    BEGIN
        SELECT c.* 
        FROM Course_enrollment ce
        JOIN Course c ON ce.CourseID = c.CourseID
        WHERE ce.LearnerID = @LearnerID;
    END
    ELSE
    BEGIN
        PRINT 'Error: LearnerID is not enrolled in any courses.';
    END
END;
GO

/*
4) Check prerequisites before enrolling in a course.
Signature:
Name: Prerequisites.
Input: @LearnerID int, @CourseID int.
Output: Message indicating prerequisites status.
*/
GO
CREATE OR ALTER PROCEDURE Prerequisites
    @LearnerID INT,
    @CourseID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course WHERE CourseID = @CourseID)
    BEGIN
        IF EXISTS (SELECT 1 FROM Course_enrollment WHERE LearnerID = @LearnerID AND CourseID = @CourseID)
        BEGIN
            PRINT 'Error: Learner already registered for this course.';
        END
        ELSE
        BEGIN
            DECLARE @UnmetPrereqsCount INT;

            SELECT @UnmetPrereqsCount = COUNT(*)
            FROM Course_Prerequisites cp
            LEFT JOIN Course_enrollment ce ON cp.PrerequisiteID = ce.CourseID AND ce.LearnerID = @LearnerID
            WHERE cp.CourseID = @CourseID AND (ce.CourseID IS NULL OR ce.status != 'completed');

            IF @UnmetPrereqsCount > 0
                PRINT 'Not all prerequisites are completed.';
            ELSE
                PRINT 'All prerequisites are completed.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Error: CourseID does not exist.';
    END
END;
GO

/*
5) View all the modules for a certain course that train specific traits.
Signature:
Name: ModuleTraits.
Input: @TargetTrait varchar(50), @CourseID int.
Output: List of all suitable modules.
*/
GO
CREATE OR ALTER PROCEDURE ModuleTraits
    @TargetTrait VARCHAR(50),
    @CourseID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course WHERE CourseID = @CourseID)
    BEGIN
        SELECT m.* 
        FROM Target_traits t
        JOIN Modules m ON t.CourseID = m.CourseID AND t.ModuleID = m.ModuleID
        WHERE t.Trait = @TargetTrait AND t.CourseID = @CourseID;
    END
    ELSE
    BEGIN
        PRINT 'Error: CourseID does not exist.';
    END
END;
GO

/*
6) View all the participants in a leaderboard and their ranking.
Signature:
Name: LeaderboardRank.
Input: @LeaderboardID int.
Output: Table containing leaderboard rankings.
*/
GO
CREATE OR ALTER PROCEDURE LeaderboardRank
    @LeaderboardID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Leaderboard WHERE BoardID = @LeaderboardID)
    BEGIN
        SELECT r.*, l.first_name AS LearnerName
        FROM Ranking r
        JOIN Learner l ON r.LearnerID = l.LearnerID
        WHERE r.BoardID = @LeaderboardID;
    END
    ELSE
    BEGIN
        PRINT 'Error: LeaderboardID does not exist.';
    END
END;
GO

/*
7) Submit emotional feedback for a specific activity.
Signature:
Name: SubmitEmotionalFeedback.
Input: @ActivityID int, @LearnerID int, @timestamp datetime, @emotionalstate varchar(50).
Output: Nothing.
*/
GO
CREATE OR ALTER PROCEDURE ActivityEmotionalFeedback
    @ActivityID INT,
    @LearnerID INT,
    @timestamp DATETIME,
    @emotionalstate VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learning_activities WHERE ActivityID = @ActivityID)
    BEGIN
        DECLARE @FeedbackID INT;
        SET @FeedbackID = (SELECT ISNULL(MAX(FeedbackID), 0) + 1 FROM Emotional_feedback);

        INSERT INTO Emotional_feedback (FeedbackID, ActivityID, LearnerID, timestamp, emotional_state)
        VALUES (@FeedbackID, @ActivityID, @LearnerID, @timestamp, @emotionalstate);
    END
    ELSE
    BEGIN
        PRINT 'Error: ActivityID does not exist.';
    END
END;
GO

/*
8) Join a collaborative quest if space is available.
Signature:
Name: JoinQuest.
Input: @LearnerID int, @QuestID int.
Output: A message with approval or rejection.
*/
GO
CREATE OR ALTER PROCEDURE JoinQuest
    @LearnerID INT,
    @QuestID INT
AS
BEGIN
    IF (EXISTS (SELECT 1 FROM Collaborative WHERE QuestID = @QuestID) And exists (SELECT 1 FROM Learner l where @LearnerID = l.LearnerID))
    BEGIN
        IF EXISTS (SELECT 1 FROM LearnerCollaboration WHERE QuestID = @QuestID AND LearnerID = @LearnerID)
        BEGIN
            PRINT 'Error: Learner already registered for this quest.';
        END
        ELSE
        BEGIN
            DECLARE @MaxParticipants INT;
            DECLARE @CurrentParticipants INT;

            SELECT @MaxParticipants = max_num_participants FROM Collaborative WHERE QuestID = @QuestID;
            SELECT @CurrentParticipants = COUNT(*) FROM LearnerCollaboration WHERE QuestID = @QuestID;

            IF @CurrentParticipants < @MaxParticipants
            BEGIN
                INSERT INTO LearnerCollaboration (QuestID, LearnerID, completion_status)
                VALUES (@QuestID, @LearnerID, 'In Progress');

                PRINT 'Approval: You have successfully joined the collaborative quest.';
            END
            ELSE
            BEGIN
                PRINT 'Rejection: The collaborative quest is full.';
            END
        END
    END
    ELSE
    BEGIN
        PRINT 'Error: Collaborative QuestID or Learner does not exist.';
    END
END;
GO

/*
9) View my skills proficiency level.
Signature:
Name: SkillsProficiency.
Input: @LearnerID int.
Output: A table with my skills and proficiency level.
*/
GO
CREATE OR ALTER PROCEDURE SkillsProficiency
    @LearnerID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM SkillProgression WHERE LearnerID = @LearnerID)
    BEGIN
        SELECT skill_name, proficiency_level
FROM SkillProgression sp
WHERE LearnerID = @LearnerID
AND sp.timestamp = (
    SELECT MAX(sp2.timestamp)
    FROM SkillProgression sp2
    WHERE sp2.LearnerID = sp.LearnerID
    AND sp2.skill_name = sp.skill_name
);
    END
    ELSE
    BEGIN
        PRINT 'Error: The learner with this id does not have any skills recorded.';
    END
END;
GO

/*
10) View my score for a certain assessment.
Signature:
Name: ViewScore.
Input: @LearnerID int, @AssessmentID int.
Output: @score.
*/
GO
CREATE OR ALTER PROCEDURE ViewScore
    @LearnerID INT,
    @AssessmentID INT,
    @score INT OUTPUT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Taken_assessments WHERE LearnerID = @LearnerID AND AssessmentID = @AssessmentID)
    BEGIN
        SELECT @score = Scored_points
        FROM Taken_assessments
        WHERE LearnerID = @LearnerID AND AssessmentID = @AssessmentID;
    END
    ELSE
    BEGIN
        PRINT 'Error: LearnerID or AssessmentID does not exist.';
    END
END;
GO

/*
11) View all the assessments I took and its grades for a certain module.
Signature:
Name: AssessmentsList.
Input: @courseID int, @ModuleID int.
Output: A table containing all the assessments and their grades.
*/
----------------------------------------
CREATE OR ALTER PROC AssessmentsList 
    @LearnerID INT,
    @courseID INT, 
    @ModuleID INT
AS 
BEGIN 
    IF EXISTS (SELECT 1 FROM Assessments WHERE CourseID = @courseID AND ModuleID = @ModuleID) and Exists (select 1 from Learner l where l.LearnerID = @LearnerID)
    BEGIN
        SELECT 
            a.ID AS AssessmentID,
            a.title AS AssessmentTitle,
            a.type AS AssessmentType,
            a.total_marks AS TotalMarks,
            ta.Scored_points AS Grade
        FROM 
            Assessments a
        JOIN 
            Taken_Assessments ta ON a.ID = ta.AssessmentID
        WHERE 
            a.CourseID = @courseID AND 
            a.ModuleID = @ModuleID
            and ta.LearnerID = @LearnerID;
    END
    ELSE
    BEGIN
      if Exists (select 1 from Learner l where l.LearnerID = @LearnerID)
        PRINT 'No assessments found for the given CourseID and ModuleID and LearnerID.';
        else
        PRINT 'No such learner found';
    END
END;
GO
/*
12) Register in any course I want as long as I completed its prerequisites.
Signature:
Name: Courseregister.
Input: @LearnerID int, @CourseID int.
Output: A statement with the approval or rejection of registration.
*/
CREATE OR ALTER PROCEDURE Courseregister
    @LearnerID INT,
    @CourseID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID) AND EXISTS (SELECT 1 FROM Course WHERE CourseID = @CourseID)
    BEGIN
        IF EXISTS (SELECT 1 FROM Course_enrollment WHERE CourseID = @CourseID AND LearnerID = @LearnerID)
        BEGIN
            PRINT 'Error: Learner already registered for this Course.';
        END
        ELSE 
        BEGIN
            DECLARE @UnmetPrereqsCount INT;
            SELECT @UnmetPrereqsCount = COUNT(*)
            FROM Course_Prerequisites cp
            LEFT JOIN Course_enrollment ce ON cp.PrerequisiteID = ce.CourseID AND ce.LearnerID = @LearnerID
            WHERE cp.CourseID = @CourseID AND (ce.CourseID IS NULL OR ce.status != 'completed');

            IF @UnmetPrereqsCount > 0
            BEGIN
                PRINT 'Not all prerequisites are completed.';
            END
            ELSE
            BEGIN
                DECLARE @EnrollmentID INT = ISNULL((SELECT MAX(EnrollmentID) FROM Course_enrollment), 0) + 1;
                INSERT INTO Course_enrollment (EnrollmentID, CourseID, LearnerID, enrollment_date, status)
                VALUES (@EnrollmentID, @CourseID, @LearnerID, GETDATE(), 'In Progress');
                PRINT 'Success: Registration completed.';
            END
        END
    END
    ELSE
    BEGIN
        PRINT 'Error: LearnerID or CourseID does not exist.';
    END
END;
GO

/*
13) Add any post to an existing discussion forum.
Signature:
Name: Post.
Input: @LearnerID int, @DiscussionID int, @Post varchar(max).
Output: None.
*/
CREATE OR ALTER PROCEDURE Post
    @LearnerID INT,
    @DiscussionID INT,
    @Post VARCHAR(MAX)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID) AND EXISTS (SELECT 1 FROM DiscussionForum WHERE ForumID = @DiscussionID)
    BEGIN
        INSERT INTO LearnerDiscussion (ForumID, LearnerID, Post, time)
        VALUES (@DiscussionID, @LearnerID, @Post, GETDATE());
        PRINT 'Post added successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Error: LearnerID or DiscussionID does not exist.';
    END
END;
GO

/*
14) Add new learning goals for myself.
Signature:
Name: AddGoal.
Input: @LearnerID int, @GoalID int.
Output: None.
*/
CREATE OR ALTER PROCEDURE AddGoal
    @LearnerID INT, 
    @GoalID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID) AND EXISTS (SELECT 1 FROM Learning_goal WHERE ID = @GoalID)
    BEGIN
        INSERT INTO LearnersGoals (GoalID, LearnerID)
        VALUES (@GoalID, @LearnerID);
        PRINT 'Goal added successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Error: LearnerID or GoalID does not exist.';
    END
END;
GO

/*
15) View all the current statuses of my learning paths.
Signature:
Name: CurrentPath.
Input: @LearnerID int.
Output: List of the current learning paths for the learner and their status.
*/
CREATE OR ALTER PROCEDURE CurrentPath
    @LearnerID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        SELECT *
        FROM Learning_path
        WHERE LearnerID = @LearnerID;
    END
    ELSE
    BEGIN
        PRINT 'Error: LearnerID does not exist.';
    END
END;
GO

--exec CurrentPath @LearnerID = 1;
/*
16) View all the members participating in all the collaborative quests that I am participating in and whose deadline has not passed yet.
Signature:
Name: QuestMembers.
Input: @LearnerID int.
Output: List of the quests and the members in it.
*/
CREATE OR ALTER PROCEDURE QuestMembers
    @LearnerID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        SELECT 
            q.QuestID,
            q.title AS QuestTitle,
            l.LearnerID,
            l.first_name,
            l.last_name
        FROM 
            Quest q
        JOIN 
            Collaborative c ON q.QuestID = c.QuestID
        JOIN 
            LearnerCollaboration jc ON c.QuestID = jc.QuestID
        JOIN 
            Learner l ON jc.LearnerID = l.LearnerID AND @LearnerID != l.LearnerID
        WHERE 
            jc.QuestID IN (
                SELECT jc2.QuestID
                FROM LearnerCollaboration jc2
                WHERE jc2.LearnerID = @LearnerID
            )
            AND c.deadline > GETDATE()
        ORDER BY 
            q.QuestID, l.LearnerID;
    END
    ELSE
    BEGIN
        PRINT 'Error: LearnerID does not exist.';
    END
END;
GO

/*
17) View my progress toward earning badges or completing quests.
Signature:
Name: QuestProgress.
Input: @LearnerID int.
Output: Table showing completion status for active quests and badges.
*/
CREATE OR ALTER PROCEDURE QuestProgress
    @LearnerID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        -- Collaborative progress
        SELECT Q.QuestID, Q.Title, LC.completion_status 
        FROM LearnerCollaboration LC 
        INNER JOIN Quest Q ON LC.QuestID = Q.QuestID
        WHERE LC.LearnerID = @LearnerID

        UNION 

        -- Skill mastery progress
        SELECT Q.QuestID, Q.Title, LM.completion_status
        FROM LearnerMastery LM 
        INNER JOIN Quest Q ON LM.QuestID = Q.QuestID
        WHERE LM.LearnerID = @LearnerID

        UNION  

        -- Non-collaborative, non-skill mastery quest progress
        SELECT q.QuestID, q.title, 
            CASE 
                WHEN qr.LearnerID IS NOT NULL THEN 'Completed' 
                ELSE 'Not Completed' 
            END AS Completion_Status
        FROM Quest q 
        LEFT JOIN QuestReward qr ON q.QuestID = qr.QuestID AND qr.LearnerID = @LearnerID

        UNION ALL

        -- Badge progress
        SELECT 
            b.BadgeID, b.title, 
            CASE 
                WHEN a.LearnerID IS NOT NULL THEN 'Earned'
                ELSE 'Not Earned'
            END AS Completion_Status
        FROM Badge b 
        LEFT JOIN Achievement a ON b.BadgeID = a.BadgeID AND a.LearnerID = @LearnerID;
    END
    ELSE
    BEGIN
        PRINT 'Error: LearnerID does not exist.';
    END
END;
GO

/*
18) Receive reminders if I am falling behind on learning goals timeline.
Signature:
Name: GoalReminder.
Input: @LearnerID int.
Output: Notification message with reminder details.
*/
CREATE OR ALTER PROCEDURE GoalReminder
    @LearnerID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        DECLARE @CurrentDate DATETIME = GETDATE();
        DECLARE @Message VARCHAR(MAX) = '';

        SELECT @Message = @Message + lg.description + ', '
        FROM Learning_goal lg
        JOIN LearnersGoals lg_rel ON lg.ID = lg_rel.GoalID
        WHERE lg_rel.LearnerID = @LearnerID AND lg.deadline < @CurrentDate;

        IF @Message IS NOT NULL AND @Message != ''
        BEGIN
            DECLARE @LastID INT;
            SELECT @LastID = MAX(ID) FROM Notification;

            IF @LastID IS NULL SET @LastID = 0;

            INSERT INTO Notification (ID, timestamp, message, urgency_level)
            VALUES (@LastID + 1, GETDATE(), 'Reminder: You are falling behind on your goals: ' + @Message, 'High');

            INSERT INTO ReceivedNotification (NotificationID, LearnerID)
            VALUES (@LastID + 1, @LearnerID);

            PRINT 'OH NO, you have close deadline goals: ' + @Message;
        END
        ELSE
        BEGIN
            PRINT 'No overdue goals found for the learner.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Error: LearnerID does not exist.';
    END
END;
GO

/*
19) Track my skill progression over time.
Signature:
Name: SkillProgressHistory.
Input: @LearnerID int, @Skill varchar(50).
Output: A table displaying skill progression over time.
*/
CREATE OR ALTER PROCEDURE SkillProgressHistory
    @LearnerID INT,
    @Skill VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        SELECT proficiency_level, timestamp
        FROM SkillProgression
        WHERE LearnerID = @LearnerID AND skill_name = @Skill
        ORDER BY timestamp;
    END
    ELSE
    BEGIN
        PRINT 'Error: LearnerID does not exist.';
    END
END;
GO

/*
20) Access a breakdown of my assessment scores to identify strengths and weaknesses.
Signature:
Name: AssessmentAnalysis.
Input: @LearnerID int.
Output: Table with detailed score breakdowns and performance analysis.
*/
CREATE OR ALTER PROCEDURE AssessmentAnalysis
    @LearnerID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        SELECT 
            a.ID AS AssessmentID,
            a.title AS AssessmentTitle,
            a.type AS AssessmentType,
            a.total_marks AS TotalMarks,
            ta.Scored_points AS ScoredPoints,
            (ta.Scored_points * 100.0 / a.total_marks) AS Percentage,
            CASE 
                WHEN (ta.Scored_points * 100.0 / a.total_marks) >= 90 THEN 'Excellent'
                WHEN (ta.Scored_points * 100.0 / a.total_marks) >= 75 THEN 'Good'
                WHEN (ta.Scored_points * 100.0 / a.total_marks) >= 50 THEN 'Average'
                ELSE 'Needs Improvement'
            END AS Performance
        FROM Assessments a
        JOIN Taken_assessments ta ON a.ID = ta.AssessmentID
        WHERE ta.LearnerID = @LearnerID
        ORDER BY a.ID;
    END
    ELSE
    BEGIN
        PRINT 'Error: LearnerID does not exist.';
    END
END;
GO

/*
21) Filter or sort leaderboards by my rank descendingly.
Signature:
Name: LeaderboardFilter.
Input: @LearnerID int.
Output: A table with filtered leaderboard rankings.
*/
CREATE OR ALTER PROCEDURE LeaderboardFilter
    @LearnerID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        SELECT 
            r.BoardID,
            r.LearnerID,
            r.CourseID,
            r.rank,
            r.total_points,
            c.Title,
            c.credit_points
        FROM 
            Ranking r
        JOIN 
            Course c ON c.CourseID = r.CourseID
        WHERE 
            r.LearnerID = @LearnerID
        ORDER BY 
            r.rank  ; 
    END
    ELSE
    BEGIN
        PRINT 'Error: LearnerID does not exist.';
    END
END;
GO
 GO

----------------------------------------------------------------------------------------------------------------------------
--3 As an instructor, I should be able to:
-- 1. SkillLearners: List all learners that have a certain skill.
CREATE OR ALTER PROCEDURE SkillLearners (@SkillName VARCHAR(50))
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Skills WHERE skill = @SkillName)
    BEGIN
        SELECT s.skill, l.*
        FROM Learner l
        JOIN Skills s ON l.LearnerID = s.LearnerID
        WHERE s.skill = @SkillName;
    END
    ELSE
    BEGIN
        PRINT 'Skill not found.';
    END
END;
GO

-- 2. NewActivity: Add new learning activities for a course module.
CREATE OR ALTER PROCEDURE NewActivity 
    (@CourseID INT, @ModuleID INT, @ActivityType VARCHAR(50), @InstructionDetails VARCHAR(MAX), @MaxPoints INT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Modules WHERE ModuleID = @ModuleID AND CourseID = @CourseID)
    BEGIN
        DECLARE @ActivityID INT;
        SET @ActivityID = ISNULL((SELECT MAX(ActivityID) FROM Learning_activities), 0) + 1;
        INSERT INTO Learning_activities 
        VALUES (@ActivityID, @ModuleID, @CourseID, @ActivityType, @InstructionDetails, @MaxPoints);
    END
    ELSE
    BEGIN
        PRINT 'Invalid ModuleID or CourseID.';
    END
END;
GO

-- 3. NewAchievement: Award a new achievement to a learner.
CREATE OR ALTER PROCEDURE NewAchievement 
    (@LearnerID INT, @BadgeID INT, @Description VARCHAR(MAX), @DateEarned DATE, @Type VARCHAR(50))
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID) 
    AND EXISTS (SELECT 1 FROM Badge WHERE BadgeID = @BadgeID)
    BEGIN
        DECLARE @AchievementID INT;
        SET @AchievementID = ISNULL((SELECT MAX(AchievementID) FROM Achievement), 0) + 1;
        INSERT INTO Achievement 
        VALUES (@AchievementID, @LearnerID, @BadgeID, @Description, @DateEarned, @Type);
    END
    ELSE
    BEGIN
        PRINT 'Invalid LearnerID or BadgeID.';
    END
END;
GO

-- 4. LearnerBadge: View all the learners who earned a certain badge.
CREATE OR ALTER PROCEDURE LearnerBadge (@BadgeID INT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Badge WHERE BadgeID = @BadgeID)
    BEGIN
        SELECT l.*
        FROM Achievement a
        JOIN Learner l ON a.LearnerID = l.LearnerID
        WHERE a.BadgeID = @BadgeID;
    END
    ELSE
    BEGIN
        PRINT 'Badge not found.';
    END
END;
GO

-- 5. NewPath: Add a new learning path for a learner.
CREATE OR ALTER PROCEDURE NewPath 
    (@LearnerID INT, @ProfileID INT, @CompletionStatus VARCHAR(50), @CustomContent VARCHAR(MAX), @AdaptiveRules VARCHAR(MAX))
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        DECLARE @PathID INT;
        SET @PathID = ISNULL((SELECT MAX(PathID) FROM Learning_path), 0) + 1;
        INSERT INTO Learning_path 
        VALUES (@PathID, @LearnerID, @ProfileID, @CompletionStatus, @CustomContent, @AdaptiveRules);
    END
    ELSE
    BEGIN
        PRINT 'Learner not found.';
    END
END;
GO

-- 6. TakenCourses: View all the courses that a learner has taken.
CREATE OR ALTER PROCEDURE TakenCourses (@LearnerID INT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        SELECT c.*
        FROM Course c
        JOIN Course_enrollment e ON c.CourseID = e.CourseID
        WHERE e.LearnerID = @LearnerID AND e.status = 'Completed';
    END
    ELSE
    BEGIN
        PRINT 'Learner not found.';
    END
END;
GO

-- 7. CollaborativeQuest: Add a new collaborative quest.
CREATE OR ALTER PROCEDURE CollaborativeQuest 
    (@difficulty_level VARCHAR(50), @criteria VARCHAR(50), @description VARCHAR(50), @title VARCHAR(50), @Maxnumparticipants INT, @deadline DATETIME)
AS
BEGIN
    DECLARE @QuestID INT;
    SET @QuestID = ISNULL((SELECT MAX(QuestID) FROM Quest), 0) + 1;
    INSERT INTO Quest 
    VALUES (@QuestID, @difficulty_level, @criteria, @description, @title);
    INSERT INTO Collaborative 
    VALUES (@QuestID, @deadline, @Maxnumparticipants);
END;
GO

-- 8. DeadlineUpdate: Update the deadline of a quest.
CREATE OR ALTER PROCEDURE DeadlineUpdate (@QuestID INT, @Deadline DATETIME)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Collaborative WHERE QuestID = @QuestID)
    BEGIN
        UPDATE Collaborative
        SET deadline = @Deadline
        WHERE QuestID = @QuestID;
    END
    ELSE
    BEGIN
        PRINT 'Quest not found.';
    END
END;
GO

-- 9. GradeUpdate: Update an assessment grade for a learner.
CREATE OR ALTER PROCEDURE GradeUpdate (@LearnerID INT, @AssessmentID INT, @points INT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Taken_assessments WHERE LearnerID = @LearnerID AND AssessmentID = @AssessmentID)
    BEGIN
        UPDATE Taken_assessments
        SET Scored_points = @points
        WHERE LearnerID = @LearnerID AND AssessmentID = @AssessmentID;
        SELECT 'Grade updated successfully' AS Confirmation;
    END
    ELSE
    BEGIN
        SELECT 'Learner has not taken this assessment' AS Confirmation;
    END
END;
GO

-- 10. AssessmentNot: Send a notification about an upcoming assessment deadline.
CREATE OR ALTER PROCEDURE AssessmentNot 
    (@NotificationID INT, @Timestamp DATETIME, @Message VARCHAR(MAX), @UrgencyLevel VARCHAR(50), @LearnerID INT)
AS
BEGIN
    DECLARE @confirmation VARCHAR(MAX);

    IF EXISTS (SELECT 1 FROM Notification WHERE ID = @NotificationID)
    BEGIN
        SET @confirmation = 'Notification already exists.';
    END
    ELSE
    BEGIN
        INSERT INTO Notification (ID, Timestamp, Message, urgency_level)
        VALUES (@NotificationID, @Timestamp, @Message, @UrgencyLevel);
        SET @confirmation = 'Notification inserted successfully.';
    END

    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        IF EXISTS (SELECT 1 FROM ReceivedNotification WHERE LearnerID = @LearnerID AND NotificationID = @NotificationID)
        BEGIN
            SET @confirmation += ' Notification already sent to the learner.';
        END
        ELSE
        BEGIN
            INSERT INTO ReceivedNotification (LearnerID, NotificationID)
            VALUES (@LearnerID, @NotificationID);
            SET @confirmation += ' Notification sent to learner successfully.';
        END
    END
    ELSE
    BEGIN
        SET @confirmation += ' Learner does not exist, notification not sent.';
    END

    SELECT @confirmation AS Confirmation;
END;
GO

-- 11. NewGoal: Define a new learning goal for learners.
CREATE OR ALTER PROCEDURE NewGoal (@GoalID INT, @Status VARCHAR(MAX), @Deadline DATETIME, @Description VARCHAR(MAX))
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Learning_goal WHERE ID = @GoalID)
    BEGIN
        INSERT INTO Learning_goal (ID, Status, deadline, Description)
        VALUES (@GoalID, @Status, @Deadline, @Description);
    END
    ELSE
    BEGIN
        PRINT 'GoalID already exists.';
    END
END;
GO

-- 12. List all the learners enrolled in the courses I teach.
CREATE OR ALTER PROCEDURE LearnersCourses (@CourseID INT, @InstructorID INT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Teaches WHERE CourseID = @CourseID AND InstructorID = @InstructorID)
    BEGIN
        SELECT l.*, c.*
        FROM Teaches t
        JOIN Course c ON t.CourseID = c.CourseID
        JOIN Course_enrollment e ON c.CourseID = e.CourseID
        JOIN Learner l ON e.LearnerID = l.LearnerID
        WHERE t.InstructorID = @InstructorID AND c.CourseID = @CourseID;
    END
    ELSE
    BEGIN
        PRINT 'No teaching assignment found for given InstructorID and CourseID.';
    END
END;
GO

-- 13. See the last time a discussion forum was active.
CREATE OR ALTER PROCEDURE LastActive (@ForumID INT, @LastActive DATETIME OUTPUT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Discussion_forum WHERE ForumID = @ForumID)
    BEGIN
        SELECT @LastActive = last_active FROM Discussion_forum WHERE ForumID = @ForumID;
    END
    ELSE
    BEGIN
        PRINT 'Forum not found.';
    END
END;
GO

-- 14. Find the most common emotional state for the learners.
CREATE OR ALTER PROCEDURE CommonEmotionalState (@State VARCHAR(50) OUTPUT)
AS
BEGIN
    SELECT TOP 1 @State = emotional_state
    FROM Emotional_Feedback
    GROUP BY emotional_state
    ORDER BY COUNT(*) DESC;
END;
GO

-- 15. View all modules for a certain course sorted by their difficulty.
CREATE OR ALTER PROCEDURE ModuleDifficulty (@CourseID INT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course WHERE CourseID = @CourseID)
    BEGIN
        SELECT m.*
        FROM Modules m
        WHERE m.CourseID = @CourseID
        ORDER BY 
            CASE 
                WHEN m.difficulty NOT IN ('Easy', 'Medium', 'Hard') THEN 0
                WHEN m.difficulty = 'Hard' THEN 1
                WHEN m.difficulty = 'Medium' THEN 2
                WHEN m.difficulty = 'Easy' THEN 3
            END;
    END
    ELSE
    BEGIN
        PRINT 'Course not found.';
    END
END;
GO

-- 16. View the skill with the highest proficiency level for a learner.
CREATE OR ALTER PROCEDURE Profeciencylevel (@LearnerID INT, @skill VARCHAR(50) OUTPUT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Learner WHERE LearnerID = @LearnerID)
    BEGIN
        SELECT TOP 1 @skill = skill_name
        FROM SkillProgression
        WHERE LearnerID = @LearnerID
        ORDER BY 
            CASE 
                WHEN proficiency_level NOT IN ('Beginner', 'Intermediate', 'Advanced') THEN 0
                WHEN proficiency_level = 'Advanced' THEN 1
                WHEN proficiency_level = 'Intermediate' THEN 2
                WHEN proficiency_level = 'Beginner' THEN 3
            END;
    END
    ELSE
    BEGIN
        PRINT 'Learner not found.';
    END
END;
GO

-- 17. Update a learner proficiency level for a certain skill.
CREATE OR ALTER PROCEDURE ProfeciencyUpdate (@Skill VARCHAR(50), @LearnerID INT, @Level VARCHAR(50))
AS
BEGIN
    IF EXISTS (SELECT 1 FROM SkillProgression WHERE LearnerID = @LearnerID AND skill_name = @Skill)
    BEGIN
        UPDATE SkillProgression
        SET proficiency_level = @Level
        WHERE LearnerID = @LearnerID AND skill_name = @Skill;
    END
    ELSE
    BEGIN
        PRINT 'Skill or Learner not found.';
    END
END;
GO

-- 18. Find the learner with the least number of badges earned.
CREATE OR ALTER PROCEDURE LeastBadge (@LearnerID INT OUTPUT)
AS
BEGIN
    SELECT TOP 1 @LearnerID = LearnerID
    FROM Achievement
    GROUP BY LearnerID
    ORDER BY COUNT(*) ASC;
END;
GO

-- 19. Find the most preferred learning type for the learners.
CREATE OR ALTER PROCEDURE PreferedType (@Type VARCHAR(50) OUTPUT)
AS
BEGIN
    SELECT TOP 1 @Type = preference
    FROM LearningPreference
    GROUP BY preference
    ORDER BY COUNT(*) DESC;
END;
GO

-- 20. Generate analytics on assessment scores across various modules or courses (average of scores).
CREATE OR ALTER PROCEDURE AssessmentAnalytics (@CourseID INT, @ModuleID INT)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course WHERE CourseID = @CourseID) 
    AND EXISTS (SELECT 1 FROM Modules WHERE ModuleID = @ModuleID)
    BEGIN
        SELECT subquery.average_score, a2.*
        FROM (SELECT AVG(ta.Scored_points) AS average_score, a2.ID AS AssessmentID
              FROM Assessments a2
              JOIN Taken_assessments ta ON a2.ID = ta.AssessmentID
              WHERE a2.CourseID = @CourseID AND a2.ModuleID = @ModuleID
              GROUP BY a2.ID) AS subquery
        JOIN Assessments a2 ON subquery.AssessmentID = a2.ID;
    END
    ELSE
    BEGIN
        PRINT 'Course or Module not found.';
    END
END;
GO

-- 21. View trends in learners’ emotional feedback to support well-being in courses I teach.
CREATE OR ALTER PROCEDURE EmotionalTrendAnalysisIns (@CourseID INT, @ModuleID INT, @TimePeriod DATETIME)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course WHERE CourseID = @CourseID) 
    AND EXISTS (SELECT 1 FROM Modules WHERE ModuleID = @ModuleID)
    BEGIN
        SELECT LearnerID, emotional_state, timestamp
        FROM Emotional_feedback ef
        JOIN Learning_activities la ON ef.ActivityID = la.ActivityID
        WHERE la.CourseID = @CourseID AND la.ModuleID = @ModuleID
        AND timestamp BETWEEN @TimePeriod AND GETDATE()
        ORDER BY timestamp DESC;
    END
    ELSE
    BEGIN
        PRINT 'Course or Module not found.';
    END
END;
GO


-- USE PROJECT
----ADMIN
----1
--EXEC ViewInfo @LearnerID = 1
--GO
----2
--EXEC LearnerInfo @LearnerID = 1
--GO
----3
--DECLARE @emotional_state VARCHAR(50);
--EXEC EmotionalState @LearnerID = 15, @emotional_state = @emotional_state OUTPUT;
--SELECT @emotional_state AS LatestEmotionalState;
--GO
----4
--EXEC LogDetails @LearnerID = 14;
----5
--EXEC InstructorReview @InstructorID = 13; -- Assuming there is an InstructorID = 1
--GO
----6
--INSERT INTO Course (CourseID, Title, learning_objective, credit_points, difficulty_level, description)
--VALUES (501, 'Math 101', 'Basic Math', 3, 'Easy', 'Introduction to basic math concepts')
--EXEC CourseRemove @CourseID = 5041; -- Be cautious as this will delete the course
--GO
----7
--EXEC Highestgrade;
--GO
----8
--EXEC InstructorCount;
--GO
----9
--EXEC ViewNot @LearnerID = 14; -- Assuming there are notifications for LearnerID = 1
--GO
----10
--EXEC CreateDiscussion @ModuleID = 19, @CourseID = 91, @title = 'New Discussion', @description = 'Discussion about Algebra';
--GO
----11
--EXEC RemoveBadge @BadgeID = 36; -- Assuming there is a BadgeID = 1
--GO
----12
--EXEC CriteriaDelete @criteria = 'Multiple Choice'; -- Assuming there are quests with this criterion
--GO
----13
--EXEC NotificationUpdate @LearnerID = 1, @NotificationID = 1, @ReadStatus = 1; -- Assuming there is a NotificationID = 1
--GO
----14
--EXEC EmotionalTrendAnalysis @CourseID = 19, @ModuleID = 199, @TimePeriod = '2023-01-01';
--GO
------------------------------------------------------ learner
--EXEC ProfileUpdate @learnerID = 1, @ProfileID = 1, @PreferedContentType = 'Video', @emotional_state = 'Happy', @PersonalityType = 'Introvert';
--EXEC ProfileUpdate @learnerID = 100, @ProfileID = 200, @PreferedContentType = 'Audio', @emotional_state = 'Calm', @PersonalityType = 'Extrovert';

--EXEC TotalPoints @LearnerID = 2, @RewardType = 'points';
--EXEC TotalPoints @LearnerID = 100, @RewardType = 'points';

--EXEC EnrolledCourses @LearnerID = 1;
--EXEC EnrolledCourses @LearnerID = 100;

--EXEC Prerequisites @LearnerID = 1, @CourseID = 2;
--EXEC Prerequisites @LearnerID = 100, @CourseID = 200;

--EXEC ModuleTraits @TargetTrait = 'Problem Solving', @CourseID = 1;
--EXEC ModuleTraits @TargetTrait = 'Teamwork', @CourseID = 100;

--EXEC LeaderboardRank @LeaderboardID = 1;
--EXEC LeaderboardRank @LeaderboardID = 100;

--EXEC ActivityEmotionalFeedback @ActivityID = 1, @LearnerID = 1, @timestamp = '', @emotionalstate = 'Excited';
-- EXEC ActivityEmotionalFeedback @ActivityID = 100, @LearnerID = 100, @timestamp = '', @emotionalstate = 'Focused';

--EXEC JoinQuest @LearnerID = 1, @QuestID = 3;
--EXEC JoinQuest @LearnerID = 100, @QuestID = 3;

--EXEC SkillsProficiency @LearnerID = 1;
--EXEC SkillsProficiency @LearnerID = 100;

--DECLARE @score INT;
--EXEC ViewScore @LearnerID = 1, @AssessmentID = 1, @score = @score OUTPUT;
--EXEC ViewScore @LearnerID = 100, @AssessmentID = 200, @score = @score OUTPUT;

--EXEC AssessmentsList @courseID = 1, @ModuleID = 1, @LearnerID = 1
--EXEC AssessmentsList @courseID = 100, @ModuleID = 200, @LearnerID = 100;

--EXEC Courseregister @LearnerID = 1, @CourseID = 1;
--EXEC Courseregister @LearnerID = 100, @CourseID = 200;

--EXEC Post @LearnerID = 1, @DiscussionID = 1, @Post = 'This is a test post.';
--EXEC Post @LearnerID = 100, @DiscussionID = 200, @Post = 'Adding another post.';

--EXEC AddGoal @LearnerID = 1, @GoalID = 1;
--EXEC AddGoal @LearnerID = 100, @GoalID = 200;

--EXEC CurrentPath @LearnerID = 1;
--EXEC CurrentPath @LearnerID = 100;

--EXEC QuestMembers @LearnerID = 1;
--EXEC QuestMembers @LearnerID = 100;

--EXEC QuestProgress @LearnerID = 1;
--EXEC QuestProgress @LearnerID = 100;

--EXEC GoalReminder @LearnerID = 1;
--EXEC GoalReminder @LearnerID = 100;

--EXEC SkillProgressHistory @LearnerID = 1, @Skill = 'Coding';
--EXEC SkillProgressHistory @LearnerID = 100, @Skill = 'Design';

--EXEC AssessmentAnalysis @LearnerID = 1;
--EXEC AssessmentAnalysis @LearnerID = 100;

--EXEC LeaderboardFilter @LearnerID = 1;
--EXEC LeaderboardFilter @LearnerID = 100;

-------------------------------------------------------------
----INSTRUCTOR
---- 1. Execute SkillLearners
--EXEC SkillLearners @SkillName = 'Python';
--GO
---- 2. Execute NewActivity
--EXEC NewActivity 
--    @CourseID = 19, 
--    @ModuleID = 19, 
--    @ActivityType = 'ActivityTypeHere', 
--    @InstructionDetails = 'InstructionDetailsHere', 
--    @MaxPoints = 100;
--GO
---- 3. Execute NewAchievement
--EXEC NewAchievement 
--    @LearnerID = 19, 
--    @BadgeID = 19, 
--    @Description = 'DescriptionHere', 
--    @DateEarned = '2024-01-01', 
--    @Type = 'TypeHere';
--GO
---- 4. Execute LearnerBadge
--EXEC LearnerBadge @BadgeID = 92;
--GO
---- 5. Execute NewPath
--EXEC NewPath 
--    @LearnerID = 91, 
--    @ProfileID = 91, 
--    @CompletionStatus = 'StatusHere', 
--    @CustomContent = 'CustomContentHere', 
--    @AdaptiveRules = 'AdaptiveRulesHere';
--GO
---- 6. Execute TakenCourses
--EXEC TakenCourses @LearnerID = 91;
--GO
---- 7. Execute CollaborativeQuest
--EXEC CollaborativeQuest 
--    @difficulty_level = 'LevelHere', 
--    @criteria = 'CriteriaHere', 
--    @description = 'DescriptionHere', 
--    @title = 'TitleHere', 
--    @Maxnumparticipants = 10, 
--    @deadline = '2024-12-31 23:59:59';
--GO
---- 8. Execute DeadlineUpdate
--EXEC DeadlineUpdate 
--    @QuestID = 93, 
--    @Deadline = '2025-12-31 23:59:59';
--GO
---- 9. Execute GradeUpdate
--EXEC GradeUpdate 
--    @LearnerID = 91, 
--    @AssessmentID = 91,
--    @points = 10;
--GO
---- 10. Execute AssessmentNot
--EXEC AssessmentNot 
--    @NotificationID = 95, 
--    @Timestamp = '2024-01-01 10:00:00', 
--    @Message = 'MessageHere', 
--    @UrgencyLevel = 'UrgencyHere', 
--    @LearnerID = 3;
--GO
---- 11. Execute NewGoal
--EXEC NewGoal 
--    @GoalID = 91340, 
--    @Status = 'StatusHere', 
--    @Deadline = '2024-12-31 23:59:59', 
--    @Description = 'DescriptionHere';
--GO
---- 12. Execute LearnersCourses
--EXEC LearnersCourses 
--    @CourseID = 92, 
--    @InstructorID = 92;
--GO
---- 13. Execute LastActive
--DECLARE @LastActive DATETIME;
--EXEC LastActive 
--    @ForumID = 91, 
--    @LastActive = @LastActive OUTPUT;
--SELECT @LastActive AS LastActive;
--GO
---- 14. Execute CommonEmotionalState
--DECLARE @State VARCHAR(50);
--EXEC CommonEmotionalState 
--    @State = @State OUTPUT;
--SELECT @State AS CommonEmotional
--GO
----15: ModuleDifficulty
--EXEC ModuleDifficulty @courseID = 93;
--GO
----16: Profeciencylevel
--DECLARE @skill VARCHAR(50);
--EXEC Profeciencylevel @LearnerID = 91, @skill=@skill OUTPUT;
--SELECT @skill AS Skill_name;
----17: ProfeciencyUpdate
--EXEC ProfeciencyUpdate @Skill = 'Python', @LearnerId = 91, @Level = 'Advanced';
----18: LeastBadge
--DECLARE @LearnerID INT;
--EXEC LeastBadge @LearnerID = @LearnerID OUTPUT;
--SELECT @LearnerID AS LearnerID;
----19: PreferedType
--DECLARE @type VARCHAR(50);
--EXEC PreferedType @type = @type OUTPUT;
--SELECT @type AS PreferedType;
----20: AssessmentAnalytics
--EXEC AssessmentAnalytics @CourseID = 92, @ModuleID = 92;
----21: EmotionalTrendAnalysis
--EXEC EmotionalTrendAnalysisIns @CourseID = 1, @ModuleID = 91, @TimePeriod = '2023-10-01';
