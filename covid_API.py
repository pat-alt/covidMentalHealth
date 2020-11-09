import requests
import pandas as pd

# Here we can see the latest status
res = requests.get('https://covid19-api.org/api/status')
res.json()
df = pd.DataFrame(res.json())
df['country']
df

# Here we can see the diff between the latest state and previuos one

diff = requests.get('https://covid19-api.org/api/diff')
diff.json()
diff = pd.DataFrame(diff.json())
diff