import sys,os,glob,psycopg2,shutil,time, datetime, string, csv
import pandas as pd
from pyexcel_xls import get_data
from pyexcel_xls import save_data

# Odczytanie pliku

#---------------------------------------------------------------------------------------------
def exec_query ( str_query ):
	try:
		cur.execute(str_query) 
		print ('Wykonane zapytanie '+str_query)
	except :
		print ('	Nie udalo sie wykonac zapytania:'+str_query)
		err_log.write('Nie udalo sie wykonac zapytania (select):'+str_query+'\n')
		os.system('pause')
	return cur


#---------------------------------------------------------------------------------------------
	
def exec_query_commit( str_query ):
	#try:
		cur.execute(str_query) 
		conn_PG.commit()
		print ('Wykonane zapytanie '+str_query)
	#except:
	#	print ('	Nie udalo sie wykonac zapytania:'+str_query)
	#	err_log.write('Nie udalo sie wykonac zapytania (commit):'+str_query+'\n')
	#	os.system('pause')
		return cur 	

#---------------------------------------------------------------------------------------------	
def get_dresy():
	dirs_name = glob.glob ('adresy')
	#Stworzenie tablicy na dane z katalogu ADRESY_G_OK 
	drop_query = 'DROP TABLE IF EXISTS ADRESY_G_OK'
	exec_query_commit(drop_query)
	create_query = 'create table ADRESY_G_OK (  G character varying(1500),DZ character varying(1500),	WL character varying(1500),	RODZICE character varying(1500),ADRES_CZ2_POP character varying(1500), ADRES_CZ1_POP character varying(1500), plik_csv character varying(1500))'
	exec_query_commit(create_query)
	#Stworzenie tablicy na dane z katalogu ADRESY_G_BIP
	drop_query = 'DROP TABLE IF EXISTS ADRESY_G_BIP'
	exec_query_commit(drop_query)
	#create_query = 'create table ADRESY_G_BIP ( DZ character varying(1500),	WL character varying(1500),	RODZICE character varying(1500),ADRES_CZ2_POP character varying(1500), ADRES_CZ1_POP character varying(1500), plik_csv character varying(1500))'
	create_query = 'create table ADRESY_G_BIP ( G character varying(1500),DZ character varying(1500),	WL character varying(1500),	RODZICE character varying(1500), plik_csv character varying(1500))'
	exec_query_commit(create_query)
	print (dirs_name) 		
#	os.system ("pause")
	for dir_name in dirs_name:
		
		files_xls_names = glob.glob(dir_name+'\\*.xls*')
		print (files_xls_names)
#		os.system ("pause")
		for file_xls_name in files_xls_names:
			print(file_xls_name)
			table_name = os.path.basename(file_xls_name)
			table_name = table_name.split('.')[0]
			
			# Odczytaj dane z arkusza 'PRAWIDLOWE_ADRESY' w pliku Excela za pomocą pandas
			df_ok = pd.read_excel(file_xls_name, sheet_name='PRAWIDLOWE_ADRESY')
			
			for index, row in df_ok.iterrows():
				print (index)
				if index >= 0:
					print (row)
					G = str(row[0])
					DZ = str(row[1])
					WL = str(row[4])
					RODZICE = str(row[5])
					ADRES_CZ2_POP = str(row[8])
					ADRES_CZ1_POP = str(row[9])
					
					#zaladowania danych do bazy   
					insert_query = "insert into ADRESY_G_OK VALUES ('"+G+"','"+DZ+"','"+WL+"','"+RODZICE+"','"+ADRES_CZ2_POP+"','"+ADRES_CZ1_POP+"','"+table_name+"');"
					exec_query_commit(insert_query)
#					os.system ("pause")

			df_bip = pd.read_excel(file_xls_name, sheet_name='BiP_NIEPRAWIDLOWE_ADRESY')
			
			for index, row in df_bip.iterrows():
				if index >= 0:
					G = str(row[0])
					DZ = str(row[1])
					WL = str(row[4])
					RODZICE = str(row[5])

					#zaladowania danych do bazy   
					insert_query = "insert into ADRESY_G_BIP VALUES ('"+G+"','"+DZ+"','"+WL+"','"+RODZICE+"','"+table_name+"');"
					exec_query_commit(insert_query)	


#------------------------------------------------------------------------------------------
def get_dresy_stykowe():
	dirs_name = glob.glob ('adr_stykowe')
	#Stworzenie tablicy na dane z katalogu ADRESY_G_OK_STYK 
	drop_query = 'DROP TABLE IF EXISTS ADRESY_G_OK_STYK'
	exec_query_commit(drop_query)
	create_query = 'create table ADRESY_G_OK_STYK ( G character varying(50),DZ character varying(1500),	WL character varying(1500),	RODZICE character varying(1500),ADRES_CZ2_POP character varying(1500), ADRES_CZ1_POP character varying(1500), plik_csv character varying(1500))'
	exec_query_commit(create_query)
	
	#Stworzenie tablicy na dane z katalogu ADRESY_G_BIP_STYK
	drop_query = 'DROP TABLE IF EXISTS ADRESY_G_BIP_STYK'
	exec_query_commit(drop_query)
	#create_query = 'create table ADRESY_G_BIP_STYK ( DZ character varying(1500),	WL character varying(1500),	RODZICE character varying(1500),ADRES_CZ2_POP character varying(1500), ADRES_CZ1_POP character varying(1500), plik_csv character varying(1500))'
	create_query = 'create table ADRESY_G_BIP_STYK ( G character varying(50),DZ character varying(1500),	WL character varying(1500),	RODZICE character varying(1500), plik_csv character varying(1500))'
	exec_query_commit(create_query)
			
	for dir_name in dirs_name:
		files_xls_names = glob.glob(dir_name+'\\*.xls*')
		print (files_xls_names)
		for file_xls_name in files_xls_names:
			print(file_xls_name)
			table_name = os.path.basename(file_xls_name)
			table_name = table_name.split('.')[0]
			
			# Odczytaj dane z arkusza 'PRAWIDLOWE_ADRESY' w pliku Excela za pomocą pandas
			df_ok = pd.read_excel(file_xls_name, sheet_name='PRAWIDLOWE_ADRESY')
			
			for index, row in df_ok.iterrows():
				if index >= 0:
					G = str(row[0])
					DZ = str(row[1])
					WL = str(row[4])
					RODZICE = str(row[5])
					ADRES_CZ2_POP = str(row[8])
					ADRES_CZ1_POP = str(row[9])
					
					#zaladowania danych do bazy   
					insert_query = "insert into ADRESY_G_OK_STYK VALUES ('"+G+"','"+DZ+"','"+WL+"','"+RODZICE+"','"+ADRES_CZ2_POP+"','"+ADRES_CZ1_POP+"','"+table_name+"');"
					exec_query_commit(insert_query)

			df_bip = pd.read_excel(file_xls_name, sheet_name='BiP_NIEPRAWIDLOWE_ADRESY')
			for index, row in df_bip.iterrows():
				if index >= 0:
					G = str(row[0])
					DZ = str(row[1])
					WL = str(row[4])
					RODZICE = str(row[5])

					#zaladowania danych do bazy   
					insert_query = "insert into ADRESY_G_BIP_STYK VALUES ('"+G+"','"+DZ+"','"+WL+"','"+RODZICE+"','"+table_name+"');"
					exec_query_commit(insert_query)	

	#zrobienie kolumny odpowiadajacej adresa dla adresow stykowych zapisanych jako zlozenie nr_teryt i dzialki 
	alter_query = "alter table ADRESY_G_OK_STYK add kerg_dz character varying(150);"
	exec_query_commit(alter_query)
	update_query = "update ADRESY_G_OK_STYK kerg_dz set kerg_dz = replace (substring(plik_csv,0,14), '_0', '.0')||'.'||dz;"
	exec_query_commit(update_query)
	alter_query = "alter table ADRESY_G_BIP_STYK add kerg_dz character varying(150);"
	exec_query_commit(alter_query)
	update_query = "update ADRESY_G_BIP_STYK kerg_dz set kerg_dz = replace (substring(plik_csv,0,14), '_0', '.0')||'.'||dz;"
	exec_query_commit(update_query)
	

#--------------------------------------------------------------------------------------------------------------------------------------------
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#--------------------------------------------------------------------------------------------------------------------------------------------

naz_lik_log = time.strftime("%Y%m%d-%H_%M_%S")
if not os.path.exists('.\\__log'):
    try:
        os.makedirs('.\\__log')
    except OSError as exc: # Guard against race condition
        if exc.errno != errno.EEXIST:
            raise

logfile = open('__log\\'+naz_lik_log+'.log', 'w')
err_log = open('__log\\ERR'+naz_lik_log+'.log', 'w')

main_dir = os.getcwd()

teraz = time.asctime( time.localtime(time.time()))
try:
	conn_PG = psycopg2.connect("dbname='__dbname__' user='__user__' host='__host__' password='__passwd__' port='5432'")
	logfile.write(teraz + ' [INF] Polaczono z baza danych\n')
except:
	print ('I am unable to connect to the database')
	err_log.write(teraz +' - [ERR] Nie udalo sie naiazac polacznia z baz\n')

cur = conn_PG.cursor()
cur_2 = conn_PG.cursor()

# pobranie z xls danych adresowych dla dzialek 

#create_table_skr()
#raad_csv()
get_dresy()
get_dresy_stykowe()
#pomocnicze ()
#crate_pt_dz()
#crate_dzialki_pary()
#generuj_pliki_csv()


#insert_query = "insert into nieust_punkty_dzialki VALUES ('"+str(ogc_fid)+"','"+ dzialka + "');"
#exec_query_commit(insert_query)
		
os.system("pause") 
 