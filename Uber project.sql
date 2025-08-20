create database uber_dataset;
use uber_dataset;

select * from uber_data;

-- > select the Pickup locations where booking is confirmed.

select `booking status`, 
`pickup location` 
from uber_data 
where `booking status` = 'completed';

-- > show the data without having any incomplete ride.

select * from uber_data where `incomplete rides` is null;

-- > find out the average driving rating of every vehicle;

select `vehicle type`, 
round(avg(`driver ratings`),2) as avg_rating 
from uber_data 
group by `vehicle type` 
order by avg_rating desc;

-- > What percentage of total rides are Completed, Cancelled, Incomplete, or No Driver Found

select `booking status` , 
count (`booking status`) * 100/ (select count(`booking status`) from uber_data) as percentage
from uber_data 
group by `booking status`
order by percentage desc;

-- > Which Pickup locations have the highest cancellation based on cancelled rides by customer

select `pickup location` ,
sum(coalesce(`cancelled rides by customer`,0)) as Cancel_by_customer,
sum(coalesce(`cancelled rides by driver`,0)) as Cancel_by_driver
from uber_data
group by  `pickup location`
order by cancel_by_customer desc;

-- > Which Drop locations have the highest cancellation based on cancelled rides by driver

select `drop location` ,
sum(coalesce(`cancelled rides by customer`,0)) as Cancel_by_customer,
sum(coalesce(`cancelled rides by driver`,0)) as Cancel_by_driver
from uber_data
group by `drop location`
order by cancel_by_driver desc;

-- > Who cancels more often — customers or drivers?

select 
sum(coalesce(`cancelled rides by customer`,0)) as Cancel_by_customer, 
sum(coalesce(`cancelled rides by driver`,0)) as Cancel_by_driver
from uber_data;

-- > What are the top reasons for ride cancellations.

-- BASED ON CUSTOMER CANCELATION:-
select `reason for cancelling by customer`, 
count(`reason for cancelling by customer`) as Num_of_ride_cancel_by_Customer
from uber_data
group by `reason for cancelling by customer`
order by Num_of_ride_cancel_by_Customer desc;

-- BASED ON DRIVER CANCELATION:- 
select `driver cancellation reason` ,
count(`driver cancellation reason`) as Num_of_ride_cancel_by_Driver
from uber_data
group by  `driver cancellation reason`
order by Num_of_ride_cancel_by_Driver desc;

-- Count the cancelation of ride by customer as well as driver.

select `booking status`, count(*) from uber_data
where `booking status` in ('cancelled by Driver', 'Cancelled by Customer')
group by `booking status`;

-- > Which vehicle type (Auto, Bike, Sedan, etc.) has the highest completion;

select `vehicle type`, count(*) as No_of_ride_completed
from uber_data
where `booking status` = 'completed'
group by `vehicle type`
order by No_of_ride_completed desc ;

-- > Find out the percentage of ride complete on basis of vehicle type.

select `vehicle type` , count(*) * 100/ (select count(*) from uber_data) as No_of_ride_completed 
from uber_data
where `booking status` = 'completed'
group by `vehicle type`
order by No_of_ride_completed desc ;

-- > Which vehicle type contributes the most revenue?

select `vehicle type`, sum(`booking value`) as total_value
from uber_data
where `booking status` = 'completed'
group by `vehicle type` 
order by total_value desc;

-- > Compare the average ride distance and booking value across different vehicle types.

select `vehicle type`, 
round(avg(`ride distance`),2) as avg_ride_distance,
round(avg(`booking value`),2) as avg_booking_value
from uber_data 
group by `vehicle type`;

-- > What is the average booking value per completed ride?

select round(avg(`booking value`),2) as completed_ride_avg_value
from uber_data
where `booking status` = 'completed';

-- > Which payment method is used most frequently?

select case when `payment method` is null then 'unknown' else `payment method` end as payment_mode ,
count(*) as total_transaction 
from uber_data
group by payment_mode
order by total_transaction desc ;

-- > At what time of the day (morning, afternoon, evening, night) do most bookings happen?

select 
case when hour(time) between 5 and 11 then 'Morning'
when hour(time) between 12 and 16 then 'Afternoon'
when hour(time) between 17 and 20 then 'Evening'
else 'Night' end as time_slot,
count(`booking id`) as Booking_happend
from uber_data
group by time_slot
order by booking_happend desc;

-- > Which month had the highest completed rides and revenue?

select monthname(date), 
count(`booking status`) as completed_ride,
sum(`booking value`) as total_revenue
from uber_data
where `booking status` = 'completed'
group by monthname(date)
order by total_revenue desc;

-- > What is the average driver vs. customer rating

-- Method 1
select 
round(sum(`driver ratings`)/(select count(`driver ratings`) from uber_data),2),
round(sum(`customer rating`)/(select count(`customer rating`) from uber_data),2)
from uber_data;

-- Method 2
select round(avg(`driver ratings`),2) as avg_driver_rating,
round(avg(`customer rating`),2) as avg_customer_rating
from uber_data;

-- > Is there a correlation between ride distance/booking value and ratings?

select 
case when `ride distance` < 5 then 'Small (<5 km)'
when `ride distance` between 5 and 8 then 'Medium (5-8 km)'
else 'Large (>8 km)' end as Distance_category,
round(avg(`booking value`),2) as avg_booking_value,
round(avg(`customer rating`),2) as avg_customer_rating,
round(avg(`driver ratings`),2) as avg_driver_rating
from uber_data
group by distance_category;



