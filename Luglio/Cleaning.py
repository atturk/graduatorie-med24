import pandas as pd

file = 'output.csv'
df = pd.read_csv(file)

#delete all the rows that contain 'Codice' in the first column, the fist column is a string
df = df[~df.iloc[:,0].str.contains('Codice', na=False)]


#save to csv
df.to_csv('output_clean.csv', index=False)
