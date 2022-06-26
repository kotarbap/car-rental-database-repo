create procedure p_poprzedni_klienci
--ktorzy jezdzili danym samochodem, np weryfikacja dawnego mandatu
@rejestracja varchar(10)
AS
BEGIN TRY
	 if
	@rejestracja is null 
    raiserror('rejestracja nie moze przyjmowaæ wartoœci null', 16, 1)

	if not exists 
    (
        select * from Samochody 
        where Samochody.rejestracja = @rejestracja
    )
    raiserror('Samochod o podanej rejestracji nie istnieje', 16 ,1)

	select s.rejestracja, k.imie, k.nazwisko, k.nr_telefonu, k.pesel, r.data_od, r.data_do, r.cena, r.data_zwrotu, r.kara from Klienci as k
	join Rezerwacje as r on k.id_klienta = r.id_klienta
	join Samochody as s on r.id_samochodu = s.id_samochodu
	where s.rejestracja = @rejestracja

END TRY
begin catch
 
    print error_message()
 
    declare @err_msg varchar(100)
    set @err_msg = error_message()
    
    raiserror(@err_msg, 16, 1)
 
end catch

select * from Rezerwacje
exec p_poprzedni_klienci 'KR45789'