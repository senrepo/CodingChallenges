USE Ecommerce;

DROP PROCEDURE IF EXISTS uspCustomerOrderStatus;

CREATE PROCEDURE uspCustomerOrderStatus (
	@CustomerId As int
) AS
BEGIN
	select A.CustomerId, A.CustomerName,A.OrderId, A.OrderStatus, A.OrderDate, A.ShippingStatus, A.TotalPrice, B.BillAmt from (
			select c.CustomerId, c.CustomerName, o.OrderId, o.OrderDate, o.OrderStatus, s.Status as ShippingStatus, sum(UnitPrice * Quantity) TotalPrice from Customers c 
			inner join Orders o on c.CustomerId = o.CustomerId
			inner join OrderDetails od on od.OrderId = o.OrderId
			inner join Shipping s on s.OrderId = o.OrderId
			where c.CustomerId = @CustomerId
			group by c.CustomerId, c.CustomerName, o.OrderId, o.OrderDate, o.OrderStatus, s.Status) A
		inner join
		(	
			select c.CustomerId, o.OrderId, sum(b.BillAmt) BillAmt from Customers c
			inner join Orders o on c.CustomerId = o.CustomerId
			inner join Billing b on b.OrderId = o.OrderId
			where c.CustomerId = @CustomerId
			group by c.CustomerId, O.OrderId) B 
		on A.OrderId = B.OrderId
END;


Execute uspCustomerOrderStatus @CustomerId=1001