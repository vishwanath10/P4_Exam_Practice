declare @currencycode as nvarchar(255)
       ,@name as nvarchar(255)

declare my_cursor cursor local forward_only static read_only for
select CurrencyCode, [Name]
from Sales.Currency

open my_cursor

fetch next from my_cursor 
into @currencycode, @name

while @@FETCH_STATUS = 0
begin

print @currencycode
print @name

fetch next from my_cursor 
into @currencycode, @name

print @currencycode
print @name 

end

close my_cursor
deallocate my_cursor
