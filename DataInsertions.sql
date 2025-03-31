USE PROJECT;
GO
-- Insert into Learner
INSERT INTO Learner (LearnerID, first_name, last_name, gender, birth_date, country, cultural_background)
VALUES (1, 'John', 'Doe', 'M', '1990-01-01', 'USA', 'American'),
       (2, 'Jane', 'Smith', 'F', '1992-02-02', 'Canada', 'Canadian'),
       (3, 'Alice', 'Johnson', 'F', '1994-03-03', 'UK', 'British'),
       (4, 'Tom', 'Hanks', 'M', '1990-01-01', 'USA', 'American'),
	   (5, 'Emma', 'Watson', 'F', '1992-02-02', 'Canada', 'Canadian'),
	   (6, 'Chris', 'Evans', 'M', '1994-03-03', 'UK', 'British')
GO

-- Insert into Skills
INSERT INTO Skills (LearnerID, skill)
VALUES (1, 'Python'),
       (2, 'Java'),
       (3, 'C#'),
       (3, 'Python'),
       (1, 'Java'),
       (2, 'C#');
GO

-- Insert into LearningPreference
INSERT INTO LearningPreference (LearnerID, preference)
VALUES (1, 'Visual'),
       (2, 'Auditory'),
       (3, 'Kinesthetic'),
       (2, 'Visual'),
	   (3, 'Auditory');
GO

-- Insert into PersonalizationProfiles
INSERT INTO PersonalizationProfiles (LearnerID, ProfileID, preferred_content_type, emotional_state, personality_type)
VALUES (1, 1, 'Video', 'Happy', 'Extrovert'),
       (2, 2, 'Text', 'Calm', 'Introvert'),
       (3, 3, 'Interactive', 'Excited', 'Ambivert');
GO

-- Insert into HealthCondition
INSERT INTO HealthCondition (LearnerID, ProfileID, condition)
VALUES (1, 1, 'Asthma'),
       (2, 2, 'Diabetes'),
       (3, 3, 'Hypertension');
GO

-- Insert into Course
INSERT INTO Course (CourseID, Title, learning_objective, credit_points, difficulty_level, description)
VALUES (1, 'Math 101', 'Basic Math', 3, 'Easy', 'Introduction to basic math concepts'),
       (2, 'Physics 101', 'Basic Physics', 4, 'Medium', 'Introduction to basic physics concepts'),
       (3, 'Chemistry 101', 'Basic Chemistry', 3, 'Easy', 'Introduction to basic chemistry concepts');
GO


-- Insert into Modules
INSERT INTO Modules (ModuleID, CourseID, Title, difficulty, contentURL)
VALUES (1, 1, 'Algebra', 'Easy', 'http://example.com/algebra'),
       (2, 2, 'Mechanics', 'Medium', 'http://example.com/mechanics'),
       (3, 3, 'Organic Chemistry', 'Easy', 'http://example.com/organic_chemistry'),
       (4, 1, 'Geometry', 'Hard', 'http://example.com/geometry'),
       (5, 2, 'Thermodynamics', 'Medium', 'http://example.com/thermodynamics'),
	   (6, 3, 'Inorganic Chemistry', 'Hard', 'http://example.com/inorganic_chemistry');
GO

-- Insert into Target_traits
INSERT INTO Target_traits (ModuleID, CourseID, Trait)
VALUES (1, 1, 'Problem Solving'),
       (2, 2, 'Analytical Thinking'),
       (3, 3, 'Attention to Detail'),
       (4, 1, 'Critical Thinking'),
	   (5, 2, 'Creativity'),
       (6, 3, 'Collaboration');
GO

-- Insert into ModuleContent
INSERT INTO ModuleContent (ModuleID, CourseID, content_type)
VALUES (1, 1, 'Video'),
       (2, 2, 'Text'),
       (3, 3, 'Interactive');
GO

-- Insert into ContentLibrary
INSERT INTO ContentLibrary (ID, ModuleID, CourseID, Title, description, metadata, type, content_URL)
VALUES (1, 1, 1, 'Algebra Basics', 'Introduction to Algebra', 'Math, Algebra', 'Video', 'http://example.com/algebra_basics'),
       (2, 2, 2, 'Mechanics Basics', 'Introduction to Mechanics', 'Physics, Mechanics', 'Text', 'http://example.com/mechanics_basics'),
       (3, 3, 3, 'Organic Chemistry Basics', 'Introduction to Organic Chemistry', 'Chemistry, Organic Chemistry', 'Interactive', 'http://example.com/organic_chemistry_basics');
GO

-- Insert into Assessments
INSERT INTO Assessments (ID, ModuleID, CourseID, type, total_marks, passing_marks, criteria, weightage, description, title)
VALUES (1, 1, 1, 'Quiz', 100, 50, 'Multiple Choice', 0.2, 'Basic Algebra Quiz', 'Algebra Quiz'),
       (2, 2, 2, 'Assignment', 100, 60, 'Written', 0.3, 'Mechanics Assignment', 'Mechanics Assignment'),
       (3, 3, 3, 'Exam', 100, 70, 'Written', 0.5, 'Organic Chemistry Exam', 'Organic Chemistry Exam');
GO

-- Insert into Learning_activities
INSERT INTO Learning_activities (ActivityID, ModuleID, CourseID, activity_type, instruction_details, Max_points)
VALUES (1, 1, 1, 'Exercise', 'Solve algebra problems', 10),
       (2, 2, 2, 'Lab', 'Perform mechanics experiments', 20),
       (3, 3, 3, 'Project', 'Create an organic chemistry model', 30);
GO

-- Insert into Interaction_log
INSERT INTO Interaction_log (LogID, activity_ID, LearnerID, Duration, Timestamp, action_type)
VALUES (1, 1, 1, '00:30:00', '2023-10-01 10:00:00', 'Start'),
       (2, 2, 2, '01:00:00', '2023-10-02 11:00:00', 'Complete'),
       (3, 3, 3, '00:45:00', '2023-10-03 12:00:00', 'Pause');
GO

-- Insert into Emotional_feedback
INSERT INTO Emotional_feedback (FeedbackID, LearnerID, ActivityID, timestamp, emotional_state)
VALUES (1, 1, 1, '2023-10-01', 'Happy'),
       (2, 2, 2, '2023-10-02', 'Satisfied'),
       (3, 3, 3, '2023-10-03', 'Excited'),
       (4, 1, 3, '2023-10-01', 'Excited');
GO

-- Insert into Learning_path
INSERT INTO Learning_path (pathID, LearnerID, ProfileID, completion_status, custom_content, adaptive_rules)
VALUES (1, 1, 1, 'Completed', 'Advanced Algebra', 'Rule1'),
       (2, 2, 2, 'In Progress', 'Advanced Mechanics', 'Rule2'),
       (3, 3, 3, 'Not Started', 'Advanced Organic Chemistry', 'Rule3');
GO

-- Insert into Instructor
INSERT INTO Instructor (InstructorID, name, latest_qualification, expertise_area, email)
VALUES (1, 'Dr. Smith', 'PhD', 'Mathematics', 'smith@example.com'),
       (2, 'Dr. Johnson', 'PhD', 'Physics', 'johnson@example.com'),
       (3, 'Dr. Brown', 'PhD', 'Chemistry', 'brown@example.com');
GO

-- Insert into Pathreview
INSERT INTO Pathreview (InstructorID, PathID, feedback)
VALUES (1, 1, 'Great progress'),
       (2, 2, 'Needs improvement'),
       (3, 3, 'Excellent work');
GO

-- Insert into Emotionalfeedback_review
INSERT INTO Emotionalfeedback_review (FeedbackID, InstructorID, feedback)
VALUES (1, 1, 'Positive feedback'),
       (2, 2, 'Neutral feedback'),
       (3, 3, 'Negative feedback');
GO

-- Insert into Course_enrollment
INSERT INTO Course_enrollment (EnrollmentID, CourseID, LearnerID, completion_date, enrollment_date, status)
VALUES (4,2,1, '2023-12-01', '2023-09-01', 'Completed'),
       (1, 1, 1, '2023-12-01', '2023-09-01', 'Completed'),
       (2, 2, 2, '2023-12-15', '2023-09-15', 'In Progress'),
       (3, 3, 3, '2023-12-30', '2023-09-30', 'Not Started');
GO

-- Insert into Teaches
INSERT INTO Teaches (InstructorID, CourseID)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (3, 1);
GO

-- Insert into Leaderboard
INSERT INTO Leaderboard (BoardID, season)
VALUES (1, 'Spring 2023'),
       (2, 'Summer 2023'),
       (3, 'Fall 2023');
GO

-- Insert into Ranking
INSERT INTO Ranking (BoardID, LearnerID, CourseID, rank, total_points)
VALUES (1, 1, 1, 1, 100),
       (2, 2, 2, 2, 90),
       (3, 3, 3, 3, 80);
GO

-- Insert into Learning_goal
INSERT INTO Learning_goal (ID, status, deadline, description)
VALUES (1, 'In Progress', '2024-10-24 12:00:00', 'Complete Algebra Module'),
       (2, 'Completed', '2024-1-1 13:00:00', 'Complete Mechanics Module'),
       (3, 'Not Started', '2024-10-10 14:00:00', 'Complete Organic Chemistry Module'),
       (4, 'In Progress', '2023-10-24 12:00:00', 'Complete Algebra Module')
GO

-- Insert into LearnersGoals
INSERT INTO LearnersGoals (GoalID, LearnerID)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (3, 1)
GO

-- Insert into Survey
INSERT INTO Survey (ID, Title)
VALUES (1, 'Course Feedback'),
       (2, 'Instructor Feedback'),
       (3, 'Module Feedback');
GO

-- Insert into SurveyQuestions
INSERT INTO SurveyQuestions (SurveyID, Question)
VALUES (1, 'How was the course content?'),
       (2, 'How was the instructor?'),
       (3, 'How was the module content?');
GO

-- Insert into FilledSurvey
INSERT INTO FilledSurvey (SurveyID, Question, LearnerID, Answer)
VALUES (1, 'How was the course content?', 1, 'Excellent'),
       (2, 'How was the instructor?', 2, 'Good'),
       (3, 'How was the module content?', 3, 'Average');
GO

-- Insert into Notification
INSERT INTO Notification (ID, timestamp, message, urgency_level)
VALUES (1, '2023-10-01 10:00:00', 'New course available', 'High'),
       (2, '2023-10-02 11:00:00', 'Assignment due', 'Medium'),
       (3, '2023-10-03 12:00:00', 'Exam schedule', 'Low');
GO

-- Insert into ReceivedNotification
INSERT INTO ReceivedNotification (NotificationID, LearnerID, ReadStatus)
VALUES (1, 1, 0),
       (2, 2, 1),
       (3, 3, 1);
GO

-- Insert into Badge
INSERT INTO Badge (BadgeID, title, description, criteria, points)
VALUES (1, 'Math Whiz', 'Awarded for excellence in Math', 'Complete Math 101', 100),
       (2, 'Physics Pro', 'Awarded for excellence in Physics', 'Complete Physics 101', 100),
       (3, 'Chemistry Champ', 'Awarded for excellence in Chemistry', 'Complete Chemistry 101', 100),
       (4, 'Algebra Ace', 'Awarded for excellence in Algebra', 'Complete Algebra Module', 50),
	   (5, 'Mechanics Master', 'Awarded for excellence in Mechanics', 'Complete Mechanics Module', 50),
	   (6, 'Organic Chemistry Expert', 'Awarded for excellence in Organic Chemistry', 'Complete Organic Chemistry Module', 50);
GO

-- Insert into SkillProgression
INSERT INTO SkillProgression (ID, proficiency_level, LearnerID, skill_name, timestamp)
VALUES (1, 'Beginner', 1, 'Python', '2023-10-01 10:00:00'),
       (2, 'Intermediate', 2, 'Java', '2023-10-02 11:00:00'),
       (3, 'Advanced', 3, 'C#', '2023-10-03 12:00:00'),
       (4, 'Beginner', 3, 'Python', '2023-10-03 12:00:00'),
       (5, 'Intermediate', 1, 'Java', '2023-10-01 10:00:00'),
       (6, 'Advanced', 2, 'C#', '2023-10-02 11:00:00'),
       (7, 'Advanced', 2, 'Java', '2023-10-02 11:30:00');
GO

-- Insert into Achievement
INSERT INTO Achievement (AchievementID, LearnerID, BadgeID, description, date_earned, type)
VALUES (1, 1, 1, 'Completed Math 101', '2023-12-01', 'Course Completion'),
       (2, 2, 2, 'Completed Physics 101', '2023-12-15', 'Course Completion'),
       (3, 3, 3, 'Completed Chemistry 101', '2023-12-30', 'Course Completion'),
       (4, 1, 4, 'Completed Algebra Module', '2023-12-01', 'Module Completion'),
       (5, 2, 5, 'Completed Mechanics Module', '2023-12-15', 'Module Completion'),
	   (6, 3, 6, 'Completed Organic Chemistry Module', '2023-12-30', 'Module Completion'),
       (7, 2, 1, 'Completed Math 101', '2023-12-15', 'Course Completion');
GO

-- Insert into Reward
INSERT INTO Reward (RewardID, value, description, type)
VALUES (1, 100, 'Gift Card', 'points'),
       (2, 200, 'Certificate', 'points'),
       (3, 300, 'Trophy', 'points');
GO

-- Insert into Quest
INSERT INTO Quest (QuestID, difficulty_level, criteria, description, title)
VALUES (1, 'Easy', 'Complete Algebra', 'Solve algebra problems', 'Algebra Quest'),
       (2, 'Medium', 'Complete Mechanics', 'Perform mechanics experiments', 'Mechanics Quest'),
       (3, 'Hard', 'Complete Organic Chemistry', 'Create an organic chemistry model', 'Organic Chemistry Quest'),
       (4, 'Easy', 'Multiple Choice', 'Solve algebra problems', 'Algebra Quest 2');
GO

-- Insert into Skill_Mastery
INSERT INTO Skill_Mastery (QuestID, skill)
VALUES (1, 'Algebra'),
       (2, 'Mechanics')
GO

-- Insert into Collaborative
INSERT INTO Collaborative (QuestID, deadline, max_num_participants)
VALUES (3, '2023-12-30 14:00:00', 15);
GO

-- Insert into Discussion_forum
INSERT INTO Discussion_forum (forumID, ModuleID, CourseID, title, last_active, timestamp, description)
VALUES (1, 1, 1, 'Algebra Discussion', '2023-10-01 10:00:00', '2023-10-01 09:00:00', 'Discuss algebra problems'),
       (2, 2, 2, 'Mechanics Discussion', '2023-10-02 11:00:00', '2023-10-02 10:00:00', 'Discuss mechanics experiments'),
       (3, 3, 3, 'Organic Chemistry Discussion', '2023-10-03 12:00:00', '2023-10-03 11:00:00', 'Discuss organic chemistry models');
GO

-- Insert into LearnerDiscussion
INSERT INTO LearnerDiscussion (ForumID, LearnerID, Post, time)
VALUES (1, 1, 'I need help with algebra problems', '2023-10-01 10:30:00'),
       (2, 2, 'I have a question about mechanics experiments', '2023-10-02 11:30:00'),
       (3, 3, 'Can someone explain organic chemistry models?', '2023-10-03 12:30:00');
GO

-- Insert into QuestReward
INSERT INTO QuestReward (RewardID, QuestID, LearnerID, Time_earned)
VALUES (1, 1, 1, '2023-12-01 12:00:00'),
       (2, 2, 2, '2023-12-15 13:00:00'),
       (3, 3, 3, '2023-12-30 14:00:00');
GO

-- Insert into InstructorDiscussion
INSERT INTO InstructorDiscussion (ForumID, InstructorID, Post, time)
VALUES (1, 1, 'Let me explain algebra problems', '2023-10-01 10:30:00'),
       (2, 2, 'Here is some information about mechanics experiments', '2023-10-02 11:30:00'),
       (3, 3, 'I can help with organic chemistry models', '2023-10-03 12:30:00');
GO

-- Insert into Taken_assessments
INSERT INTO Taken_assessments (LearnerID, AssessmentID, Scored_points)
VALUES (1, 1, 90),
       (2, 2, 80),
       (3, 3, 70),
       (1, 2, 50),
       (2, 3, 60);
GO

-- Insert into Join_collaborative
INSERT INTO LearnerCollaboration (QuestID, LearnerID, completion_status)
VALUES (3, 1, 'In Progress'),
	   (3, 2, 'Not Started'),
	   (3, 3, 'Completed');
GO

-- Insert into Join_skill_mastery
INSERT INTO LearnerMastery (QuestID, LearnerID, completion_status)
VALUES (1, 1, 'Completed'),
	   (2, 2, 'In Progress');
GO
-- Insert into Course_PreRequisites
INSERT INTO Course_Prerequisites (CourseID, PreRequisiteID)
VALUES (2, 1),
	   (3, 2);
GO
