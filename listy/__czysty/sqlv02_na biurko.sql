--*************************************************************************************************************************************************
-- Listy na dzien :
--*************************************************************************************************************************************************

select *from ZAWIADOMIENIA_listy;
update ZAWIADOMIENIA_listy set "data" =  regexp_replace(data, E'\n', '');
alter table ZAWIADOMIENIA_listy add ogc_fid serial;
drop table if exists pwpg_ZAWIADOMIENIA_listy;
create table pwpg_ZAWIADOMIENIA_listy as 
select ogc_fid ,regexp_split_to_table(pwpg, E',') as pwpg from ZAWIADOMIENIA_listy;
select data, count (data) from ZAWIADOMIENIA_listy group by data order by data;

26.08.2024	24
27.08.2024	19
28.08.2024	11
29.08.2024	6
30.08.2024	8

--26.08.2024	24
--20240826
drop table if exists lv2_nazw_lp_20240826_A;
create table lv2_nazw_lp_20240826_A AS select distinct A.data,(SELECT string_agg (B.ddd,', ') from ZAWIADOMIENIA_listy B where b.data like '26.08.2024' and A.wl=B.wl and A.rodzice = B.rodzice and substring(B.s from 3 for 1) like 'A') AS dzialki, ''::varchar::varchar  AS PESEL, ''::varchar AS Numer_Dowodu, wl,rodzice,(select string_agg(pwpg, ',' order by pwpg::int) from pwpg_ZAWIADOMIENIA_listy where ogc_fid in (SELECT ogc_fid from ZAWIADOMIENIA_listy C where C.data like '26.08.2024' and A.wl=C.wl and A.rodzice = C.rodzice and substring(C.s from 3 for 1) like 'A')) AS pwpg from ZAWIADOMIENIA_listy A where A.data like '26.08.2024' and substring(A.s from 3 for 1) like 'A' order by wl;

alter table lv2_nazw_lp_20240826_A add id serial;
--alter table lv2_nazw_lp_20240826_A drop id;

drop table if exists lv2_nazw_lp_20240826_A_01;
create table lv2_nazw_lp_20240826_A_01 as 
select distinct A."data", LTRIM(UNNEST(STRING_TO_ARRAY(A.dzialki, ','))) as dziakla, A.pesel, A.numer_dowodu, A.wl, A.rodzice,A.pwpg , id   from lv2_nazw_lp_20240826_A A order by id, LTRIM(UNNEST(STRING_TO_ARRAY(A.dzialki, ',')));

drop table if exists lv2_nazw_lp_20240826_A_02;
create table lv2_nazw_lp_20240826_A_02 as 
select A."data", string_agg(A.dziakla, ', ') as dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice,A.pwpg , id   from lv2_nazw_lp_20240826_A_01 A
group by A."data", A.pesel, A.numer_dowodu, A.wl, A.rodzice,A.pwpg , id;

drop table if exists lv2_nazw_lp_20240826_A_03;
create table lv2_nazw_lp_20240826_A_03 as 
select distinct A."data", dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice,LTRIM(UNNEST(STRING_TO_ARRAY(A.pwpg, ','))) as pwpg , id   from lv2_nazw_lp_20240826_A_02 A order by id, LTRIM(UNNEST(STRING_TO_ARRAY(A.pwpg, ',')));

drop table if exists lv2_nazw_lp_20240826_A_out;
create table lv2_nazw_lp_20240826_A_out as 
select A."data", dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice,string_agg(A.pwpg, ', ' order by pwpg::int) as pwpg , id   from lv2_nazw_lp_20240826_A_03 A
group by A."data", dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice, id order by id, pwpg;

select *from lv2_nazw_lp_20240826_A_out

--27.08.2024	19
--20240827
drop table if exists lv2_nazw_lp_20240827_A;
create table lv2_nazw_lp_20240827_A AS select distinct A.data,(SELECT string_agg (B.ddd,', ') from ZAWIADOMIENIA_listy B where b.data like '27.08.2024' and A.wl=B.wl and A.rodzice = B.rodzice and substring(B.s from 3 for 1) like 'A') AS dzialki, ''::varchar::varchar  AS PESEL, ''::varchar AS Numer_Dowodu, wl,rodzice,(select string_agg(pwpg, ',' order by pwpg::int) from pwpg_ZAWIADOMIENIA_listy where ogc_fid in (SELECT ogc_fid from ZAWIADOMIENIA_listy C where C.data like '27.08.2024' and A.wl=C.wl and A.rodzice = C.rodzice and substring(C.s from 3 for 1) like 'A')) AS pwpg from ZAWIADOMIENIA_listy A where A.data like '27.08.2024' and substring(A.s from 3 for 1) like 'A' order by wl;

alter table lv2_nazw_lp_20240827_A add id serial;
--alter table lv2_nazw_lp_20240827_A drop id;

drop table if exists lv2_nazw_lp_20240827_A_01;
create table lv2_nazw_lp_20240827_A_01 as 
select distinct A."data", LTRIM(UNNEST(STRING_TO_ARRAY(A.dzialki, ','))) as dziakla, A.pesel, A.numer_dowodu, A.wl, A.rodzice,A.pwpg , id   from lv2_nazw_lp_20240827_A A order by id, LTRIM(UNNEST(STRING_TO_ARRAY(A.dzialki, ',')));

drop table if exists lv2_nazw_lp_20240827_A_02;
create table lv2_nazw_lp_20240827_A_02 as 
select A."data", string_agg(A.dziakla, ', ') as dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice,A.pwpg , id   from lv2_nazw_lp_20240827_A_01 A
group by A."data", A.pesel, A.numer_dowodu, A.wl, A.rodzice,A.pwpg , id;

drop table if exists lv2_nazw_lp_20240827_A_03;
create table lv2_nazw_lp_20240827_A_03 as 
select distinct A."data", dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice,LTRIM(UNNEST(STRING_TO_ARRAY(A.pwpg, ','))) as pwpg , id   from lv2_nazw_lp_20240827_A_02 A order by id, LTRIM(UNNEST(STRING_TO_ARRAY(A.pwpg, ',')));

drop table if exists lv2_nazw_lp_20240827_A_out;
create table lv2_nazw_lp_20240827_A_out as 
select A."data", dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice,string_agg(A.pwpg, ', ' order by pwpg::int) as pwpg , id   from lv2_nazw_lp_20240827_A_03 A
group by A."data", dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice, id order by id, pwpg;

select *from lv2_nazw_lp_20240827_A_out

--28.08.2024	11
--20240828
--28.08.2024	11
--20240828
drop table if exists lv2_nazw_lp_20240828_A;
create table lv2_nazw_lp_20240828_A AS select distinct A.data,(SELECT string_agg (B.ddd,', ') from ZAWIADOMIENIA_listy B where b.data like '28.08.2024' and A.wl=B.wl and A.rodzice = B.rodzice and substring(B.s from 3 for 1) like 'A') AS dzialki, ''::varchar::varchar  AS PESEL, ''::varchar AS Numer_Dowodu, wl,rodzice,(select string_agg(pwpg, ',' order by pwpg::int) from pwpg_ZAWIADOMIENIA_listy where ogc_fid in (SELECT ogc_fid from ZAWIADOMIENIA_listy C where C.data like '28.08.2024' and A.wl=C.wl and A.rodzice = C.rodzice and substring(C.s from 3 for 1) like 'A')) AS pwpg from ZAWIADOMIENIA_listy A where A.data like '28.08.2024' and substring(A.s from 3 for 1) like 'A' order by wl;

alter table lv2_nazw_lp_20240828_A add id serial;
--alter table lv2_nazw_lp_20240828_A drop id;

drop table if exists lv2_nazw_lp_20240828_A_01;
create table lv2_nazw_lp_20240828_A_01 as 
select distinct A."data", LTRIM(UNNEST(STRING_TO_ARRAY(A.dzialki, ','))) as dziakla, A.pesel, A.numer_dowodu, A.wl, A.rodzice,A.pwpg , id   from lv2_nazw_lp_20240828_A A order by id, LTRIM(UNNEST(STRING_TO_ARRAY(A.dzialki, ',')));

drop table if exists lv2_nazw_lp_20240828_A_02;
create table lv2_nazw_lp_20240828_A_02 as 
select A."data", string_agg(A.dziakla, ', ') as dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice,A.pwpg , id   from lv2_nazw_lp_20240828_A_01 A
group by A."data", A.pesel, A.numer_dowodu, A.wl, A.rodzice,A.pwpg , id;

drop table if exists lv2_nazw_lp_20240828_A_03;
create table lv2_nazw_lp_20240828_A_03 as 
select distinct A."data", dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice,LTRIM(UNNEST(STRING_TO_ARRAY(A.pwpg, ','))) as pwpg , id   from lv2_nazw_lp_20240828_A_02 A order by id, LTRIM(UNNEST(STRING_TO_ARRAY(A.pwpg, ',')));

drop table if exists lv2_nazw_lp_20240828_A_out;
create table lv2_nazw_lp_20240828_A_out as 
select A."data", dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice,string_agg(A.pwpg, ', ' order by pwpg::int) as pwpg , id   from lv2_nazw_lp_20240828_A_03 A
group by A."data", dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice, id order by id, pwpg;

select *from lv2_nazw_lp_20240828_A_out


--29.08.2024	6
--20240829
drop table if exists lv2_nazw_lp_20240829_A;
create table lv2_nazw_lp_20240829_A AS select distinct A.data,(SELECT string_agg (B.ddd,', ') from ZAWIADOMIENIA_listy B where b.data like '29.08.2024' and A.wl=B.wl and A.rodzice = B.rodzice and substring(B.s from 3 for 1) like 'A') AS dzialki, ''::varchar::varchar  AS PESEL, ''::varchar AS Numer_Dowodu, wl,rodzice,(select string_agg(pwpg, ',' order by pwpg::int) from pwpg_ZAWIADOMIENIA_listy where ogc_fid in (SELECT ogc_fid from ZAWIADOMIENIA_listy C where C.data like '29.08.2024' and A.wl=C.wl and A.rodzice = C.rodzice and substring(C.s from 3 for 1) like 'A')) AS pwpg from ZAWIADOMIENIA_listy A where A.data like '29.08.2024' and substring(A.s from 3 for 1) like 'A' order by wl;

alter table lv2_nazw_lp_20240829_A add id serial;
--alter table lv2_nazw_lp_20240829_A drop id;

drop table if exists lv2_nazw_lp_20240829_A_01;
create table lv2_nazw_lp_20240829_A_01 as 
select distinct A."data", LTRIM(UNNEST(STRING_TO_ARRAY(A.dzialki, ','))) as dziakla, A.pesel, A.numer_dowodu, A.wl, A.rodzice,A.pwpg , id   from lv2_nazw_lp_20240829_A A order by id, LTRIM(UNNEST(STRING_TO_ARRAY(A.dzialki, ',')));

drop table if exists lv2_nazw_lp_20240829_A_02;
create table lv2_nazw_lp_20240829_A_02 as 
select A."data", string_agg(A.dziakla, ', ') as dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice,A.pwpg , id   from lv2_nazw_lp_20240829_A_01 A
group by A."data", A.pesel, A.numer_dowodu, A.wl, A.rodzice,A.pwpg , id;

drop table if exists lv2_nazw_lp_20240829_A_03;
create table lv2_nazw_lp_20240829_A_03 as 
select distinct A."data", dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice,LTRIM(UNNEST(STRING_TO_ARRAY(A.pwpg, ','))) as pwpg , id   from lv2_nazw_lp_20240829_A_02 A order by id, LTRIM(UNNEST(STRING_TO_ARRAY(A.pwpg, ',')));

drop table if exists lv2_nazw_lp_20240829_A_out;
create table lv2_nazw_lp_20240829_A_out as 
select A."data", dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice,string_agg(A.pwpg, ', ' order by pwpg::int) as pwpg , id   from lv2_nazw_lp_20240829_A_03 A
group by A."data", dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice, id order by id, pwpg;

select *from lv2_nazw_lp_20240829_A_out

--30.08.2024	8
--20240830

drop table if exists lv2_nazw_lp_20240830_A;
create table lv2_nazw_lp_20240830_A AS select distinct A.data,(SELECT string_agg (B.ddd,', ') from ZAWIADOMIENIA_listy B where b.data like '30.08.2024' and A.wl=B.wl and A.rodzice = B.rodzice and substring(B.s from 3 for 1) like 'A') AS dzialki, ''::varchar::varchar  AS PESEL, ''::varchar AS Numer_Dowodu, wl,rodzice,(select string_agg(pwpg, ',' order by pwpg::int) from pwpg_ZAWIADOMIENIA_listy where ogc_fid in (SELECT ogc_fid from ZAWIADOMIENIA_listy C where C.data like '30.08.2024' and A.wl=C.wl and A.rodzice = C.rodzice and substring(C.s from 3 for 1) like 'A')) AS pwpg from ZAWIADOMIENIA_listy A where A.data like '30.08.2024' and substring(A.s from 3 for 1) like 'A' order by wl;

alter table lv2_nazw_lp_20240830_A add id serial;
--alter table lv2_nazw_lp_20240830_A drop id;

drop table if exists lv2_nazw_lp_20240830_A_01;
create table lv2_nazw_lp_20240830_A_01 as 
select distinct A."data", LTRIM(UNNEST(STRING_TO_ARRAY(A.dzialki, ','))) as dziakla, A.pesel, A.numer_dowodu, A.wl, A.rodzice,A.pwpg , id   from lv2_nazw_lp_20240830_A A order by id, LTRIM(UNNEST(STRING_TO_ARRAY(A.dzialki, ',')));

drop table if exists lv2_nazw_lp_20240830_A_02;
create table lv2_nazw_lp_20240830_A_02 as 
select A."data", string_agg(A.dziakla, ', ') as dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice,A.pwpg , id   from lv2_nazw_lp_20240830_A_01 A
group by A."data", A.pesel, A.numer_dowodu, A.wl, A.rodzice,A.pwpg , id;

drop table if exists lv2_nazw_lp_20240830_A_03;
create table lv2_nazw_lp_20240830_A_03 as 
select distinct A."data", dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice,LTRIM(UNNEST(STRING_TO_ARRAY(A.pwpg, ','))) as pwpg , id   from lv2_nazw_lp_20240830_A_02 A order by id, LTRIM(UNNEST(STRING_TO_ARRAY(A.pwpg, ',')));

drop table if exists lv2_nazw_lp_20240830_A_out;
create table lv2_nazw_lp_20240830_A_out as 
select A."data", dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice,string_agg(A.pwpg, ', ' order by pwpg::int) as pwpg , id   from lv2_nazw_lp_20240830_A_03 A
group by A."data", dzialki, A.pesel, A.numer_dowodu, A.wl, A.rodzice, id order by id, pwpg;

select *from lv2_nazw_lp_20240830_A_out


--**********************************************************************************************************************************************************

select "data", dzialki, pesel, numer_dowodu, wl, rodzice, pwpg from lv2_nazw_lp_20240826_A_out order by id;
select "data", dzialki, pesel, numer_dowodu, wl, rodzice, pwpg from lv2_nazw_lp_20240827_A_out order by id;
select "data", dzialki, pesel, numer_dowodu, wl, rodzice, pwpg from lv2_nazw_lp_20240828_A_out order by id;
select "data", dzialki, pesel, numer_dowodu, wl, rodzice, pwpg from lv2_nazw_lp_20240829_A_out order by id;
select "data", dzialki, pesel, numer_dowodu, wl, rodzice, pwpg from lv2_nazw_lp_20240830_A_out order by id;
