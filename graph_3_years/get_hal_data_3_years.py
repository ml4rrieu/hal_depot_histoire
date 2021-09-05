import requests, json, pandas as pd

def reqHal(year, month):
	url= f"https://api.archives-ouvertes.fr/search/?rows=0&fq=submittedDateY_i:{year}&fq=submittedDateM_i:{month}&facet=true&facet.field=submitType_s"
	
	found = False
	while not found : 
		req = requests.get(url)
		try : 
			req = req.json()
			found = True
		except : 
			pass

	return {
	"notice": req["facet_counts"]["facet_fields"]["submitType_s"][1] + req["facet_counts"]["facet_fields"]["submitType_s"][5],
	"file" : req["facet_counts"]["facet_fields"]["submitType_s"][3]
	}

data = {}

##changer ici l'intervalle des années
for year in range (2018, 2021) : 
	for month in range(1, 13) : 
		result = reqHal(str(year), str(month))
		data[ f"{year}-{month}" ] = [result["notice"], result["file"]]
		print(f"{year}-{month}\t{result['notice']}\t{result['file']}")


df = pd.DataFrame.from_dict(data, orient='index')
df.index.name = "year-month"

## changer le nom du fichier de sortie
df.to_csv("hal_depot_2018_2020.csv", header=[ "notice", "file"])