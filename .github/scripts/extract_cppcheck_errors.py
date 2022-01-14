import xml.etree.ElementTree as ET
import os

tree = ET.parse("./build/cppcheck.xml")
root = tree.getroot()
errors = root.find('errors').findall('error')
if len(errors) == 0:
  print ("Cppcheck did not find any errors.")
  exit(0)
else:
  for error in errors:
    msg = error.attrib["verbose"]
    location = error.find('location')

    if location is not None:
      location = location.attrib
      file = location["file"]
      line = location["line"]
      column = location["column"]
      print(msg+" found in file "+os.path.basename(file)+" line:"+line+" column:"+column+"\n")
    else:
      print(msg)
  exit(1)
