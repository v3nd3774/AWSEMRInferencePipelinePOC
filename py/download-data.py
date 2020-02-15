# write code here to accept JSON input of "uri='uri to download'" and prints out the full path to the downloaded file.

# the file should be placed in the `<root>/data/<file here with OG filename>`
# where <root> is the root of this repo

impot os
import sys
import json
import requests
from pathlib import Path
path = Path("/here/your/path/file.txt")
print(path.parent)

if __name__=="__main__":
  arg = sys.argv[-1]
  input_dict = json.loads(arg)
  uri = input_dict["uri"]
  filename = uri.split("/")[-1]
  curr = Path(os.getcwd())
  par = curr.parent
  data_dir = os.path.join(par, "data")
  fpath = os.path.join(data_dir, filename)
  with open(fpath, "wb") as f:
      r = requests.get(url)
      f.write(r.content)
  print(fpath)
