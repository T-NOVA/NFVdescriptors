#!/usr/bin/env python
import json
import requests

#list of descriptors:
descriptors = [
	{"type": "proxy", "vnfd": "vnfds/vproxy.json", "nsd": "nsds/vproxy.json"},
	{"type": "vsbc", "vnfd": "vnfds/vsbc.json", "nsd": "nsds/vsbc.json"},
	{"type": "vhg", "vnfd": "vnfds/vhg.json", "nsd": "nsds/vhg.json"},
	{"type": "vtc", "vnfd": "vnfds/vtc.json", "nsd": "nsds/vtc.json"}
]

def auth(user):
	url = 'http://10.10.1.90/auth/'
	payload = {"username": user,"password":"123456"}
	headers = {'content-type': 'application/json'}
	response = requests.post(url, data=json.dumps(payload), headers=headers)
	token = response.json()['token']
	return token


for descriptor in descriptors:

	token = auth("fp1")
	headers = {'content-type': 'application/json', 'Authorization': 'JWT ' + token}
	url = 'http://10.10.1.90/vnfs/'

	#upload VNFD to Marketplace
	response = requests.post(url, data=open(descriptor['vnfd'], 'rb'), headers=headers)
	vnfd = response.json()

	print "New VNFD: %d" % vnfd['id']

	#replace id in NSD
	file = open(descriptor['nsd'])
	contents = file.read()
	replaced_contents = contents.replace('<updated_id>', str(vnfd['id']))

	token = auth("sp1")
	headers = {'content-type': 'application/json', 'Authorization': 'JWT ' + token}

	#upload NSD to Marketplace
	url = 'http://10.10.1.90/service-catalog/service/catalog/'
	response = requests.post(url, data=replaced_contents, headers=headers)
	nsd = response.json()

	print "New NSD: %s" % nsd['nsd']['id']

print "Done."


