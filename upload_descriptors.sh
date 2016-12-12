#!/usr/bin/env python
import json
import requests

url = 'http://10.10.1.90/auth/'
payload = {"username":"admin","password":"123456"}
headers = {'content-type': 'application/json'}
response = requests.post(url, data=json.dumps(payload), headers=headers)
token = response.json()['token']

#list of descriptors:
descriptors = [
	{"type": "proxy", "vnfd": "vnfds/vproxy.json", "nsd": "nsds/vproxy.json"}
]

print descriptors
url = 'http://10.10.1.90/vnfs/'
headers = {'content-type': 'application/json', 'Authorization': 'JWT ' + token}

for descriptor in descriptors:

	#upload VNFD to Marketplace
	response = requests.post(url, data=open(descriptor['vnfd'], 'rb'), headers=headers)
	vnfd = response.json()

	#replace id in NSD
	file = open(descriptor['nsd'])
	contents = file.read()
	replaced_contents = contents.replace('<updated_id>', str(vnfd['id']))

	#upload NSD to Marketplace
	url = 'http://10.10.1.90/service-catalog/service/catalog/'
	response = requests.post(url, data=replaced_contents, headers=headers)

print "Done."


