SQL-ex exercises


The database scheme consists of four tables:
* Product(maker, model, type)
* PC(code, model, speed, ram, hd, cd, price)
* Laptop(code, model, speed, ram, hd, screen, price)
* Printer(code, model, color, type, price)


Exercise 1
--Find the makers producing PCs but not laptops.--


Select distinct (maker) From product
Where type = 'pc'
Except 
Select distinct (maker) from product
Where type = 'laptop'


Exercise 2
--Get the models and prices for all commercially available products (of any type) produced by maker B.--


Select product.model, price 
From pc join product on pc.model = product.model 
Where maker = 'B'
Union
Select product.model, price 
From laptop join product on laptop.model = product.model 
Where maker = 'B'
Union
Select product.model, price
From printer join product on printer.model = product.model 
Where maker = 'B'


Exercise 3
--Find the printer models having the highest price. Result set: model, price.--


Select distinct (model), price
From printer
Where price = (select max(price) from printer)


Exercise 4
Get pairs of PC models with identical speeds and the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i).
Result set: model with the bigger number, model with the smaller number, speed, and RAM.






Select distinct a.model as model, b.model as model, a.speed, a.ram
From pc as a, pc as b
Where a.speed = b.speed and
A.ram = b.ram and
A.model > b.model


Exercise 5
Get the laptop models that have a speed smaller than the speed of any PC. Result set: type, model, speed.


Select distinct type, laptop.model, speed
From laptop, product 
Where laptop.model = product.model and speed < all (select speed from pc)


Exercise 6
For each maker having models in the Laptop table, find out the average screen size of the laptops he produces. Result set: maker, average screen size.


Select distinct maker, avg (screen)
From laptop join product on laptop.model = product.model
Group by maker


Exercise 7
Find the makers producing at least three distinct models of PCs. Result set: maker, number of PC models.


Select distinct maker, count (type) as count_model
From product
Where type = 'pc'
Group by maker
Having count(type)>=3


Exercise 8
For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds. Result set: speed, average price.


Select speed, avg(price) as avg_price
From pc
Where speed >600
Group by speed


Exercise 9
Find out the maximum PC price for each maker having models in the PC table. Result set: maker, maximum price.


Select distinct maker, max (price) as max_price
From pc join product on pc.model = product.model
Group by maker


Exercise 10
Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher. Result set: maker.


Select maker 
From product join pc on product.model = pc.model
Where speed >= 750
Intersect
Select maker
From product join laptop on product.model = laptop.model
Where speed >= 750




Exercise 11
Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers. Result set: maker, average HDD capacity.


Select maker, avg(hd) as avg_hd
From product join pc on product.model = pc.model
Where maker in (select maker from Product
Where type = 'printer')
And maker in (select maker from product 
Where type = 'pc')
Group by maker




Exercise 12
Find the makers of the cheapest color printers. Result set: maker, price.


Select distinct maker, price
From product join printer on product.model = printer.model
Where price = (select min(price) from printer
Where color = 'y')
And color = 'y'




Exercise 13
List the models of any type having the highest price of all products present in the database.


select distinct product.model
from product, pc, laptop, printer
where product.model in(pc.model, laptop.model, printer.model)
and pc.price = (select max(price) from pc)
and laptop.price = (select max(price) from laptop)
and printer.price = (select max(price) from printer)
and (
(pc.price >= laptop.price and pc.price >= printer.price
and product.model = pc.model)
or
(laptop.price >= pc.price and laptop.price >= printer.price
and product.model = laptop.model)
or
(printer.price >= laptop.price and printer.price >= pc.price
and product.model = printer.model)
)




Exercise 14
Find the model number, speed and hard drive capacity for all the PCs with prices below $500. Result set: model, speed, hd.


Select model, speed, hd 
From PC where price < 500




Exercise 15
List all printer makers. Result set: maker.


Select distinct maker from product
Where type = 'Printer'


Exercise 16
Find the model number, RAM and screen size of the laptops with prices over $1000.


Select model, ram, screen from laptop
Where price > 1000


Exercise 17
Find all records from the Printer table containing data about color printers.


Select * from printer 
Where color = 'y'




Exercise 18
Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive.


Select model, speed, hd from PC
Where price < 600 and (Cd ='12x' or cd = '24x')


Exercise 19
For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops. Result set: maker, speed.






Select distinct (maker), speed 
From product join laptop on laptop.model = product.model
Where hd >= 10




Exercise 20
Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.


Select distinct maker from product join
Pc on pc.model = product.model
Where speed >=450




Exercise 21
Find out the average speed of PCs.


Select avg(speed) from pc




Exercise 22
Find out the average speed of the laptops priced over $1000.


Select avg(speed) from laptop
Where price >1000




Exercise 23
Find out the average speed of the PCs produced by maker A.


Select avg(speed) 
From pc join product on pc.model=product.model
Where maker = 'A'




Exercise 24
Get hard drive capacities that are identical for two or more PCs. Result set: hd.


Select hd from pc
Group by hd
Having count(hd) >=2




Exercise 25
Find out the average price of PCs and laptops produced by maker A. Result set: one overall average price for all items.








Select avg(price) as AVG_price from 
(Select pc.price from product inner join pc on pc.model = product.model
Where maker = 'A'
Union all
Select laptop.price from product inner join laptop on laptop.model = product.model
Where maker = 'A') t




The database of naval ships that took part in World War II is under consideration. The database consists of the following relations:
* Classes(class, type, country, numGuns, bore, displacement)
* Ships(name, class, launched)
* Battles(name, date)
* Outcomes(ship, battle, result)


Exercise 26
For the ships in the Ships table that have at least 10 guns, get the class, name, and country.


Select ships.class, name, country
From ships join classes on ships.class = classes.class
Where numGuns >= 10




Exercise 27
For ship classes with a gun caliber of 16 in. or more, display the class and the country.


Select class, country
From classes
where bore >=16




Exercise 28
In accordance with the Washington Naval Treaty concluded in the beginning of 1922, it was prohibited to build battle ships with a displacement of more than 35 thousand tons.
Get the ships violating this treaty (only consider ships for which the year of launch is known). List the names of the ships.


Select name
From classes join ships on ships.class = classes.class
Where displacement > 35000
And launched >=1922
And type = 'bb'




Exercise 29
Get the ships sunk in the North Atlantic battle. Result set: ship.


Select ship
From outcomes
Where battle = 'North Atlantic'
And result = 'sunk'




Exercise 30
List the names of lead ships in the database (including the Outcomes table).


Select name from ships
Where class = name
Union
Select ship as name from classes join outcomes on classes.class = outcomes.ship