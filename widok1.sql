CREATE VIEW v_przychody
as
SELECT sum(cena) as cena, sum(kara) as kara FROM Rezerwacje
WHERE stan = 'Z' or stan = 'S'
