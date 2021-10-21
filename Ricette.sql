--create database RicetteDellaNonna;

create table Libro (
IdLibro int not null,
Titolo nvarchar(50),
Tipologia varchar(50),
constraint PK_Libro primary key (IdLibro)
);

create table Ricetta (
IdRicetta int not null constraint PK_IdRicetta primary key,
TempoPreparazione int not null,
Nome nvarchar(30),
NumeroPersone int not null,
Procedimento nvarchar(100),
IdLibro int not null,
constraint FK_IdLibro FOREIGN KEY (IdLibro) REFERENCES Libro(IdLibro),
);

create table Ingredienti (
IdIngredienti int not null primary key,
Nome nvarchar(20),
Descrizione nvarchar(30),
UnitàMisura nvarchar(5),
);

create table IngredientiRicetta (
IdRicetta int not null, 
IdIngredienti int not null,
QuantitàIngredienti int not null,
constraint FK_Ricetta FOREIGN KEY (IdRicetta) REFERENCES Ricetta(IdRicetta),
constraint FK_Ingredienti FOREIGN KEY (IdIngredienti) REFERENCES Ingredienti(IdIngredienti), 
constraint PK_IngrRicetta PRIMARY KEY(IdRicetta,IdIngredienti)
);


insert into Libro values (1, 'I Dolci della Nonna', 'Torte');
insert into Libro values (2, 'I Primi della Nonna', 'Primi Piatti');
insert into Libro values (3, 'I Secondi della Nonna', 'Secondi Piatti');
insert into Ricetta values (1,60,'Torta alle mele', 4,'Unire 4 tuorli a 200gr di farina, 100gr di zucchero, 5gr di lievito e 3 mele',1);
insert into Ingredienti values(1, 'farina', 'Farina00', 'g'),(2, 'uova','uova medie', 'pzz'), (3,'lievito','lievitoperdolci','g');
insert into IngredientiRicetta values (1,1,200);
insert into IngredientiRicetta values (1,2,4);
insert into IngredientiRicetta values (1,3,5);
insert into Ricetta values (2,60,'Pasta fresca', 4,'Unire 3 tuorli a 400gr di farina',2);
insert into IngredientiRicetta values (2,1,400);
insert into IngredientiRicetta values (2,2,3);
insert into Ricetta values (3,30,'Arrosto di tacchino', 4,'Affettare il tacchino e unirlo con le patate. Forno per 30min',3);
insert into Ingredienti values (4, 'Carne', 'Carne di Tacchino','g')
insert into IngredientiRicetta values (3,4,1);
insert into Ricetta values (4,3,'Maialetto', 3,'Mettere il maialetto nella brace',3);
insert into Ingredienti values (5, 'Carne', 'Carne di Maiale','g')
insert into IngredientiRicetta values (4,5,1);



--Esercitazione Ricette Nonna
--1.Visualizzare tutta la lista degli ingredienti distinti.

select distinct *
from Ingredienti

--2.Visualizzare tutta la lista degli ingredienti distinti utilizzati in almeno una ricetta.
select distinct i.Nome
from Ingredienti i join IngredientiRicetta ir on i.IdIngredienti=ir.IdIngredienti
--join Ricetta r on ir.IdRicetta=r.IdRicetta

--3.Estrarre tutte le ricette che contengono l’ingrediente uova.
select r.*
from Ricetta r join IngredientiRicetta ir on r.IdRicetta=ir.IdRicetta
join Ingredienti i on ir.IdIngredienti=i.IdIngredienti
where i.Nome='Uova'

--4.Mostrare il titolo delle ricette che contengono almeno 4 uova
select r.Nome
from Ricetta r join IngredientiRicetta ir on r.IdRicetta=ir.IdRicetta
join Ingredienti i on ir.IdIngredienti=i.IdIngredienti
where i.Nome='Uova'
AND ir.QuantitàIngredienti>=4

--5.Estrarre tutte le ricette dei libri di Tipologia=Secondi per 4 persone contenenti l’ingrediente carne
select r.Nome
from Libro l join Ricetta r on l.IdLibro=r.IdLibro
join IngredientiRicetta ir on r.IdRicetta=ir.IdRicetta
join Ingredienti i on ir.IdIngredienti=i.IdIngredienti
WHERE l.Tipologia='Secondi Piatti'
AND r.NumeroPersone=4
AND i.Nome='Carne'

--6.Mostrare tutte le ricette che hanno un tempo di preparazione inferiore a 10 minuti.
select r.*
from Ricetta r
where r.TempoPreparazione<10

--7.Mostrare il titolo del libro che contiene più ricette
--select NuovaTabella.Titolo, Max(NuovaTabella.NumeroRicette)
--from (select l.Titolo, count(r.IdLibro) as NumeroRicette
--from Ricetta r join Libro l on r.IdLibro=l.IdLibro  group by l.Titolo) as NuovaTabella
--group by  NuovaTabella.Titolo

select Tit
from (select l.Titolo as Tit, count (r.IDRicetta) as 'NumeroRicette'
      from Libro l join Ricetta r on r.IDLibro=l.IDLibro
      group by l.Titolo) as Tabella_Libro_NumeroRicette
 
where NumeroRicette = (select max(NumeroRicette) 
                        from (select l.Titolo as Tit, count (r.IDRicetta) as 'NumeroRicette'
                              from Libro l join Ricetta r on r.IDLibro=l.IDLibro
                              group by l.Titolo) as Tabella_Libro_NumeroRicette)
 

--nuova vista mi creo una nuova tabella così la richiamo direttamente 
create view Tabella_Libro_NumeroRicette(Tit,NumeroRicette)
as (select l.Titolo as Tit, count (r.IDRicetta) as 'NumeroRicette'
from Libro l join Ricetta r on r.IDLibro=l.IDLibro
group by l.Titolo)


select Tit
from Tabella_Libro_NumeroRicette
where NumeroRicette = (select max(NumeroRicette) from Tabella_Libro_NumeroRicette)



--8.Visualizzare i Titoli dei libri ordinati rispetto al numero di ricette che contengono 
--(il libro che contiene più ricette deve essere visualizzato per primo, quello con meno ricette per ultimo)
--e, a parità di numero ricette in ordine alfabetico su Titolo del libro.
select l.Titolo, count(r.IdRicetta) as NumeroRicette
from Ricetta r join Libro l on r.IdLibro=l.IdLibro
group by l.Titolo
order by NumeroRicette desc, l.Titolo