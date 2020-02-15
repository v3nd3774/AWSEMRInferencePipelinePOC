import os
import sys
import json
import requests
from pathlib import Path

if __name__=="__main__":
  arg = "".join(sys.stdin.readlines())
  input_dict = json.loads(arg)
  uri = input_dict["uri"]
  filename = uri.split("/")[-1]

  curr = os.getcwd()
  data_dir = os.path.join(curr, "data")

  fpath = os.path.join(data_dir, filename)
  with open(fpath, "wb") as f:
      r = requests.get(uri)
      f.write(r.content)

  print(json.dumps({"fpath": fpath}))
