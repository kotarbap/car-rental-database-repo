alter procedure p_samochody_marki
@marka varchar(20)
AS
BEGIN TRY
	 if
	@marka is null 
    raiserror('marka nie moze przyjmowaæ wartoœci null', 16, 1)

	if not exists 
    (
        select * from Marki 
        where Marki.marka = @marka
    )
    raiserror('marka o podanej nazwie nie istnieje', 16 ,1)

 select m.marka, mm.model, mm.il_osob, s.dostepnosc, s.rejestracja from Marki as m
 join Modele as mm on m.id_marki = mm.id_marki
 join Samochody as s on s.id_modelu = mm.id_modelu
 where m.marka = @marka
END TRY
begin catch
 
    print error_message()
 
    declare @err_msg varchar(100)
    set @err_msg = error_message()
    
    raiserror(@err_msg, 16, 1)
 
end catch

exec p_samochody_marki
