-- Deliverable 1
SELECT e.emp_no,
        e.first_name,
        e.last_name,
        t.title,
        t.from_date,
        t.to_date
INTO retirement_titles
FROM employees AS e
INNER JOIN titles AS t
ON(e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
        rt.first_name,
        rt.last_name,
        rt.title
INTO unique_titles
FROM retirement_titles AS rt
WHERE rt.to_date = '9999-01-01'
ORDER BY rt.emp_no, rt.to_date DESC;

SELECT  count(ut.emp_no),
        ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY count DESC;

-- Deliverable 2

SELECT DISTINCT ON(e.emp_no) e.emp_no,
        e.first_name,
        e.last_name,
        e.birth_date,
        de.from_date,
        de.to_date,
        t.title
INTO mentorship_eligibilty
FROM employees AS e
INNER JOIN dept_emp AS de
ON(e.emp_no = de.emp_no)
INNER JOIN titles AS t
ON(e.emp_no = t.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;


-- Deliverable 3 - Summary

-- Table to provide count of employees eligible for mentorship by title (mentorship_per_titles.csv)
SELECT  count(me.emp_no),
        me.title
INTO mentorship_per_titles
FROM mentorship_eligibilty AS me
GROUP BY me.title
ORDER BY count DESC;

-- Table showing what percentage of retirees for each title (retiring_percent_by_titles.csv)
SELECT  rt.title,
        rt.count,
        100.0 * rt.count / sum(rt.count) OVER() AS percentage
INTO retiring_percent_by_titles
FROM retiring_titles AS rt
GROUP BY rt.title, rt.count
ORDER BY percentage DESC;

-- Table showing retirement counts by Department (retirements_by_department.csv)
SELECT count(de.emp_no) As "Retirement Count",
        d.dept_name
INTO retirements_by_department   
FROM retirement_titles AS rt
INNER JOIN dept_emp AS de
ON(rt.emp_no=de.emp_no)
INNER JOIN departments AS d
ON(de.dept_no=d.dept_no)
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name, de.dept_no
;

-- Table showing employees eligible for mentorship counts by Department (mentorship_by_department.csv)
SELECT count(de.emp_no) As "Eligible for Mentorship Count",
        d.dept_name
INTO mentorship_by_department   
FROM mentorship_eligibilty AS me
INNER JOIN dept_emp AS de
ON(me.emp_no=de.emp_no)
INNER JOIN departments AS d
ON(de.dept_no=d.dept_no)
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name, de.dept_no
;
