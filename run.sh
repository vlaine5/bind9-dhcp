#!/bin/bash
vagrant destroy -f
vagrant up --provider=vmware_esxi --no-provision
vagrant provision bind9-pipeline
