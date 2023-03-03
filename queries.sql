--working on the tables we have previously created
--creating a sequence

CREATE SEQUENCE secventa
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

--set 'valabilitate_contract' to NULL where 'concurs' has ID=2 and 'bar' has ID=5
UPDATE comercializare SET valabilitate_contract=NULL where(select concursID from concurs where concursID='2')=concursID and
(select barID from bar where barID='5')=barID;

--inserting into 'copii' and 'participare' tables and deleting from 'participare'
INSERT INTO copii(copilID, nume, prenume, numeDans, numeMelodie, antrenorID)
values ('10', 'Stan', 'Andrei', 'Albinutele', 'After Dark', '5');
INSERT INTO participare(participareID, data_participare, concursID, copilID)
values('10', '04/09/2022', '4', '10');
select * from participare;
DELETE from participare where (select copilID from copii where nume='Stan')=copilID;
ROLLBACK;

--creating and modifying a view that contains the sponsors
--where the ticket price is higher than 50
CREATE VIEW sp_concurs AS
select s.nume_sponsor, s.email_sponsor
from sponsor s join concurs c on(s.sponsorID=c.concursID)
where c.pret_bilet>50;

CREATE OR REPLACE VIEW sp_concurs AS
select s.nume_sponsor NumeSp, s.email_sponsor EmailSp, c.nume_concurs NumeCon, c.localitate OrasCon
from sponsor s join concurs c on(s.sponsorID=c.concursID)
where c.pret_bilet>50;

--inserting into the view previously created
insert into sp_concurs(idspon, NumeSp, EmailSp)
values('22', 'Coca Cola', 'cola@gmail.com');

--queries 
select c.nume_concurs,
case when months_between(sysdate,c.data_concurs)<3 then 'A fost recent' else 'A fost acum mai mult timp'
end
from concurs c
group by c.nume_concurs, c.data_concurs;

select nvl(c.nume_concurs, 'Nu exista') as "Nume", c.localitate, s.nume_sponsor, b.nume_bar, sc.nume_scena, d.nume NumeDJ
from concurs c
join sponsor s on(c.concursID=s.sponsorID)
join bar b on(c.concursID=b.barID)
join scena sc on(c.concursID=sc.scenaID)
join dj d on(c.concursID=d.djID)
where nume_concurs in(select nume_concurs from concurs where nume_concurs like 'Evolution');

select nume, count(aprilie) aprilie, count(ianuarie) ianuarie
from(
    select c.copilID, concat(c.nume, c.prenume) nume, con.data_concurs, decode(extract(month from con.data_concurs),4,'aprilie') aprilie, decode(extract(month from con.data_concurs),1,'ianuarie') ianuarie
    from copii c join concurs con on(c.copilID=con.concursID)
)
group by nume;