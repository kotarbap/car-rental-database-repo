alter procedure p_dodaj_rezerwacje
    @id_klienta int,
	@id_samochodu int,
    @data_od date,
	@data_do date

as
begin try
	if @id_klienta is null
	or @id_samochodu is null
    or @data_od is null
	or @data_do is null
    raiserror('argumenty nie mog¹ przyjmowaæ wartoœci null', 16, 1)

	if @data_od > @data_do
	raiserror('Data wypozyczenia nie moze byc pozniejsza niz data zwrotu', 16, 1)

	if not exists 
    (
        select * from Klienci 
        where Klienci.id_klienta = @id_klienta
    )
    raiserror('klient o podanym id nie istnieje', 16 ,1)

	if not exists 
    (
        select * from Samochody 
        where Samochody.id_samochodu = @id_samochodu
    )
    raiserror('samochod o podanym id nie istnieje', 16 ,1)

	if exists
	(select * from Rezerwacje
	where (stan = 'W' or stan = 'R') and
	@id_samochodu = id_samochodu
	and ((@data_od>=data_od and @data_do <=data_do) or (@data_od<=data_od and @data_do >=data_do) 
	or (@data_od<=data_do and @data_do >=data_do) or (@data_od<=data_od and @data_do >=data_od))
	)
    raiserror('samochod jest wypozyczony w tym terminie', 16, 1)

	insert Rezerwacje(id_klienta, id_samochodu, data_od, data_do, cena, stan)
    values(@id_klienta, @id_samochodu, @data_od, @data_do, 
		(
			select cena_dzien * DATEDIFF(DAY, @data_od, @data_do) from Klasy as k
			join Modele as m on k.id_klasy = m.id_klasy
			join Samochody as s on s.id_modelu = m.id_modelu
			where @id_samochodu = s.id_samochodu
		),
		'R'
	)

end try
begin catch
 
    print error_message()
 
    declare @err_msg varchar(100)
    set @err_msg = error_message()
    
    raiserror(@err_msg, 16, 1)
 
end catch

exec p_dodaj_rezerwacje 10, 4, '2021-09-18', '2021-09-10'

