from pprint import pprint
import boto.ec2
import uuid
import time
import json
from prettytable import PrettyTable
import sys, getopt, os
import argparse
import csv



def main(argv):
   File_Name =  os.path.basename(sys.argv[0])


##Grab the CLI agruments
##Loads JSON first and CLI switches override JSON
   parser = argparse.ArgumentParser()
   args = parser.parse_args()

   ##connect to AWS EC2
   global conn
   conn = boto.ec2.connect_to_region("us-east-1")

   with open('allinstances.csv', 'wb') as csvfile:
    csvwriter = csv.writer(csvfile, delimiter=' ',
                            quotechar='|', quoting=csv.QUOTE_MINIMAL)
    csvwriter.writerow(['ImageID' ,'Name', 'Private IP', 'Key Name', 'VPC ID', 'Tags'])
  

   reservations = conn.get_all_instances(instance_ids=[InstanceID])
   for Instance in reservations[0].instances
    csvwriter.writerow([Instance.image_id, Instance.tags["Name"],  Instance.private_ip_address, Instance.key_name, Instance.vpc_id, Instance.tags])



if __name__ == "__main__":
 main(sys.argv[1:])
