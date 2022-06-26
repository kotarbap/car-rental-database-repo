alter procedure p_odbierz_samochod
    @id_samochodu int,
	@id_rezerwacji int

as
begin try
	if
	@id_samochodu is null or
	@id_rezerwacji is null
    raiserror('argumenty nie mog¹ przyjmowaæ wartoœci null', 16, 1)

	if not exists 
    (
        select * from Samochody 
        where Samochody.id_samochodu = @id_samochodu
    )
    raiserror('samochod o podanym id nie istnieje', 16 ,1)

	if not exists 
    (
        select * from Rezerwacje
        where Rezerwacje.id_rezerwacji = @id_rezerwacji
    )
    raiserror('rezerwacja o podanym id nie istnieje', 16 ,1)

UPDATE Samochody
SET dostepnosc = 'N'
WHERE id_samochodu = @id_samochodu

update Rezerwacje 
   set stan = 'W'
   where id_samochodu = @id_samochodu and id_rezerwacji = @id_rezerwacji
	

end try
begin catch
 
    print error_message()
 
    declare @err_msg varchar(100)
    set @err_msg = error_message()
    
    raiserror(@err_msg, 16, 1)
 
end catch

exec p_odbierz_samochod 4, 5

