class Report < ActiveRecord::Base
  # attr_accessible :title, :body

  #General Usage Data
  def project_request_summary
    ActiveRecord::Base.connection.select_all " SELECT r.id id, strftime('%m-%d-%Y', r.created_at) date, r.title title, r.office_name request_office, u.name user_name, u.u_location user_office"\
     " FROM Requests r"\
     " LEFT OUTER JOIN Users u ON u.id = r.user_id"\
     " LEFT OUTER JOIN Responses re ON r.id = re.request_id"\
     " LEFT OUTER JOIN Assignments ra ON re.id = ra.response_id"\
     " GROUP BY r.id"\
     " ORDER BY office_name, ra.response_id IS NULL, r.created_at"
  end

  def overall_activity_changes
    ActiveRecord::Base.connection.select_all " SELECT strftime('%Y-%m', r.start_date ) as month, count(distinct r.id) requests, count(distinct re.request_id) requests_w_responses, count(ra.response_id) requests_w_assignments, count(r.date_cancelled) cancellations"\
    " FROM Requests r"\
    " LEFT OUTER JOIN Responses re ON r.id = re.request_id"\
    " LEFT OUTER JOIN Assignments ra ON re.id = ra.response_id"\
    " WHERE strftime('%Y-%m', start_date) > strftime('%Y-%m', date('now', '-6 months'))"\
    " GROUP BY month"\
    " ORDER BY month"
  end

  def request_fill_time
    ActiveRecord::Base.connection.select_all " SELECT SUM(date_difference <=1) under_one_day, SUM(date_difference > 1 AND date_difference <=3) one_to_three_days, SUM(date_difference > 3 AND date_difference <= 6) as three_to_six_days, SUM(date_difference > 6) over_six_days"\
    " FROM ("\
      " SELECT julianday(ra.created_at) - julianday(r.start_date) as date_difference"\
      " FROM Requests as r, Assignments as ra, Responses as re"\
      " WHERE r.id = re.request_id AND re.id = ra.response_id)"
  end

  #Skills Report Data

  def developer_skill_interests
    ActiveRecord::Base.connection.select_all " SELECT s.name AS skill, "\
    " SUM(ds.interest_level > 0 AND u.u_location = 'Boston') AS 'boston', "\
    " SUM(ds.interest_level > 0 AND u.u_location = 'Chicago') AS 'chicago', "\
    " SUM(ds.interest_level > 0 AND u.u_location = 'Mumbai') AS 'mumbai', "\
    " SUM(ds.interest_level > 0 AND u.u_location = 'Houston') AS 'houston', "\
    " SUM(ds.interest_level > 0 AND u.u_location = 'London') AS 'london', "\
    " SUM(ds.interest_level > 0 AND u.u_location = 'San Francisco') AS 'san_francisco' "\
    " FROM Users u JOIN Desired_skills ds ON ds.user_id = u.id JOIN Skills s ON s.id = ds.skill_id"\
    " GROUP BY s.name"
  end

  def average_skill_levels
    ActiveRecord::Base.connection.select_all " SELECT s.name AS skill, "\
    " ROUND(AVG(CASE WHEN u.u_location = 'Boston' THEN cs.proficiency_level END),2) AS 'boston', "\
    " ROUND(AVG(CASE WHEN u.u_location = 'Chicago' THEN cs.proficiency_level END),2) AS 'chicago', "\
    " ROUND(AVG(CASE WHEN u.u_location = 'Mumbai' THEN cs.proficiency_level END),2) AS 'mumbai', "\
    " ROUND(AVG(CASE WHEN u.u_location = 'Houston' THEN cs.proficiency_level END),2) AS 'houston', "\
    " ROUND(AVG(CASE WHEN u.u_location = 'London' THEN cs.proficiency_level END),2) AS 'london', "\
    " ROUND(AVG(CASE WHEN u.u_location = 'San Francisco' THEN cs.proficiency_level END),2) AS 'san_francisco' "\
    " FROM Users u JOIN Current_skills cs ON cs.user_id = u.id JOIN Skills s ON s.id = cs.skill_id"\
    " GROUP BY s.name"
  end

  #Impact Data

  def developer_volunteer_offices
    ActiveRecord::Base.connection.select_all " SELECT sub.name AS 'user', "\
    " CASE WHEN sub.month_difference >= 5 THEN COUNT(DISTINCT sub.office_name) ELSE 0 END AS 'Cumulative Total 5 Months Ago', "\
    " CASE WHEN sub.month_difference >= 4 THEN Count(DISTINCT sub.office_name) ELSE 0 END AS '4 Months Ago', "\
    " CASE WHEN sub.month_difference >= 3 THEN Count(DISTINCT sub.office_name) ELSE 0 END AS '3 Months Ago', "\
    " CASE WHEN sub.month_difference >= 2 THEN Count(DISTINCT sub.office_name) ELSE 0 END AS '2 Months Ago', "\
    " CASE WHEN sub.month_difference >= 1 THEN Count(DISTINCT sub.office_name) ELSE 0 END AS '1 Month Ago', "\
    " CASE WHEN sub.month_difference >= 0 THEN Count(DISTINCT sub.office_name) ELSE 0 END AS 'This Month' "\
    " FROM ( "\
    " SELECT u.id AS id, u.name as name, r.office_name, (strftime('%Y%m', 'now') - strftime('%Y%m', ra.created_at)) as month_difference "\
    " FROM Users u "\
    " LEFT OUTER JOIN Responses re ON u.id = re.user_id "\
    " LEFT OUTER JOIN Requests r ON r.id = re.request_id "\
    " LEFT OUTER JOIN Assignments ra ON ra.response_id = re.id "\
    " WHERE r.date_cancelled IS NULL "\
    " ) AS sub "\
    " GROUP BY user "\
    " ORDER BY user"
  end

  def shared_developers_three
    ActiveRecord::Base.connection.select_all "SELECT l.name as location, "\
    " SUM(sub.u_location = 'Boston') as boston, "\
    " SUM(sub.u_location = 'Chicago') as chicago, "\
    " SUM(sub.u_location = 'Mumbai') as mumbai, "\
    " SUM(sub.u_location = 'Houston') as houston, "\
    " SUM(sub.u_location = 'London') as london, "\
    " SUM(sub.u_location = 'San Francisco') as 'san_francisco' "\
    " FROM locations as l LEFT OUTER JOIN ( "\
    " SELECT u.u_location, r.office_name, strftime('%Y%m', ra.created_at) - '201302' as time_difference "\
    " FROM Users u "\
    " JOIN Responses re ON u.id = re.user_id "\
    " JOIN Requests r ON r.id = re.request_id "\
    " JOIN assignments ra ON re.id = ra.response_id "\
    " WHERE time_difference <= 2 AND office_name != u_location) "\
    " AS sub ON l.name = sub.office_name "\
    " GROUP BY Location "\
    " ORDER BY Location "
  end



  def shared_developers_six
    ActiveRecord::Base.connection.select_all "SELECT l.name as location, "\
    " SUM(sub.u_location = 'Boston') as boston, "\
    " SUM(sub.u_location = 'Chicago') as chicago, "\
    " SUM(sub.u_location = 'Mumbai') as mumbai, "\
    " SUM(sub.u_location = 'Houston') as houston, "\
    " SUM(sub.u_location = 'London') as london, "\
    " SUM(sub.u_location = 'San Francisco') as 'san_francisco' "\
    " FROM locations as l LEFT OUTER JOIN ( "\
    " SELECT u.u_location, r.office_name, strftime('%Y%m', ra.created_at) - '201302' as time_difference "\
    " FROM Users u "\
    " JOIN Responses re ON u.id = re.user_id "\
    " JOIN Requests r ON r.id = re.request_id "\
    " JOIN assignments ra ON re.id = ra.response_id "\
    " WHERE time_difference <= 5 AND office_name != u_location) "\
    " AS sub ON l.name = sub.office_name "\
    " GROUP BY Location "\
    " ORDER BY Location "
  end


end
