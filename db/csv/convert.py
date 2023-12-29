import pandas as pd
from pandas.tseries.offsets import DateOffset
import csv

# Ladda in CSV-filerna
df1 = pd.read_csv('relativ-luftfuktighet.csv')
df2 = pd.read_csv('lagsta-molnbas.csv')

# Konvertera 'Datum Tid (UTC)' till datetime-objekt och lägg till en timme
df1['Datum Tid (UTC)'] = pd.to_datetime(df1['Datum Tid (UTC)']) + DateOffset(hours=1)
df2['Datum Tid (UTC)'] = pd.to_datetime(df2['Datum Tid (UTC)']) + DateOffset(hours=1)

# Sammanfoga filerna baserat på 'Datum Tid (UTC)' kolumnen
resultat = pd.merge(df1, df2, on='Datum Tid (UTC)', how='outer')

# Konvertera numeriska kolumner till int där det är möjligt, behåll NaN-värden som de är
for column in resultat.columns:
    if resultat[column].dtype == float:
        resultat[column] = resultat[column].fillna(0).astype(int)

# Spara resultatet till en ny CSV-fil, omkapsla alla fält med citationstecken
resultat.to_csv('sammanfogad_data.csv', index=False, quotechar='"', quoting=csv.QUOTE_ALL)

print("Filer sammanfogade och sparade som sammanfogad_data.csv")
