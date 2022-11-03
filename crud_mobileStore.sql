USE mobilestore;
SELECT * FROM smartphone;
SELECT * FROM vendorcontact;
SELECT * FROM customershippinginfo;

-- Update a smartphone's price
UPDATE smartphone
SET Price = 425
WHERE idPhone = "GA53Blck128";

-- Update contact infos
UPDATE vendorcontact
SET Number = "209-218-4343"
WHERE idVendor = 1;  

-- Update shipping info
UPDATE customershippinginfo
SET FirstName = "Julia", Email = "j.evans@gmail.com", Phonenumber = "775-233-9186"
WHERE idCustomer = 93274;

-- Delete a phone type
DELETE from smartphone
WHERE idPhone = "GS22+Wht128";

-- The total amount of Order No.102 
SELECT SUM(smartphone.Price) AS "TotalAmountNo102"
FROM stock_has_order
INNER JOIN smartphone ON stock_has_order.Stock_Model = smartphone.idPhone
WHERE Order_idOrder = 102;

-- Smartphones with more than 4500 mAh which prices are lower than 1000 $ and the vendor contact infos 
SELECT Model, Battery, Price, vendorcontact.Company, vendorcontact.Name, vendorcontact.Email, vendorcontact.Number
FROM smartphone
INNER JOIN mobileseries ON smartphone.MobileSeries = mobileseries.idMobileSeriesName
INNER JOIN vendorcontact ON mobileseries.Vendor = vendorcontact.idVendor
WHERE battery >= 4500 AND Price < 1000
ORDER BY Price ASC;

-- The total amount of the completed orders 
SELECT SUM(smartphone.Price) AS "TotalAmountCompletedOrders"
FROM stock_has_order
INNER JOIN smartphone ON stock_has_order.Stock_Model = smartphone.idPhone
INNER JOIN shoporder ON stock_has_order.Order_idOrder = shoporder.idOrder
WHERE shoporder.Status = "Completed";

-- The list of city where the shop has to send orders yet
SELECT customershippinginfo.city
FROM customershippinginfo
INNER JOIN shoporder ON customershippinginfo.idCustomer = shoporder.CustomerID
WHERE shoporder.Status IN ("In Progress", "New")
ORDER BY city DESC;

-- BonusTask1
/* 
Transactions are SQL commands which are logically connected.
The tranactions have to been run completly to databases stay uncontroversial (they won't cause conflict).
And we have to solve that a database will be consistent in case of transaction interruption.
It is used usually when the database have more user/modifier.
It has 4 command: START, COMMIT (to save the changes in the memory), ROLLBACK (roll back/delete the changes),
ROLLBACK TO ( roll back to a savepoint),  SAVEPOINT (roll back this points), (SET TRANSACTION (initiation th transaction))
//ACID rules - Atomicity, Consistency, Isolation, Durability)//
*/

-- START TRANSACTION; - if I set the characteristics 
BEGIN;
SAVEPOINT ORIGINAL; 
DELETE from smartphone
WHERE idPhone = "GS22+Blck256";

SAVEPOINT SP_1;
UPDATE smartphone
SET Price = 670
WHERE idPhone = "IP13MBg128";

SAVEPOINT SP_2;
ROLLBACK TO SAVEPOINT ORIGINAL;
COMMIT;

SELECT * from smartphone;

  