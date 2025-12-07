use airlines;
show tables;


-- KPIs 
Select concat(round((sum(Transported_Passengers) / sum(Available_Seats)) * 100, 2), "%") as Load_Factor from maindata;

Select concat(format(sum(Transported_Passengers)/1000000,0), "M") as Total_Passengers from maindata;

Select concat(round(count(*)/1000,0), "K") as Total_Flights from maindata;

Select concat(format(sum(distance)/1000000,2), "M") as Total_Distance from maindata;

Select count(Airline_ID) as Total_Airlines from Airlines;


--  Find the load Factor percentage, Total Passengers, Total Distance on a yearly ( Transported passengers / Available seats) 
call airlines.Year_wise_Data(2009);


--  Find the load Factor percentage on a Quarterly , Monthly basis ( Transported passengers / Available seats)
-- Quarter
Select concat("Q", ceil(month/ 3)) as Qtr, 
concat(round((sum(Transported_Passengers) / sum(Available_Seats)) * 100, 2), "%") as Load_Factor from maindata
group by Qtr
order by Qtr;

-- Monthly
Select ELT(month,
        'January','February','March','April','May','June',
        'July','August','September','October','November','December') AS Months,
concat(round((sum(Transported_Passengers) / sum(Available_Seats)) * 100, 2), "%") as Load_Factor from maindata
group by Months
order by 2 desc;


-- Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats)
Select Carrier_Name, 
concat(round((sum(Transported_Passengers) / sum(Available_Seats)) * 100, 2), "%") as Load_Factor from maindata
group by Carrier_Name
order by 2 desc
limit 90;


-- Identify Top 20 Carrier Names based on passengers preference 
Select distinct(Carrier_Name) , sum(Transported_passengers) as Passengers from maindata
group by 1 
order by 2 desc
limit 20;


--  Display top Routes (from-to City) based on Number of Flights 
 Select From_To_City as Routes, 
 count(*) as Total_Flights from maindata
 group by 1 
 order by 2  desc
 limit 20;


-- Identify the how much Total Flights, Total Passengers, Total Seats Available, Load Factor is occupied on Weekend vs Weekdays.
SELECT 
DateType,
 COUNT(*) AS Total_Flights,
SUM(Transported_Passengers) AS Total_Transported_Passengers,
SUM(Available_Seats) AS Total_Available_Seats,
CONCAT(ROUND((SUM(Transported_Passengers) / SUM(Available_Seats)) * 100, 2), '%') AS Load_Factor
FROM (SELECT 
CAST(CONCAT(year, "-", month, "-", day) AS DATE) AS Data_Fields,
CASE 
WHEN DAYOFWEEK(CAST(CONCAT(year, "-", month, "-", day) AS DATE)) IN (1,7) 
THEN 'WeekEnd'
ELSE 'WeekDay'
END AS DateType,
Transported_Passengers,
Available_Seats
FROM maindata
) AS abc
GROUP BY DateType;


-- Identify number of flights based on Distance groups Distance_Group_ID Distance_Interval
Select a.Distance_Interval as Distance_Interval, 
count(b.Airline_ID) as Total_Flights 
from maindata as b 
join
Distance_groups as a
on a.Distance_group_id = b.Distance_group_id
group by 1
order by 2 desc;


-- Top Airlines by total passengers
Select b.Airline as Airlines,
sum(a.Transported_Passengers) as Total_Passengers
from maindata as a 
join 
airlines as b
on a.Airline_id=b.Airline_id
group by 1
order by 2 desc
limit 50;


-- Top Airlines by Load Factor
call Top_airlines_by_Load_Factor;