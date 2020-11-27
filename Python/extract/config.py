from pathlib import Path  # Python 3.6+ only
env_path = Path('Python/') / '.env'
from dotenv import load_dotenv
load_dotenv(dotenv_path=env_path)
import os
twitter_app_key = os.getenv('TWITTER_APP_KEY')
twitter_app_secret = os.getenv('TWITTER_APP_SECRET')
twitter_key = os.getenv('TWITTER_KEY')
twitter_secret = os.getenv('TWITTER_SECRET')
