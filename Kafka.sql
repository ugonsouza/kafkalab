-- Create the test database
CREATE DATABASE testDB;
GO
USE testDB;
EXEC sys.sp_cdc_enable_db;

-- Create some customers ...
CREATE TABLE customers (
  id INTEGER IDENTITY(1001,1) NOT NULL PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE
);

DELETE FROM customers
GO
INSERT INTO customers(first_name,last_name,email)
  VALUES ('Sally','Thomas','sally.thomas@acme.com');
INSERT INTO customers(first_name,last_name,email)
  VALUES ('George','Bailey','gbailey@foobar.com');
INSERT INTO customers(first_name,last_name,email)
  VALUES ('Edward','Walker','ed@walker.com');
INSERT INTO customers(first_name,last_name,email)
  VALUES ('Anne','Kretchmar','annek@noanswer.org');
EXEC sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'customers', @role_name = NULL, @supports_net_changes = 0;
GO

--------------------------------------------------
EXEC sys.sp_cdc_enable_table 
  @source_schema = 'dbo', 
  @source_name = 'customers', 
  @role_name = NULL, 
  @supports_net_changes = 0;
GO

EXEC sys.sp_cdc_disable_table  
  @source_schema = N'dbo',  
  @source_name   = N'customers',  
  @capture_instance = N'dbo_customers'  
GO  

--INSERT INTO customers(first_name,last_name,email) VALUES ('Anne','Kretchmar','annek@noanswer19.org');

declare 
	@i int = 121,
	@j int = 0,
	@stmt nvarchar(500)

set @j = @i + 100
while @i <= @j
begin
	set @stmt = 'INSERT INTO customers(first_name,last_name,email) VALUES (''Anne'',''Kretchmar'',''annek@noanswer' + cast(@i as varchar(10)) + '.org'');'
	--print(@stmt)
	exec sp_executesql @stmt
	set @i = @i + 1
end