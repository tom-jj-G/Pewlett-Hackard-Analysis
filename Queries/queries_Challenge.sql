
--##################CHALLENGE#############################
--##################CHALLENGE#############################
--##################CHALLENGE#############################
--##################CHALLENGE#############################


--Table 1.1: list of current employees who are about to retire (born between Jan. 1, 1952 and Dec. 31, 1955)
--With duplicates
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	s.salary
--INTO emp_info
FROM employees AS e
INNER JOIN salaries AS s ON (e.emp_no = s.emp_no)
INNER JOIN titles AS ti ON (e.emp_no = ti.emp_no)
INNER JOIN dept_emp AS de ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01');


--PART I###########################################
--Table 1.1: List of current employees who are about to retire (born between Jan. 1, 1952 and Dec. 31, 1955).
--Without titles duplicates (most recent title selected).
SELECT  emp_no,
		first_name,
        last_name,
        title,
        from_date,
        salary
INTO ret_emp_by_title
FROM
    (SELECT e.emp_no,
        e.first_name,
        e.last_name,
        ti.title,
        ti.from_date,
        s.salary, ROW_NUMBER() OVER
    (PARTITION BY (e.emp_no)
    ORDER BY ti.to_date DESC) rn
    FROM employees AS e
    INNER JOIN salaries AS s ON (e.emp_no = s.emp_no)
    INNER JOIN titles AS ti ON (e.emp_no = ti.emp_no)
    INNER JOIN dept_emp AS de ON (e.emp_no = de.emp_no)
    WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
        AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
        AND (de.to_date = '9999-01-01')) tmp WHERE rn=1
ORDER BY emp_no;


--Controls
SELECT COUNT(DISTINCT re.emp_no)
FROM ret_emp_by_title as re;

SELECT COUNT(*)
FROM ret_emp_by_title;
--=> same result: 33118:OK


--Table 1.2: Number of titles retiring.
SELECT COUNT(DISTINCT ret.title)
INTO ret_number_title
FROM ret_emp_by_title AS ret;


--Table 1.3: Number of retiring employees for each title.
SELECT COUNT(DISTINCT ret.emp_no), ret.title
INTO ret_num_emp_by_title
FROM ret_emp_by_title AS ret
GROUP BY ret.title
ORDER BY COUNT DESC;


--PART II###########################################
--Table 2: Retiring employees eligible to participate in the mentorship program.
--(date of birth that falls between January 1, 1965 and December 31, 1965).
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO mentorship_emp
FROM employees AS e
INNER JOIN titles AS ti ON (e.emp_no = ti.emp_no)
INNER JOIN dept_emp AS de ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01');