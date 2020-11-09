import requests
res = requests.get('https://covid19-api.org/api/status')
res.json()
import pandas as pd
df = pd.DataFrame(res.json())
df['country']