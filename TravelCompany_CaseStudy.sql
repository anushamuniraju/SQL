use ANUPORTFOLIO;
CREATE TABLE booking_table(
   Booking_id       VARCHAR(3) NOT NULL 
  ,Booking_date     date NOT NULL
  ,User_id          VARCHAR(2) NOT NULL
  ,Line_of_business VARCHAR(6) NOT NULL
);
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b1','2022-03-23','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b2','2022-03-27','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b3','2022-03-28','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b4','2022-03-31','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b5','2022-04-02','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b6','2022-04-02','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b7','2022-04-06','u5','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b8','2022-04-06','u6','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b9','2022-04-06','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b10','2022-04-10','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b11','2022-04-12','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b12','2022-04-16','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b13','2022-04-19','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b14','2022-04-20','u5','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b15','2022-04-22','u6','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b16','2022-04-26','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b17','2022-04-28','u2','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b18','2022-04-30','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b19','2022-05-04','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b20','2022-05-06','u1','Flight');
CREATE TABLE user_table(
   User_id VARCHAR(3) NOT NULL
  ,Segment VARCHAR(2) NOT NULL
);
INSERT INTO user_table(User_id,Segment) VALUES ('u1','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u2','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u3','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u4','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u5','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u6','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u7','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u8','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u9','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u10','s3');



Select * from booking_table;
Select * from user_table;

-- Find the segment wise total users
--incorrect because it elimates the users that don't have any bookings
select user_table.Segment,count(distinct booking_table.User_id) as Total_User_Count from booking_table inner join user_table on booking_table.User_id=user_table.User_id
group by Segment;
/*correct
note the grouping should be done in the users in the user table not in 
the booking table and we need alk the users from the user table even 
if they dont have booking so we use a right join*/
select user_table.*, booking_table.* from booking_table right join user_table on booking_table.User_id=user_table.User_id;

select user_table.Segment,count(distinct user_table.User_id) as Total_User_Count from booking_table right join user_table on booking_table.User_id=user_table.User_id
group by Segment;

-- user who booked flight in april 2022
--the case statement is used as a condition to select respective user_id and then a distinct count is done 

/* Find the totals in each segment irrespective of their booking and count of user in each segment who booked flight in april*/
/*Question 1*/
select user_table.Segment,
count(distinct user_table.User_id) as Total_User_Count,
count( distinct case when booking_table.Line_of_business='Flight' and booking_table.Booking_date between '2022-04-01' and '2022-04-30' then  booking_table.User_id else null end) as Total_flightbooking_April
from booking_table right join user_table 
on booking_table.User_id=user_table.User_id
group by Segment

/*Question 2*/
/*Identity users who first booking was a hotel booking*/

select * from booking_table;
with cte as(
select *, rank() over (partition by user_id order by booking_date asc) as booking_order  from booking_table)
select * from cte where booking_order=1 and Line_of_business='Hotel';

/*Alternative solution using first_rank()*/

/*Question 3*/
/*Days between the first and last bookings of User*/

Select User_id,DATEDIFF(day,min(Booking_date),max(Booking_date)) as NumberOfDays_BW_FirstandLastBooking from booking_table group by User_id;

/*Question 4*/
/*Count of the flight and hotel bookings in each of the segment in 2022*/
select * from booking_table b inner join user_table u on b.User_id=u.User_id;

select segment,
count(case when b.Line_of_business='Flight' then b.Booking_id else null end) as No_FlightBookings, 
count(case when b.Line_of_business='Hotel' then b.Booking_id else null end )as No_HotelBookings
from booking_table b inner join user_table u 
on b.User_id=u.User_id
where DATEPART(year,booking_date)='2022'
group by segment;
