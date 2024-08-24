-- Display all data
SELECT *
FROM hotel_bookings

-- What is the big picture of room booking over year and month?
SELECT
	arrival_date_year AS year,
	arrival_date_month AS month,
	COUNT(*) AS total_bookings
FROM 
	hotel_bookings
GROUP BY
	arrival_date_year, arrival_date_month
ORDER BY
	arrival_date_year, arrival_date_month



-- What are the most effective booking channels?
SELECT
	distribution_channel,
	COUNT(*) AS total_bookings,
	RANK() OVER (ORDER BY COUNT(*) DESC) AS effectiveness_rank
FROM
	hotel_bookings
GROUP BY
	distribution_channel
ORDER BY
	effectiveness_rank ASC;

-- Are the guests interested in booking meals along with their room reservation?
SELECT
	meal, 
	COUNT(*) AS total_meal_booking
FROM 
	hotel_bookings
WHERE
	meal IS NOT NULL AND meal <> ''
GROUP BY
	meal
ORDER BY
	total_meal_booking DESC;


-- What are the most popular hotels?
SELECT
	hotel, 
	COUNT(*) AS hotel_types
FROM 
	hotel_bookings
WHERE
	hotel IS NOT NULL AND hotel <> ''
GROUP BY
	hotel
ORDER BY
	hotel_types DESC;

-- Compare those hotels on customer's group
SELECT
	hotel,
	customer_type,
	COUNT(*) AS total_bookings
FROM
	hotel_bookings
GROUP BY
	hotel, customer_type
ORDER BY
	hotel, customer_type, total_bookings DESC;

-- Find total special requests per room_type
SELECT 
	assigned_room_type,
	SUM(total_of_special_requests) AS total_special_requests,
	COUNT(*) AS total_requests
FROM 
	hotel_bookings
GROUP BY
	assigned_room_type
ORDER BY
	total_requests DESC


-- What market segment has highest repeated guest rate and highest stay duration?
SELECT
	market_segment,
	AVG(CASE WHEN is_repeated_guest = 1 THEN 1 ELSE 0 END)*100 AS repeated_guest_rate,
	AVG(stays_in_weekend_nights + stays_in_week_nights) AS average_stay_duration
FROM
	hotel_bookings
GROUP BY
	market_segment
ORDER BY
	repeated_guest_rate DESC, average_stay_duration

-- What is the correlation between baby and parent's decision on meals
SELECT
	meal,
	AVG(children + babies) AS average_kids
FROM
	hotel_bookings
GROUP BY
	meal
ORDER BY
	meal, average_kids

-- What types of room are most popular for children and babies?
SELECT
	assigned_room_type,
	SUM(children) AS total_children, 
	SUM(babies) AS total_babies,
	(SUM(children) + SUM(babies)) AS total_kids
FROM 
	hotel_bookings
GROUP BY
	assigned_room_type
ORDER BY
	total_kids DESC