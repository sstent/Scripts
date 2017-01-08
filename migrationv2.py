from pprint import pprint
import boto.ec2
import uuid
import time
import json
from prettytable import PrettyTable
import sys, getopt, os
import argparse



def main(argv):
   File_Name =  os.path.basename(sys.argv[0])
   TargetInstanceName = ''
   SourceInstanceID = ''
   TargetSubnet = ''
   SecurityGroups = ''
   InstanceType = ''
   KeyPair = ''
   Tags = {}


##Grab the CLI agruments
##Loads JSON first and CLI switches override JSON
   parser = argparse.ArgumentParser()
   parser.add_argument("--SourceInstance", help="Source Instance ID (REQUIRED)", dest='SourceInstanceID', required=True)
   parser.add_argument("--Name", help="New Instance/AMI Name (overrides JSON value)", dest='TargetInstanceName')
   parser.add_argument("--SecurityGroups", help="Comma Separated Security Group IDs (overrides JSON value)", dest='SecurityGroups')
   parser.add_argument("--Subnet", help="Subnet to launch instance (overrides JSON value)", dest='TargetSubnet')
   parser.add_argument("--InstanceType", help="New instance type (overrides JSON value)", dest='InstanceType')
   parser.add_argument("--KeyPair", help="Keypair to use (overrides JSON value)", dest='KeyPair')
   parser.add_argument("--Json", help="JSON file containing new instance info", dest='Json')
   args = parser.parse_args()

   if args.Json: 
    json_file=open(args.Json,'r').read()
    json_file=json_file.replace('}{', '},{')
    data_string='[%s]'%(json_file)
    data=json.loads(data_string)
    Options = data[0]
    if "TargetInstanceName" in Options: 
      TargetInstanceName = Options["TargetInstanceName"]
      Tags['Name'] = Options["TargetInstanceName"]
    if "TargetSubnet" in Options: TargetSubnet = Options["TargetSubnet"]
    if "SecurityGroups" in Options: SecurityGroups = Options["SecurityGroups"]
    if "InstanceType" in Options: InstanceType = Options["InstanceType"]
    if "KeyPair"  in Options : KeyPair = Options["KeyPair"]
    if "Tags"  in Options : Tags.update(Options["Tags"])
   if args.TargetInstanceName: 
     TargetInstanceName = args.TargetInstanceName
     Tags['Name'] = args.TargetInstanceName
   if args.SourceInstanceID: SourceInstanceID = args.SourceInstanceID
   if args.TargetSubnet: TargetSubnet = args.TargetSubnet
   if args.SecurityGroups: SecurityGroups = args.SecurityGroups.split(",")
   if args.InstanceType: InstanceType = args.InstanceType
   if args.KeyPair: KeyPair = args.KeyPair
     

   pid = str(os.getpid())
   pidfile = "/tmp/" + TargetInstanceName + ".pid"

   if os.path.isfile(pidfile):
      print "%s already exists, exiting" % pidfile
      sys.exit()
   else:
      file(pidfile, 'w').write(pid)

   ##Load The subnet data
   json_file=open('subnets.json','r').read()
   json_file=json_file.replace('}{', '},{')
   data_string='[%s]'%(json_file)
   data=json.loads(data_string)
   Subnet = data[0]

   ##If we didn't override the keypair set to to the default for the subnet
   if KeyPair == '':
     KeyPair = Subnet[TargetSubnet]['Key']


   ##connect to AWS EC2
   global conn
   conn = boto.ec2.connect_to_region("us-east-1")

   print '======================================'
   print '== Validating Security Groups'
   ValidatedSecurityGroups = ValidateSecurityGroups (SecurityGroups, Subnet[TargetSubnet]['VPC'])
   print '======================================'
   print '== Checking whether AMI exists'
   TestAMIExists (TargetInstanceName)
   SourceInstanceInfo = GetInstanceinfo(SourceInstanceID)
   print '======================================'
   print '== Checking whether Source Instance exists'
   if not SourceInstanceInfo.id: 
     print 'ERROR: Source Instance (%s) does not exist' % (SourceInstanceID)
     quit()
   else:
     print 'PASSED: Source Instance %s (%s) exists' % (SourceInstanceInfo.tags["Name"],SourceInstanceInfo.id)
   print '======================================'
   table = PrettyTable(["Property", "Value"])
   table.align["Property"] = "l"
   table.align["Value"] = "l"

   table.add_row(["Source Instance", "ID: " + SourceInstanceInfo.id + " Name: " + SourceInstanceInfo.tags["Name"] ])
   table.add_row(["Target AMI Name", TargetInstanceName])
   table.add_row(["Target Instance Name", TargetInstanceName])
   table.add_row(["Target Instance Type", InstanceType])
#   table.add_row(["SecurityGroups", ValidatedSecurityGroups])
   for id,name in  ValidatedSecurityGroups.items():
     table.add_row(["SecurityGroup", "ID: " + id + " Name: " + name])
   table.add_row(["TargetSubnet", TargetSubnet])
   table.add_row(["KeyPair", KeyPair])
   table.add_row(["Target VPC", Subnet[TargetSubnet]['VPC']])
   table.add_row(["Target AZ", Subnet[TargetSubnet]['AZ']])
   table.add_row(["Target Tier", Subnet[TargetSubnet]['Tier']])
   #table.add_row(["Tags", Tags])
   for name,value in  Tags.items():
     table.add_row(["TAGS", "TAG: " + name + " VALUE: " + value])

   print(table)
  
   answer = raw_input('Proceed? : [y/n] ')
   if not answer or answer[0].lower() != 'y':
    print('Exiting')
    os.unlink(pidfile)
    quit()


  ####This is where the magic happens
   WaitForInstance (SourceInstanceID, "stopped")
   AMI = CreateAMIFromSource (TargetInstanceName, TargetInstanceName, SourceInstanceID)
   NewInstance = LaunchNewInstance (AMI, KeyPair, TargetInstanceName, SecurityGroups, InstanceType, TargetSubnet, Subnet[TargetSubnet]['AZ'], Tags)
   WaitForInstance (NewInstance.id, "running")
   PrintInstanceInfo (NewInstance)
   WaitForInstanceStatusCheck (NewInstance.id)

   os.unlink(pidfile)

def PrintInstanceInfo (Instance):
  table = PrettyTable(["Property", "Value"])
  table.align["Property"] = "l"
  table.add_row(["VPC", Instance.vpc_id])
  table.add_row(["Image ID", Instance.image_id])
  table.add_row(["Private IP Address", Instance.private_ip_address])
  table.add_row(["Key Name", Instance.key_name])
  #table.add_row(["instance_profile_name", instance.instance_profile ])
  table.add_row(["Tags", Instance.tags])
  print(table)


def ValidateSecurityGroups (SecurityGroups, VPC):
    SecurityGroups = conn.get_all_security_groups(group_ids=SecurityGroups)
    SecurityGroupDict = {}
    for SecurityGroup in SecurityGroups:
            if SecurityGroup.vpc_id != VPC:
              print 'ERROR: Security Group %s (%s) not valid for VPC' % (SecurityGroup.name, SecurityGroup.id)
              os.unlink(pidfile)
              quit()
            else:
              print 'PASSED: Security Group %s (%s)  is OK' % (SecurityGroup.name, SecurityGroup.id)
              SecurityGroupDict[SecurityGroup.id] = SecurityGroup.name

    return SecurityGroupDict

def GetInstanceinfo (InstanceID):
    reservations = conn.get_all_instances(instance_ids=[InstanceID])
    instance = reservations[0].instances[0]

    return instance

def WaitForInstance (InstanceID, DesiredState):
    reservations = conn.get_all_instances(instance_ids=[InstanceID])
    waitinstance = reservations[0].instances[0]
    print '...instance %s is %s' % (waitinstance.id, waitinstance.state)

    while waitinstance.state != DesiredState:
      print '...instance %s is %s, waiting until it is %s' % (waitinstance.id, waitinstance.state, DesiredState)
      time.sleep(10)
      waitinstance.update()
    return

def WaitForInstanceStatusCheck (InstanceID):
     reservations = conn.get_all_instance_status(instance_ids=[InstanceID])
     waitinstance = reservations[0]
     while (waitinstance.system_status.details["reachability"] != "passed"
           or waitinstance.system_status.status != "ok"
           or waitinstance.instance_status.status != "ok"):
       print '...instance %s reachability test = %s, SystemState = %s, Instance State = %s' % (waitinstance.id, waitinstance.system_status.details["reachability"], waitinstance.system_status, waitinstance.instance_status)
       time.sleep(10)
       reservations = conn.get_all_instance_status(instance_ids=[InstanceID])
       waitinstance = reservations[0]
     else:
       print '...instance %s reachability test = %s, SystemState = %s, Instance State = %s' % (waitinstance.id, waitinstance.system_status.details["reachability"], waitinstance.system_status, waitinstance.instance_status)
     return


def TestAMIExists (AMI_Name):
  filters = {'name': AMI_Name }
  test = conn.get_all_images(filters=filters)
  if test:
   print 'ERROR: AMI with name %s already exists (%s)' % (AMI_Name, test[0].id)
   os.unlink(pidfile)
   quit()
  if not test:
   print 'PASSED: AMI with name %s does not exist' % (AMI_Name)

def CreateAMIFromSource (AMI_Name, AMI_Desc, SourceInstance):
    NewAMI = conn.create_image(instance_id=SourceInstance,
                 name=AMI_Name,
                 description=AMI_Desc,
                 no_reboot=False,
                 block_device_mapping=None,
                 dry_run=False)


    image = conn.get_all_images(image_ids=[NewAMI])[0]
    print '...Creating AMI "%s" (%s) from instance %s ' % (AMI_Name, image.id, SourceInstance)

    while image.state == 'pending':
        print '...AMI %s is being still being created' % (image.id)
        time.sleep(5)
        image.update()
    if image.state == 'available':
        print '...AMI %s created sucessfully' % (image.id)
        return image.id

def LaunchNewInstance (AMI, KeyName,  InstanceName, SecurityGroups, InstanceType, Subnet, AZ, InstanceTags):

    reservation = conn.run_instances(
            AMI,
            key_name=KeyName,
            instance_type=InstanceType,
            security_group_ids=SecurityGroups,
            placement=AZ,
            subnet_id=Subnet,
      instance_profile_name='avid-general-ec2',
            instance_initiated_shutdown_behavior='stop',
            disable_api_termination=True)

    instance = reservation.instances[0]
    conn.create_tags([instance.id], InstanceTags)
    while instance.state != 'running':
      print '...instance %s (%s) is %s' % (InstanceName, instance.id, instance.state)
      time.sleep(10)
      instance.update()

    return instance


if __name__ == "__main__":
 main(sys.argv[1:])




# EXAMPLE INSTANCE FILE

# {
#   "TargetInstanceName": "TESTINSTANCE8",
#   "TargetSubnet": "subnet-dd0776f6",
#   "SecurityGroups": ["sg-3cbb145a","sg-04c26f62"],
#   "InstanceType": "t2.small",
#   "Tags": {
#     "CostCenter":  "000000",
#     "Environment":"POC",
#     "Application": "internal code name",
#     "Role": "Presentatio",
#     "Securitylevel":"Low"
#   }
# }


# COPY OF SUBNET Data -- save as subnets.json 
# {
#         "subnet-0095e32b": {
#             "AZ": "us-east-1c",
#             "Key": "avid-developmentVPC",
#             "Tier": "App",
#             "VPC": "vpc-66927602"
#         },
#         "subnet-0591e72e": {
#             "AZ": "us-east-1c",
#             "Key": "avid-managementVPC",
#             "Tier": "DB",
#             "VPC": "vpc-239f7b47"
#         },
#         "subnet-095e1350": {
#             "AZ": "us-east-1a",
#             "Key": "avid-managementVPC",
#             "Tier": "Web",
#             "VPC": "vpc-239f7b47"
#         },
#         "subnet-0f496378": {
#             "AZ": "us-east-1d",
#             "Key": "avid-managementVPC",
#             "Tier": "App",
#             "VPC": "vpc-239f7b47"
#         },
#         "subnet-10d29f49": {
#             "AZ": "us-east-1a",
#             "Key": "avid-productionVPC",
#             "Tier": "App",
#             "VPC": "vpc-d57195b1"
#         },
#         "subnet-1d037236": {
#             "AZ": "us-east-1c",
#             "Key": "avid-testingVPC",
#             "Tier": "NAT",
#             "VPC": "vpc-516a8e35"
#         },
#         "subnet-25dcf652": {
#             "AZ": "us-east-1d",
#             "Key": "avid-productionVPC",
#             "Tier": "App",
#             "VPC": "vpc-d57195b1"
#         },
#         "subnet-29591470": {
#             "AZ": "us-east-1a",
#             "Key": "avid-managementVPC",
#             "Tier": "Smoke Test",
#             "VPC": "vpc-239f7b47"
#         },
#         "subnet-2f4a6058": {
#             "AZ": "us-east-1d",
#             "Key": "avid-developmentVPC",
#             "Tier": "App",
#             "VPC": "vpc-66927602"
#         },
#         "subnet-2f92e404": {
#             "AZ": "us-east-1c",
#             "Key": "avid-developmentVPC",
#             "Tier": "DB",
#             "VPC": "vpc-66927602"
#         },
#         "subnet-3102731a": {
#             "AZ": "us-east-1c",
#             "Key": "avid-testingVPC",
#             "Tier": "Web",
#             "VPC": "vpc-516a8e35"
#         },
#         "subnet-35d9f342": {
#             "AZ": "us-east-1d",
#             "Key": "avid-testingVPC",
#             "Tier": "DB",
#             "VPC": "vpc-516a8e35"
#         },
#         "subnet-3990e612": {
#             "AZ": "us-east-1c",
#             "Key": "avid-managementVPC",
#             "Tier": "NAT",
#             "VPC": "vpc-239f7b47"
#         },
#         "subnet-415c1118": {
#             "AZ": "us-east-1a",
#             "Key": "avid-developmentVPC",
#             "Tier": "DB",
#             "VPC": "vpc-66927602"
#         },
#         "subnet-455d101c": {
#             "AZ": "us-east-1a",
#             "Key": "avid-developmentVPC",
#             "Tier": "App",
#             "VPC": "vpc-66927602"
#         },
#         "subnet-49eda010": {
#             "AZ": "us-east-1a",
#             "Key": "avid-productionVPC",
#             "Tier": "DB",
#             "VPC": "vpc-d57195b1"
#         },
#         "subnet-51d29f08": {
#             "AZ": "us-east-1a",
#             "Key": "avid-productionVPC",
#             "Tier": "Web",
#             "VPC": "vpc-d57195b1"
#         },
#         "subnet-5ad59803": {
#             "AZ": "us-east-1a",
#             "Key": "avid-testingVPC",
#             "Tier": "NAT",
#             "VPC": "vpc-516a8e35"
#         },
#         "subnet-5fdff528": {
#             "AZ": "us-east-1d",
#             "Key": "avid-productionVPC",
#             "Tier": "NAT",
#             "VPC": "vpc-d57195b1"
#         },
#         "subnet-6405744f": {
#             "AZ": "us-east-1c",
#             "Key": "avid-testingVPC",
#             "Tier": "App",
#             "VPC": "vpc-516a8e35"
#         },
#         "subnet-6597e14e": {
#             "AZ": "us-east-1c",
#             "Key": "avid-developmentVPC",
#             "Tier": "NAT",
#             "VPC": "vpc-66927602"
#         },
#         "subnet-66430e3f": {
#             "AZ": "us-east-1a",
#             "Key": "avid-developmentVPC",
#             "Tier": "NAT",
#             "VPC": "vpc-66927602"
#         },
#         "subnet-6f087944": {
#             "AZ": "us-east-1c",
#             "Key": "avid-productionVPC",
#             "Tier": "Web",
#             "VPC": "vpc-d57195b1"
#         },
#         "subnet-71496306": {
#             "AZ": "us-east-1d",
#             "Key": "avid-managementVPC",
#             "Tier": "Web",
#             "VPC": "vpc-239f7b47"
#         },
#         "subnet-7390e658": {
#             "AZ": "us-east-1c",
#             "Key": "avid-managementVPC",
#             "Tier": "Web",
#             "VPC": "vpc-239f7b47"
#         },
#         "subnet-7759142e": {
#             "AZ": "us-east-1a",
#             "Key": "avid-managementVPC",
#             "Tier": "DB",
#             "VPC": "vpc-239f7b47"
#         },
#         "subnet-795e1320": {
#             "AZ": "us-east-1a",
#             "Key": "avid-managementVPC",
#             "Tier": "NAT",
#             "VPC": "vpc-239f7b47"
#         },
#         "subnet-7b0b7a50": {
#             "AZ": "us-east-1c",
#             "Key": "avid-productionVPC",
#             "Tier": "DB",
#             "VPC": "vpc-d57195b1"
#         },
#         "subnet-7b745e0c": {
#             "AZ": "us-east-1d",
#             "Key": "avid-developmentVPC",
#             "Tier": "NAT",
#             "VPC": "vpc-66927602"
#         },
#         "subnet-7dd49924": {
#             "AZ": "us-east-1a",
#             "Key": "avid-testingVPC",
#             "Tier": "Web",
#             "VPC": "vpc-516a8e35"
#         },
#         "subnet-80430ed9": {
#             "AZ": "us-east-1a",
#             "Key": "avid-developmentVPC",
#             "Tier": "Web",
#             "VPC": "vpc-66927602"
#         },
#         "subnet-84d499dd": {
#             "AZ": "us-east-1a",
#             "Key": "avid-testingVPC",
#             "Tier": "App",
#             "VPC": "vpc-516a8e35"
#         },
#         "subnet-85d19cdc": {
#             "AZ": "us-east-1a",
#             "Key": "avid-testingVPC",
#             "Tier": "DB",
#             "VPC": "vpc-516a8e35"
#         },
#         "subnet-a6dcf6d1": {
#             "AZ": "us-east-1d",
#             "Key": "avid-productionVPC",
#             "Tier": "DB",
#             "VPC": "vpc-d57195b1"
#         },
#         "subnet-a74963d0": {
#             "AZ": "us-east-1d",
#             "Key": "avid-managementVPC",
#             "Tier": "DB",
#             "VPC": "vpc-239f7b47"
#         },
#         "subnet-abc4eedc": {
#             "AZ": "us-east-1d",
#             "Key": "avid-testingVPC",
#             "Tier": "NAT",
#             "VPC": "vpc-516a8e35"
#         },
#         "subnet-b64862c1": {
#             "AZ": "us-east-1d",
#             "Key": "avid-managementVPC",
#             "Tier": "NAT",
#             "VPC": "vpc-239f7b47"
#         },
#         "subnet-c1d39e98": {
#             "AZ": "us-east-1a",
#             "Key": "avid-productionVPC",
#             "Tier": "NAT",
#             "VPC": "vpc-d57195b1"
#         },
#         "subnet-c6daf0b1": {
#             "AZ": "us-east-1d",
#             "Key": "avid-testingVPC",
#             "Tier": "App",
#             "VPC": "vpc-516a8e35"
#         },
#         "subnet-cd4a60ba": {
#             "AZ": "us-east-1d",
#             "Key": "avid-developmentVPC",
#             "Tier": "DB",
#             "VPC": "vpc-66927602"
#         },
#         "subnet-dd0776f6": {
#             "AZ": "us-east-1c",
#             "Key": "avid-testingVPC",
#             "Tier": "DB",
#             "VPC": "vpc-516a8e35"
#         },
#         "subnet-e3745e94": {
#             "AZ": "us-east-1d",
#             "Key": "avid-developmentVPC",
#             "Tier": "Web",
#             "VPC": "vpc-66927602"
#         },
#         "subnet-e55e13bc": {
#             "AZ": "us-east-1a",
#             "Key": "avid-managementVPC",
#             "Tier": "App",
#             "VPC": "vpc-239f7b47"
#         },
#         "subnet-e997e1c2": {
#             "AZ": "us-east-1c",
#             "Key": "avid-developmentVPC",
#             "Tier": "Web",
#             "VPC": "vpc-66927602"
#         },
#         "subnet-eadff59d": {
#             "AZ": "us-east-1d",
#             "Key": "avid-productionVPC",
#             "Tier": "Web",
#             "VPC": "vpc-d57195b1"
#         },
#         "subnet-ed0978c6": {
#             "AZ": "us-east-1c",
#             "Key": "avid-productionVPC",
#             "Tier": "NAT",
#             "VPC": "vpc-d57195b1"
#         },
#         "subnet-fb0879d0": {
#             "AZ": "us-east-1c",
#             "Key": "avid-productionVPC",
#             "Tier": "App",
#             "VPC": "vpc-d57195b1"
#         },
#         "subnet-fcc5ef8b": {
#             "AZ": "us-east-1d",
#             "Key": "avid-testingVPC",
#             "Tier": "Web",
#             "VPC": "vpc-516a8e35"
#         },
#         "subnet-fe90e6d5": {
#             "AZ": "us-east-1c",
#             "Key": "avid-managementVPC",
#             "Tier": "App",
#             "VPC": "vpc-239f7b47"
#         }
# }
