import os
import sys
import json
import requests
from pathlib import Path

if __name__=="__main__":
  arg = sys.argv[-1]
  input_dict = json.loads(arg)
  uri = input_dict["uri"]
  filename = uri.split("/")[-1]
  
  curr = Path(os.getcwd())
  par = Path(curr.parent).parent
  data_dir = os.path.join(par, "data")
  
  fpath = os.path.join(data_dir, filename)
  with open(fpath, "wb") as f:
      r = requests.get(url)
      f.write(r.content)
      
  print(fpath)
