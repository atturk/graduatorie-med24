import os
import tabula as tb
import pandas as pd
from tabula.io import read_pdf
import PyPDF2

#list the files in the folder
files = os.listdir('path/to/folder')

#keep only the pdf files
files = [file for file in files if file.endswith('.pdf')]


#function to get number of pages for file
def get_pdf_page_count(file):
    with open(file, 'rb') as file:
        pdf = PyPDF2.PdfReader(file)
        return len(pdf.pages)
    
def df_ateneo(file):
    tables = tb.io.read_pdf(file, pages='all', lattice=False, multiple_tables=False, stream=True, guess=True)
    df = pd.concat(tables, ignore_index=True)
    df['ateneo'] = os.path.splitext(file)[0]
    return df

#create empty dataframe
df = pd.DataFrame()
#loop through files
for file in files:
    #progress over total
    print(f'Correntemente tabulando: {file} ({files.index(file)+1}/{len(files)})')
    #get dataframe for file
    df_file = df_ateneo(file)
    #append to main dataframe
    df = pd.concat([df, df_file], ignore_index=True)

#save to csv
df.to_csv('output.csv', index=False)