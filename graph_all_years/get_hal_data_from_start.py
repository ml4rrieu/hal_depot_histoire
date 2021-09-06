import requests, json, pandas as pd

def reqHal(year, month):
        url=f"https://api.archives-ouvertes.fr/search/?&rows=0\
        &fq=submittedDate_tdate:[1500-01-01T00:00:00Z%20TO%20{year}-{month}-01T00:00:00Z]&facet=true&facet.field=submitType_s"
        
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
for year in range(2001, 2022) : 
        for month in range(1,13) : 
                result = reqHal(str(year), str(month))
                data[ f"{year}-{month}" ] = [result["notice"], result["file"]]
                print(f"{year}-{month}\t{result['notice']}\t{result['file']}")


df = pd.DataFrame.from_dict(data, orient='index')
df.index.name = "year-month"
df.to_csv("depot_all_years.csv", header=[ "notice", "file"])
