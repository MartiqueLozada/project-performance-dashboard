-- Project Status Overview
-- Shows how many projects are currently Completed vs Ongoing
SELECT 
    Status, 
    COUNT(Project_ID) AS Project_Count
FROM Projects
GROUP BY Status;


-- Project Completion % Based on Tasks
-- Measures completion rate of each project based on task status
SELECT 
    p.Project_Name,
    COUNT(t.Task_ID) AS Total_Tasks,
    SUM(CASE WHEN t.Task_Status = 'Completed' THEN 1 ELSE 0 END) AS Completed_Tasks,
    ROUND(SUM(CASE WHEN t.Task_Status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(t.Task_ID), 2) AS Completion_Percentage
FROM Projects p
JOIN Tasks t ON p.Project_ID = t.Project_ID
GROUP BY p.Project_Name
ORDER BY Completion_Percentage DESC;


-- Budget Variance by Project
-- Compares actual cost vs. budget per project
SELECT 
    p.Project_Name, 
    p.Budget AS Planned_Budget, 
    p.Actual_Cost, 
    ROUND((p.Actual_Cost - p.Budget) / p.Budget * 100, 2) AS Budget_Variance_Percentage
FROM Projects p
ORDER BY Budget_Variance_Percentage DESC;


-- Category-Based Financial Insights
-- Measures cost variance across expense categories (Labor, Materials, etc.)
SELECT 
    Category,
    SUM(Planned_Cost) AS Total_Planned,
    SUM(Actual_Cost) AS Total_Actual,
    ROUND(SUM(Actual_Cost - Planned_Cost) / SUM(Planned_Cost) * 100, 2) AS Cost_Variance_Percentage
FROM Financials
GROUP BY Category
ORDER BY Cost_Variance_Percentage DESC;


-- Employee Utilization Analysis
-- Highlights over- or under-utilized employees
SELECT 
    Name,
    Role,
    Total_Hours_Assigned,
    Total_Hours_Worked,
    ROUND((Total_Hours_Worked - Total_Hours_Assigned) / Total_Hours_Assigned * 100, 2) AS Utilization_Variance
FROM Resources
ORDER BY Utilization_Variance DESC;


-- Risk Summary by Type and Severity
-- Evaluates distribution of risk types and severity levels
SELECT 
    Risk_Type,
    COUNT(*) AS Total_Risks,
    SUM(CASE WHEN Severity_Level = 'High' THEN 1 ELSE 0 END) AS High_Risks,
    SUM(CASE WHEN Severity_Level = 'Medium' THEN 1 ELSE 0 END) AS Medium_Risks,
    SUM(CASE WHEN Severity_Level = 'Low' THEN 1 ELSE 0 END) AS Low_Risks
FROM Risks
GROUP BY Risk_Type
ORDER BY Total_Risks DESC;


-- Delayed Task Tracker
-- Lists tasks completed after their due dates and how long the delay was
SELECT 
    t.Project_ID,
    p.Project_Name,
    t.Task_Name,
    t.Due_Date,
    t.Completion_Date,
    DATEDIFF(t.Completion_Date, t.Due_Date) AS Delay_Days
FROM Tasks t
JOIN Projects p ON t.Project_ID = p.Project_ID
WHERE t.Completion_Date > t.Due_Date
ORDER BY Delay_Days DESC;
