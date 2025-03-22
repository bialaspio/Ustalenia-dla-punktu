# -*- coding: utf8 -*-
#!/usr/bin/python2.7
#
# Small script to show PostgreSQL and Pyscopg together
#

import sys,os,glob,psycopg2,csv,time, datetime, errno, json, collections
from datetime import datetime
from collections import OrderedDict
import pandas as pd
	
#---------------------------------------------------------------------------------------------
def exec_query ( str_query ):
	try:
		cur.execute(str_query) 
		print ('Wykonane zapytanie '+str_query)
	except Exception as e:
		print ('	Nie udalo sie wykonac zapytania:'+str_query)
		err_log.write('Nie udalo sie wykonac zapytania (select):'+str_query+'\n')
		print (e)
	return cur
#---------------------------------------------------------------------------------------------
	
def exec_query_commit( str_query ):
	try:
		cur.execute(str_query) 
		conn_PG.commit()
		print ('Wykonane zapytanie '+str_query)
	except Exception as e:
		print ('Nie udalo sie wykonac zapytania:'+str_query)
		print (e)
		err_log.write('Nie udalo sie wykonac zapytania (commit):'+str_query+'\n')
		os.system('pause')
	return cur 	
#------------------------------------------------------------------------------------------

def get_data_from_protokoly():
	dirs_name = glob.glob ('xls_protokoly_index_AP')
	print (str (dirs_name))
	#Stworzenie tablicy na dane z katalogu ZAWIADOMIENIA 
	drop_query = 'DROP TABLE IF EXISTS PROTOKOLY_INDEX'
	exec_query_commit(drop_query)
	create_query = 'create table PROTOKOLY_INDEX (id int, NR_dzialki varchar, podmioty varchar, Nr_KW varchar, DataUstalenia varchar, Nr_szkicu varchar, Adnotacje varchar)'
	exec_query_commit(create_query)
			
	for dir_name in dirs_name:
		files_xls_names = glob.glob(dir_name+'\\*.xls')
		print (files_xls_names)
		for file_xls_name in files_xls_names:
			print (file_xls_name)
			table_name = os.path.basename(file_xls_name)
			table_name = table_name.split('.')[0]

			xls_zaw = pd.read_excel(file_xls_name, sheet_name='Arkusz1')
			for index, row in xls_zaw.iterrows():
				if index >= 6:
					ID = str(row[0])
					NR_dzialki = str(row[1])
					podmioty = str(row[2])
					Nr_KW = str(row[3])
					DataUstalenia = str(row[5])
					Nr_szkicu = str(row[7])
					Adnotacje = str(row[10])
					
					print (NR_dzialki)
					print (podmioty)
					print (Nr_KW)
					print (DataUstalenia)
					print (Nr_szkicu)
					print (Adnotacje)
					
					insert_query = "INSERT INTO public.PROTOKOLY_INDEX(ID,nr_dzialki, podmioty, nr_kw, dataustalenia, nr_szkicu, adnotacje) VALUES ('"+ID+"','"+NR_dzialki+"','"+podmioty+"','"+Nr_KW+"','"+DataUstalenia+"','"+Nr_szkicu+"','"+Adnotacje+"');"
					print (insert_query)
					exec_query_commit(insert_query)

#----------------------------------------------------------------------------------------------------------------------------------		


#--------------------------------------------------------------------------------------------------------------------------------------------
#-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#--------------------------------------------------------------------------------------------------------------------------------------------
if not os.path.exists('.\\log'):
	try:
		os.makedirs('.\\log')
	except OSError as exc: # Guard against race condition
		if exc.errno != errno.EEXIST:
			raise

naz_lik_log = time.strftime('%Y%m%d-%H_%M_%S')
naz_log = open('.\\log\\copy'+naz_lik_log+'.log', 'w')
err_log = open('.\\log\\ERR'+naz_lik_log+'.log', 'w')


#polacznie z baza POSTGRES 
teraz = time.asctime( time.localtime(time.time()))
try:
	conn_PG = psycopg2.connect("dbname='__dbname__' user='__user__' host='__host__' password='__passwd__' port='5432'")
	naz_log.write(teraz + ' [INF] Polaczono z baza danych\n')
except:
	print ('I am unable to connect to the database') 
	err_log.write(teraz +' - [ERR] Nie udalo sie naiazac polacznia z baz\n')

cur = conn_PG.cursor()

#get_data_from_ZAWIADOMIENIA()
#get_dresy()
#get_dresy_stykowe()
#update_adresy()
#create_xlsx () 
get_data_from_protokoly()
print ('-- koniec --')
os.system("pause")