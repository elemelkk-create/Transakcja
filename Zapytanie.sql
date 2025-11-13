use twoja_baza;

drop table if exists wyniki_ubezpieczenia;

create table wyniki_ubezpieczenia(
id_ubezpieczenia int auto_increment primary key,
id_klienta int not null,
id_samochodu int not null,
cena_bazowa_zl decimal(10,2),
cena_koncowa_zl decimal(10,2),
foreign key(id_klienta) references clients(id) on delete cascade,
foreign key(id_samochodu) references car(id) on delete cascade
);

insert into wyniki_ubezpieczenia(id_klienta,id_samochodu,cena_bazowa_zl,cena_koncowa_zl)
select 
cl.id,
ca.id,
case 
when ca.rok>=2000 and ca.rok<=2015 then 2500
when ca.rok between 1980 and 1990 then 2200
when ca.rok between 1940 and 1979 then 1300
else 3000 end,
round((
case 
when ca.rok>=2000 and ca.rok<=2015 then 2500
when ca.rok between 1980 and 1990 then 2200
when ca.rok between 1940 and 1979 then 1300
else 3000 end)
*(1-if(cl.country in('Polska','Chiny','Poland','China'),0.3,0)+if(cl.email like '%apple%',0.4,0))
*(1-(0.05*((select count(*) from car where client_id=cl.id)-1)))
,2)
from car ca
join clients cl on ca.client_id=cl.id;
