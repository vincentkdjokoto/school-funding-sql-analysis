/*
PUBLIC SCHOOL FUNDING & OUTCOMES ANALYSIS
Educational Data Analyst Portfolio Project
Analysis of relationship between per-student spending and graduation rates

Dataset Overview: Simulated public school district data based on NCES patterns
Tables: districts, schools, funding, outcomes, demographics
*/

-- ============================================
-- 1. DATABASE & TABLE CREATION
-- ============================================

-- Create database for education analysis
CREATE DATABASE IF NOT EXISTS school_funding_analysis;
USE school_funding_analysis;

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS funding_details;
DROP TABLE IF EXISTS academic_outcomes;
DROP TABLE IF EXISTS school_demographics;
DROP TABLE IF EXISTS schools;
DROP TABLE IF EXISTS districts;

-- Create districts table
CREATE TABLE districts (
    district_id INT PRIMARY KEY,
    district_name VARCHAR(100) NOT NULL,
    state_code CHAR(2) NOT NULL,
    county_name VARCHAR(50),
    urban_rural_status ENUM('Urban', 'Suburban', 'Rural', 'Town') NOT NULL,
    total_population INT,
    median_income DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create schools table
CREATE TABLE schools (
    school_id INT PRIMARY KEY,
    district_id INT NOT NULL,
    school_name VARCHAR(150) NOT NULL,
    school_level ENUM('Elementary', 'Middle', 'High', 'Combined') NOT NULL,
    total_students INT NOT NULL,
    student_teacher_ratio DECIMAL(5,2),
    free_reduced_lunch_percent DECIMAL(5,2),
    FOREIGN KEY (district_id) REFERENCES districts(district_id) ON DELETE CASCADE
);

-- Create funding details table
CREATE TABLE funding_details (
    funding_id INT PRIMARY KEY AUTO_INCREMENT,
    school_id INT NOT NULL,
    academic_year YEAR NOT NULL,
    total_revenue DECIMAL(12,2) NOT NULL,
    federal_funding DECIMAL(12,2),
    state_funding DECIMAL(12,2),
    local_funding DECIMAL(12,2),
    per_student_spending DECIMAL(8,2) NOT NULL,
    instructional_spending_pct DECIMAL(5,2),
    admin_spending_pct DECIMAL(5,2),
    UNIQUE KEY school_year (school_id, academic_year),
    FOREIGN KEY (school_id) REFERENCES schools(school_id) ON DELETE CASCADE
);

-- Create academic outcomes table
CREATE TABLE academic_outcomes (
    outcome_id INT PRIMARY KEY AUTO_INCREMENT,
    school_id INT NOT NULL,
    academic_year YEAR NOT NULL,
    graduation_rate DECIMAL(5,2),
    college_acceptance_rate DECIMAL(5,2),
    avg_sat_score INT,
    avg_act_score DECIMAL(4,1),
    proficient_math_pct DECIMAL(5,2),
    proficient_reading_pct DECIMAL(5,2),
    attendance_rate DECIMAL(5,2),
    chronic_absenteeism_pct DECIMAL(5,2),
    UNIQUE KEY school_year_outcome (school_id, academic_year),
    FOREIGN KEY (school_id) REFERENCES schools(school_id) ON DELETE CASCADE
);

-- Create demographics table
CREATE TABLE school_demographics (
    demo_id INT PRIMARY KEY AUTO_INCREMENT,
    school_id INT NOT NULL,
    academic_year YEAR NOT NULL,
    white_pct DECIMAL(5,2),
    black_pct DECIMAL(5,2),
    hispanic_pct DECIMAL(5,2),
    asian_pct DECIMAL(5,2),
    other_race_pct DECIMAL(5,2),
    english_learners_pct DECIMAL(5,2),
    special_ed_pct DECIMAL(5,2),
    UNIQUE KEY school_year_demo (school_id, academic_year),
    FOREIGN KEY (school_id) REFERENCES schools(school_id) ON DELETE CASCADE
);

-- ============================================
-- 2. SAMPLE DATA INSERTION
-- ============================================

-- Insert sample districts (based on real state patterns)
INSERT INTO districts (district_id, district_name, state_code, county_name, urban_rural_status, total_population, median_income) VALUES
(1, 'Springfield Public Schools', 'MA', 'Hampden', 'Urban', 155000, 62500.00),
(2, 'Jefferson County School District', 'KY', 'Jefferson', 'Suburban', 768000, 58200.00),
(3, 'Lincoln Consolidated Schools', 'NE', 'Lancaster', 'Rural', 32000, 48500.00),
(4, 'Riverside Unified District', 'CA', 'Riverside', 'Suburban', 2450000, 71500.00),
(5, 'Appalachia Mountain Schools', 'WV', 'Logan', 'Rural', 35000, 38500.00),
(6, 'Metro Atlanta Public Schools', 'GA', 'Fulton', 'Urban', 1060000, 67500.00),
(7, 'North Star School District', 'MN', 'Hennepin', 'Suburban', 1250000, 78500.00),
(8, 'Rio Grande Valley ISD', 'TX', 'Hidalgo', 'Rural', 870000, 42500.00),
(9, 'Silicon Valley Prep District', 'CA', 'Santa Clara', 'Urban', 1920000, 112500.00),
(10, 'Heartland Community Schools', 'IA', 'Polk', 'Town', 490000, 56500.00);

-- Insert sample schools
INSERT INTO schools (school_id, district_id, school_name, school_level, total_students, student_teacher_ratio, free_reduced_lunch_percent) VALUES
-- High schools
(101, 1, 'Springfield Central High', 'High', 1850, 16.5, 48.2),
(102, 2, 'Jefferson County High', 'High', 2200, 18.2, 42.5),
(103, 3, 'Lincoln High School', 'High', 650, 14.8, 68.9),
(104, 4, 'Riverside High', 'High', 1950, 17.1, 38.7),
(105, 5, 'Appalachia High School', 'High', 420, 12.5, 85.2),
(106, 6, 'Atlanta Metro High', 'High', 2450, 20.1, 62.3),
(107, 7, 'North Star High School', 'High', 1800, 15.8, 28.4),
(108, 8, 'Rio Grande Valley High', 'High', 1250, 19.5, 89.7),
(109, 9, 'Silicon Valley Prep High', 'High', 1650, 13.2, 15.8),
(110, 10, 'Heartland Community High', 'High', 950, 16.2, 45.6),

-- Middle schools (for context)
(201, 1, 'Springfield Middle School', 'Middle', 1250, 17.2, 47.5),
(202, 4, 'Riverside Middle', 'Middle', 1450, 18.5, 39.2);

-- Insert funding data (2023 academic year)
INSERT INTO funding_details (school_id, academic_year, total_revenue, federal_funding, state_funding, local_funding, per_student_spending, instructional_spending_pct, admin_spending_pct) VALUES
-- High schools funding
(101, 2023, 28500000.00, 1850000.00, 12500000.00, 14150000.00, 15405.41, 62.5, 12.8),
(102, 2023, 31900000.00, 2150000.00, 14200000.00, 15550000.00, 14500.00, 60.8, 14.2),
(103, 2023, 8450000.00, 1850000.00, 5200000.00, 1400000.00, 13000.00, 65.2, 10.5),
(104, 2023, 31200000.00, 1250000.00, 13500000.00, 16450000.00, 16000.00, 58.7, 15.1),
(105, 2023, 5880000.00, 2450000.00, 2850000.00, 580000.00, 14000.00, 68.9, 9.8),
(106, 2023, 34300000.00, 3850000.00, 15500000.00, 14950000.00, 14000.00, 59.5, 16.8),
(107, 2023, 29700000.00, 850000.00, 12500000.00, 16350000.00, 16500.00, 61.2, 13.5),
(108, 2023, 16250000.00, 4850000.00, 8500000.00, 2900000.00, 13000.00, 66.7, 11.2),
(109, 2023, 31350000.00, 650000.00, 11500000.00, 19200000.00, 19000.00, 57.8, 18.5),
(110, 2023, 14250000.00, 1250000.00, 7500000.00, 5500000.00, 15000.00, 63.4, 12.1),

-- Previous year for trend analysis
(101, 2022, 27200000.00, 1750000.00, 11800000.00, 13650000.00, 14700.00, 61.8, 13.2),
(102, 2022, 30500000.00, 2050000.00, 13500000.00, 14950000.00, 13864.00, 59.5, 14.8),
(109, 2022, 29800000.00, 620000.00, 11000000.00, 18180000.00, 18061.00, 56.5, 19.2);

-- Insert academic outcomes
INSERT INTO academic_outcomes (school_id, academic_year, graduation_rate, college_acceptance_rate, avg_sat_score, avg_act_score, proficient_math_pct, proficient_reading_pct, attendance_rate, chronic_absenteeism_pct) VALUES
-- 2023 outcomes
(101, 2023, 88.5, 76.2, 1120, 22.8, 45.2, 52.8, 92.5, 18.2),
(102, 2023, 85.2, 72.8, 1085, 21.5, 41.8, 48.5, 91.8, 20.5),
(103, 2023, 78.9, 58.4, 985, 19.2, 35.6, 42.1, 89.2, 28.8),
(104, 2023, 91.2, 82.5, 1165, 24.1, 52.8, 58.9, 94.2, 12.5),
(105, 2023, 72.5, 48.9, 920, 18.5, 28.9, 35.8, 87.5, 35.2),
(106, 2023, 82.8, 68.9, 1050, 20.8, 39.5, 45.2, 90.8, 25.8),
(107, 2023, 94.5, 88.9, 1245, 26.5, 62.8, 68.5, 95.8, 8.5),
(108, 2023, 75.8, 52.4, 965, 18.9, 32.8, 38.9, 88.5, 32.5),
(109, 2023, 96.8, 95.2, 1350, 29.8, 78.5, 82.4, 96.5, 5.8),
(110, 2023, 87.2, 74.8, 1105, 22.2, 43.9, 50.2, 92.8, 16.8),

-- 2022 outcomes for trend analysis
(101, 2022, 87.2, 74.8, 1105, 22.0, 43.5, 51.2, 92.0, 19.5),
(107, 2022, 93.8, 87.5, 1228, 25.8, 60.5, 66.2, 95.2, 9.8),
(109, 2022, 96.2, 94.5, 1335, 29.2, 76.8, 80.9, 96.0, 6.5);

-- Insert demographic data
INSERT INTO school_demographics (school_id, academic_year, white_pct, black_pct, hispanic_pct, asian_pct, other_race_pct, english_learners_pct, special_ed_pct) VALUES
(101, 2023, 48.2, 25.8, 18.5, 4.2, 3.3, 12.5, 14.8),
(102, 2023, 52.8, 32.5, 8.9, 2.5, 3.3, 8.2, 16.2),
(103, 2023, 85.2, 2.8, 8.5, 1.2, 2.3, 5.8, 18.5),
(104, 2023, 42.5, 8.9, 38.5, 7.8, 2.3, 25.8, 12.5),
(105, 2023, 92.8, 3.2, 2.5, 0.5, 1.0, 3.5, 22.8),
(106, 2023, 18.9, 65.8, 10.2, 2.8, 2.3, 15.8, 19.2),
(107, 2023, 68.5, 12.8, 8.9, 7.5, 2.3, 6.5, 13.8),
(108, 2023, 15.2, 2.8, 78.5, 1.2, 2.3, 48.9, 16.5),
(109, 2023, 45.8, 5.2, 18.9, 25.8, 4.3, 8.5, 10.2),
(110, 2023, 78.5, 8.9, 6.8, 3.5, 2.3, 4.8, 15.8);

-- ============================================
-- 3. EXPLORATORY DATA ANALYSIS QUERIES
-- ============================================

-- Q1: Basic descriptive statistics for per-student spending
SELECT 
    COUNT(*) AS school_count,
    ROUND(MIN(per_student_spending), 2) AS min_spending,
    ROUND(MAX(per_student_spending), 2) AS max_spending,
    ROUND(AVG(per_student_spending), 2) AS avg_spending,
    ROUND(STDDEV(per_student_spending), 2) AS std_spending,
    ROUND(MIN(graduation_rate), 2) AS min_grad_rate,
    ROUND(MAX(graduation_rate), 2) AS max_grad_rate,
    ROUND(AVG(graduation_rate), 2) AS avg_grad_rate
FROM funding_details fd
JOIN academic_outcomes ao ON fd.school_id = ao.school_id 
    AND fd.academic_year = ao.academic_year
WHERE fd.academic_year = 2023;

-- Q2: Spending by urban/rural status
SELECT 
    d.urban_rural_status,
    COUNT(DISTINCT s.school_id) AS school_count,
    ROUND(AVG(fd.per_student_spending), 2) AS avg_per_student_spending,
    ROUND(AVG(ao.graduation_rate), 2) AS avg_graduation_rate,
    ROUND(AVG(d.median_income), 2) AS avg_median_income
FROM districts d
JOIN schools s ON d.district_id = s.district_id
JOIN funding_details fd ON s.school_id = fd.school_id
JOIN academic_outcomes ao ON s.school_id = ao.school_id 
    AND fd.academic_year = ao.academic_year
WHERE fd.academic_year = 2023
GROUP BY d.urban_rural_status
ORDER BY avg_per_student_spending DESC;

-- Q3: Funding sources breakdown by state
SELECT 
    d.state_code,
    COUNT(DISTINCT s.school_id) AS school_count,
    ROUND(SUM(fd.total_revenue) / 1000000, 2) AS total_revenue_millions,
    ROUND(AVG(fd.federal_funding / fd.total_revenue * 100), 2) AS avg_federal_pct,
    ROUND(AVG(fd.state_funding / fd.total_revenue * 100), 2) AS avg_state_pct,
    ROUND(AVG(fd.local_funding / fd.total_revenue * 100), 2) AS avg_local_pct,
    ROUND(AVG(ao.graduation_rate), 2) AS avg_graduation_rate
FROM districts d
JOIN schools s ON d.district_id = s.district_id
JOIN funding_details fd ON s.school_id = fd.school_id
JOIN academic_outcomes ao ON s.school_id = ao.school_id 
    AND fd.academic_year = ao.academic_year
WHERE fd.academic_year = 2023
GROUP BY d.state_code
ORDER BY avg_graduation_rate DESC;

-- ============================================
-- 4. CORE ANALYSIS: SPENDING vs GRADUATION RATE
-- ============================================

-- Q4: Direct correlation analysis between spending and graduation rates
-- Using Common Table Expression (CTE) for clarity
WITH spending_grad_data AS (
    SELECT 
        s.school_id,
        s.school_name,
        d.district_name,
        d.state_code,
        d.urban_rural_status,
        s.free_reduced_lunch_percent,
        fd.per_student_spending,
        ao.graduation_rate,
        ao.college_acceptance_rate,
        ao.avg_sat_score,
        -- Create spending categories
        CASE 
            WHEN fd.per_student_spending < 14000 THEN 'Low Spending (<$14k)'
            WHEN fd.per_student_spending BETWEEN 14000 AND 16000 THEN 'Medium Spending ($14k-$16k)'
            ELSE 'High Spending (>$16k)'
        END AS spending_category
    FROM schools s
    JOIN districts d ON s.district_id = d.district_id
    JOIN funding_details fd ON s.school_id = fd.school_id
    JOIN academic_outcomes ao ON s.school_id = ao.school_id 
        AND fd.academic_year = ao.academic_year
    WHERE fd.academic_year = 2023
        AND s.school_level = 'High'  -- Focus on high schools for graduation rates
)
SELECT 
    spending_category,
    COUNT(*) AS school_count,
    ROUND(AVG(per_student_spending), 2) AS avg_spending,
    ROUND(AVG(graduation_rate), 2) AS avg_graduation_rate,
    ROUND(AVG(college_acceptance_rate), 2) AS avg_college_acceptance,
    ROUND(AVG(free_reduced_lunch_percent), 2) AS avg_poverty_rate,
    ROUND(MIN(graduation_rate), 2) AS min_grad_rate,
    ROUND(MAX(graduation_rate), 2) AS max_grad_rate
FROM spending_grad_data
GROUP BY spending_category
ORDER BY avg_spending;

-- Q5: Detailed school-level analysis with ranking
-- Using window functions for ranking
SELECT 
    school_name,
    district_name,
    state_code,
    urban_rural_status,
    per_student_spending,
    graduation_rate,
    free_reduced_lunch_percent,
    -- Rank schools by spending within their state
    RANK() OVER (PARTITION BY state_code ORDER BY per_student_spending DESC) AS spending_rank_state,
    -- Rank schools by graduation rate within their state
    RANK() OVER (PARTITION BY state_code ORDER BY graduation_rate DESC) AS grad_rate_rank_state,
    -- Calculate spending percentile
    ROUND(PERCENT_RANK() OVER (ORDER BY per_student_spending) * 100, 1) AS spending_percentile,
    -- Calculate graduation rate percentile
    ROUND(PERCENT_RANK() OVER (ORDER BY graduation_rate) * 100, 1) AS grad_rate_percentile,
    -- Calculate difference between spending and graduation percentiles
    ROUND(
        PERCENT_RANK() OVER (ORDER BY graduation_rate) * 100 - 
        PERCENT_RANK() OVER (ORDER BY per_student_spending) * 100, 
        1
    ) AS percentile_difference
FROM (
    SELECT 
        s.school_name,
        d.district_name,
        d.state_code,
        d.urban_rural_status,
        s.free_reduced_lunch_percent,
        fd.per_student_spending,
        ao.graduation_rate
    FROM schools s
    JOIN districts d ON s.district_id = d.district_id
    JOIN funding_details fd ON s.school_id = fd.school_id
    JOIN academic_outcomes ao ON s.school_id = ao.school_id 
        AND fd.academic_year = ao.academic_year
    WHERE fd.academic_year = 2023
        AND s.school_level = 'High'
) AS school_data
ORDER BY per_student_spending DESC;

-- Q6: Analysis of "efficiency" - graduation rate per spending dollar
WITH efficiency_metrics AS (
    SELECT 
        s.school_name,
        d.district_name,
        d.state_code,
        fd.per_student_spending,
        ao.graduation_rate,
        -- Calculate graduation per $1000 spent
        ROUND(ao.graduation_rate / (fd.per_student_spending / 1000), 3) AS grad_per_1000_dollars,
        -- Identify outliers: high graduation with low spending
        CASE 
            WHEN ao.graduation_rate > 90 AND fd.per_student_spending < 15000 THEN 'High Performance, Low Cost'
            WHEN ao.graduation_rate < 80 AND fd.per_student_spending > 16000 THEN 'Low Performance, High Cost'
            ELSE 'Typical'
        END AS efficiency_category
    FROM schools s
    JOIN districts d ON s.district_id = d.district_id
    JOIN funding_details fd ON s.school_id = fd.school_id
    JOIN academic_outcomes ao ON s.school_id = ao.school_id 
        AND fd.academic_year = ao.academic_year
    WHERE fd.academic_year = 2023
        AND s.school_level = 'High'
)
SELECT 
    efficiency_category,
    COUNT(*) AS school_count,
    ROUND(AVG(per_student_spending), 2) AS avg_spending,
    ROUND(AVG(graduation_rate), 2) AS avg_grad_rate,
    ROUND(AVG(grad_per_1000_dollars), 3) AS avg_efficiency
FROM efficiency_metrics
GROUP BY efficiency_category
ORDER BY avg_efficiency DESC;

-- ============================================
-- 5. ADVANCED ANALYSIS WITH MULTIPLE CTEs
-- ============================================

-- Q7: Year-over-year changes in spending and outcomes
WITH current_year AS (
    SELECT 
        s.school_id,
        s.school_name,
        fd.per_student_spending AS current_spending,
        ao.graduation_rate AS current_grad_rate
    FROM schools s
    JOIN funding_details fd ON s.school_id = fd.school_id
    JOIN academic_outcomes ao ON s.school_id = ao.school_id 
        AND fd.academic_year = ao.academic_year
    WHERE fd.academic_year = 2023
        AND s.school_level = 'High'
),
previous_year AS (
    SELECT 
        s.school_id,
        fd.per_student_spending AS previous_spending,
        ao.graduation_rate AS previous_grad_rate
    FROM schools s
    JOIN funding_details fd ON s.school_id = fd.school_id
    JOIN academic_outcomes ao ON s.school_id = ao.school_id 
        AND fd.academic_year = ao.academic_year
    WHERE fd.academic_year = 2022
        AND s.school_level = 'High'
)
SELECT 
    cy.school_name,
    ROUND(cy.current_spending, 2) AS current_spending,
    ROUND(py.previous_spending, 2) AS previous_spending,
    ROUND(cy.current_spending - py.previous_spending, 2) AS spending_change,
    ROUND(((cy.current_spending - py.previous_spending) / py.previous_spending) * 100, 2) AS spending_change_pct,
    ROUND(cy.current_grad_rate, 2) AS current_grad_rate,
    ROUND(py.previous_grad_rate, 2) AS previous_grad_rate,
    ROUND(cy.current_grad_rate - py.previous_grad_rate, 2) AS grad_rate_change
FROM current_year cy
LEFT JOIN previous_year py ON cy.school_id = py.school_id
WHERE py.previous_spending IS NOT NULL  -- Only schools with data for both years
ORDER BY spending_change_pct DESC;

-- Q8: Multivariate analysis controlling for poverty
-- Analyzing relationship between spending and graduation while accounting for poverty levels
SELECT 
    -- Create poverty quartiles
    CASE 
        WHEN free_reduced_lunch_percent < 30 THEN 'Low Poverty (<30%)'
        WHEN free_reduced_lunch_percent BETWEEN 30 AND 60 THEN 'Medium Poverty (30-60%)'
        ELSE 'High Poverty (>60%)'
    END AS poverty_level,
    COUNT(*) AS school_count,
    ROUND(AVG(per_student_spending), 2) AS avg_spending,
    ROUND(AVG(graduation_rate), 2) AS avg_grad_rate,
    -- Calculate correlation within each poverty group
    ROUND(
        (SUM(per_student_spending * graduation_rate) - 
         SUM(per_student_spending) * SUM(graduation_rate) / COUNT(*)) /
        (SQRT(SUM(per_student_spending * per_student_spending) - 
              SUM(per_student_spending) * SUM(per_student_spending) / COUNT(*)) *
         SQRT(SUM(graduation_rate * graduation_rate) - 
              SUM(graduation_rate) * SUM(graduation_rate) / COUNT(*))),
        3
    ) AS spending_grad_correlation,
    ROUND(AVG(college_acceptance_rate), 2) AS avg_college_acceptance
FROM (
    SELECT 
        s.school_id,
        s.free_reduced_lunch_percent,
        fd.per_student_spending,
        ao.graduation_rate,
        ao.college_acceptance_rate
    FROM schools s
    JOIN funding_details fd ON s.school_id = fd.school_id
    JOIN academic_outcomes ao ON s.school_id = ao.school_id 
        AND fd.academic_year = ao.academic_year
    WHERE fd.academic_year = 2023
        AND s.school_level = 'High'
) AS school_stats
GROUP BY poverty_level
ORDER BY avg_spending DESC;

-- ============================================
-- 6. DATA EXPORT FOR VISUALIZATION
-- ============================================

-- Export query 1: Basic spending vs graduation for scatter plot
SELECT 
    s.school_name,
    d.state_code,
    d.urban_rural_status,
    s.free_reduced_lunch_percent,
    fd.per_student_spending,
    ao.graduation_rate,
    ao.college_acceptance_rate,
    ao.avg_sat_score
FROM schools s
JOIN districts d ON s.district_id = d.district_id
JOIN funding_details fd ON s.school_id = fd.school_id
JOIN academic_outcomes ao ON s.school_id = ao.school_id 
    AND fd.academic_year = ao.academic_year
WHERE fd.academic_year = 2023
    AND s.school_level = 'High'
ORDER BY fd.per_student_spending;

-- Export query 2: Spending by urban/rural with outcomes
SELECT 
    d.urban_rural_status,
    AVG(fd.per_student_spending) AS avg_spending,
    AVG(ao.graduation_rate) AS avg_grad_rate,
    AVG(s.free_reduced_lunch_percent) AS avg_poverty_rate,
    AVG(d.median_income) AS avg_median_income,
    COUNT(*) AS school_count
FROM districts d
JOIN schools s ON d.district_id = s.district_id
JOIN funding_details fd ON s.school_id = fd.school_id
JOIN academic_outcomes ao ON s.school_id = ao.school_id 
    AND fd.academic_year = ao.academic_year
WHERE fd.academic_year = 2023
    AND s.school_level = 'High'
GROUP BY d.urban_rural_status;

-- Export query 3: Efficiency metrics
SELECT 
    school_name,
    state_code,
    per_student_spending,
    graduation_rate,
    ROUND(graduation_rate / (per_student_spending / 1000), 3) AS grad_per_1000_dollars,
    free_reduced_lunch_percent
FROM (
    SELECT 
        s.school_name,
        d.state_code,
        s.free_reduced_lunch_percent,
        fd.per_student_spending,
        ao.graduation_rate
    FROM schools s
    JOIN districts d ON s.district_id = d.district_id
    JOIN funding_details fd ON s.school_id = fd.school_id
    JOIN academic_outcomes ao ON s.school_id = ao.school_id 
        AND fd.academic_year = ao.academic_year
    WHERE fd.academic_year = 2023
        AND s.school_level = 'High'
) AS data_for_export
ORDER BY grad_per_1000_dollars DESC;
