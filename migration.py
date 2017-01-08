# Import the SDK

from pprint import pprint
import boto.ec2
import uuid
import time
import sys, getopt


##Define all our subnets and thier vaules
## Yeah I know this is kinda klunky but it works
Subnet = {}
Subnet['subnet-51d29f08'] = {'VPC': "vpc-d57195b1",'Tier': 'Web','AZ': "us-east-1a", 'Key': "avid-productionVPC"}
Subnet['subnet-6f087944'] = {'VPC': "vpc-d57195b1",'Tier': 'Web','AZ': "us-east-1c", 'Key': "avid-productionVPC"}
Subnet['subnet-eadff59d'] = {'VPC': "vpc-d57195b1",'Tier': 'Web','AZ': "us-east-1d", 'Key': "avid-productionVPC"}
Subnet['subnet-10d29f49'] = {'VPC': "vpc-d57195b1",'Tier': 'App','AZ': "us-east-1a", 'Key': "avid-productionVPC"}
Subnet['subnet-fb0879d0'] = {'VPC': "vpc-d57195b1",'Tier': 'App','AZ': "us-east-1c", 'Key': "avid-productionVPC"}
Subnet['subnet-25dcf652'] = {'VPC': "vpc-d57195b1",'Tier': 'App','AZ': "us-east-1d", 'Key': "avid-productionVPC"}
Subnet['subnet-49eda010'] = {'VPC': "vpc-d57195b1",'Tier': 'DB','AZ': "us-east-1a", 'Key': "avid-productionVPC"}
Subnet['subnet-7b0b7a50'] = {'VPC': "vpc-d57195b1",'Tier': 'DB','AZ': "us-east-1c", 'Key': "avid-productionVPC"}
Subnet['subnet-a6dcf6d1'] = {'VPC': "vpc-d57195b1",'Tier': 'DB','AZ': "us-east-1d", 'Key': "avid-productionVPC"}
Subnet['subnet-c1d39e98'] = {'VPC': "vpc-d57195b1",'Tier': 'NAT','AZ': "us-east-1a", 'Key': "avid-productionVPC"}
Subnet['subnet-ed0978c6'] = {'VPC': "vpc-d57195b1",'Tier': 'NAT','AZ': "us-east-1c", 'Key': "avid-productionVPC"}
Subnet['subnet-5fdff528'] = {'VPC': "vpc-d57195b1",'Tier': 'NAT','AZ': "us-east-1d", 'Key': "avid-productionVPC"}
#vpc-516a8e35 (TEST)
Subnet['subnet-7dd49924'] = {'VPC': "vpc-516a8e35",'Tier': 'Web','AZ': "us-east-1a", 'Key': "avid-testingVPC"}
Subnet['subnet-3102731a'] = {'VPC': "vpc-516a8e35", 'Tier': 'Web','AZ': "us-east-1c", 'Key': "avid-testingVPC"}
Subnet['subnet-fcc5ef8b'] = {'VPC': "vpc-516a8e35", 'Tier': 'Web','AZ': "us-east-1d", 'Key': "avid-testingVPC"}
Subnet['subnet-5ad59803'] = {'VPC': "vpc-516a8e35", 'Tier': 'NAT','AZ': "us-east-1a", 'Key': "avid-testingVPC"}
Subnet['subnet-1d037236'] = {'VPC': "vpc-516a8e35", 'Tier': 'NAT','AZ': "us-east-1c", 'Key': "avid-testingVPC"}
Subnet['subnet-abc4eedc'] = {'VPC': "vpc-516a8e35", 'Tier': 'NAT','AZ': "us-east-1d", 'Key': "avid-testingVPC"}
Subnet['subnet-85d19cdc'] = {'VPC': "vpc-516a8e35", 'Tier': 'DB','AZ': "us-east-1a", 'Key': "avid-testingVPC"}
Subnet['subnet-dd0776f6'] = {'VPC': "vpc-516a8e35", 'Tier': 'DB','AZ': "us-east-1c", 'Key': "avid-testingVPC"}
Subnet['subnet-35d9f342'] = {'VPC': "vpc-516a8e35", 'Tier': 'DB','AZ': "us-east-1d", 'Key': "avid-testingVPC"}
Subnet['subnet-6405744f'] = {'VPC': "vpc-516a8e35", 'Tier': 'App','AZ': "us-east-1c", 'Key': "avid-testingVPC"}
Subnet['subnet-84d499dd'] = {'VPC': "vpc-516a8e35", 'Tier': 'App','AZ': "us-east-1a", 'Key': "avid-testingVPC"}
Subnet['subnet-c6daf0b1'] = {'VPC': "vpc-516a8e35", 'Tier': 'App','AZ': "us-east-1d", 'Key': "avid-testingVPC"}
#vpc-66927602 (DEV)
Subnet['subnet-455d101c'] = {'VPC': "vpc-66927602", 'Tier': 'App','AZ': "us-east-1a", 'Key': "avid-developmentVPC"}
Subnet['subnet-0095e32b'] = {'VPC': "vpc-66927602", 'Tier': 'App','AZ': "us-east-1c", 'Key': "avid-developmentVPC"}
Subnet['subnet-2f4a6058'] = {'VPC': "vpc-66927602", 'Tier': 'App','AZ': "us-east-1d", 'Key': "avid-developmentVPC"}
Subnet['subnet-415c1118'] = {'VPC': "vpc-66927602", 'Tier': 'DB','AZ': "us-east-1a", 'Key': "avid-developmentVPC"}
Subnet['subnet-2f92e404'] = {'VPC': "vpc-66927602", 'Tier': 'DB','AZ': "us-east-1c", 'Key': "avid-developmentVPC"}
Subnet['subnet-cd4a60ba'] = {'VPC': "vpc-66927602", 'Tier': 'DB','AZ': "us-east-1d", 'Key': "avid-developmentVPC"}
Subnet['subnet-66430e3f'] = {'VPC': "vpc-66927602", 'Tier': 'NAT','AZ': "us-east-1a", 'Key': "avid-developmentVPC"}
Subnet['subnet-6597e14e'] = {'VPC': "vpc-66927602", 'Tier': 'NAT','AZ': "us-east-1c", 'Key': "avid-developmentVPC"}
Subnet['subnet-7b745e0c'] = {'VPC': "vpc-66927602", 'Tier': 'NAT','AZ': "us-east-1d", 'Key': "avid-developmentVPC"}
Subnet['subnet-80430ed9'] = {'VPC': "vpc-66927602", 'Tier': 'Web','AZ': "us-east-1a", 'Key': "avid-developmentVPC"}
Subnet['subnet-e997e1c2'] = {'VPC': "vpc-66927602", 'Tier': 'Web','AZ': "us-east-1c", 'Key': "avid-developmentVPC"}
Subnet['subnet-e3745e94'] = {'VPC': "vpc-66927602", 'Tier': 'Web','AZ': "us-east-1d", 'Key': "avid-developmentVPC"}
#vpc-239f7b47 (MGMT)
Subnet['subnet-095e1350'] = {'VPC': "vpc-239f7b47", 'Tier': 'Web','AZ': "us-east-1a", 'Key': "avid-managementVPC"}
Subnet['subnet-7390e658'] = {'VPC': "vpc-239f7b47", 'Tier': 'Web','AZ': "us-east-1c", 'Key': "avid-managementVPC"}
Subnet['subnet-71496306'] = {'VPC': "vpc-239f7b47", 'Tier': 'Web','AZ': "us-east-1d", 'Key': "avid-managementVPC"}
Subnet['subnet-795e1320'] = {'VPC': "vpc-239f7b47", 'Tier': 'NAT','AZ': "us-east-1a", 'Key': "avid-managementVPC"}
Subnet['subnet-3990e612'] = {'VPC': "vpc-239f7b47", 'Tier': 'NAT','AZ': "us-east-1c", 'Key': "avid-managementVPC"}
Subnet['subnet-b64862c1'] = {'VPC': "vpc-239f7b47", 'Tier': 'NAT','AZ': "us-east-1d", 'Key': "avid-managementVPC"}
Subnet['subnet-7759142e'] = {'VPC': "vpc-239f7b47", 'Tier': 'DB','AZ': "us-east-1a", 'Key': "avid-managementVPC"}
Subnet['subnet-0591e72e'] = {'VPC': "vpc-239f7b47", 'Tier': 'DB','AZ': "us-east-1c", 'Key': "avid-managementVPC"}
Subnet['subnet-a74963d0'] = {'VPC': "vpc-239f7b47", 'Tier': 'DB','AZ': "us-east-1d", 'Key': "avid-managementVPC"}
Subnet['subnet-e55e13bc'] = {'VPC': "vpc-239f7b47", 'Tier': 'App','AZ': "us-east-1a", 'Key': "avid-managementVPC"}
Subnet['subnet-fe90e6d5'] = {'VPC': "vpc-239f7b47", 'Tier': 'App','AZ': "us-east-1c", 'Key': "avid-managementVPC"}
Subnet['subnet-0f496378'] = {'VPC': "vpc-239f7b47", 'Tier': 'App','AZ': "us-east-1d", 'Key': "avid-managementVPC"}
Subnet['subnet-29591470'] = {'VPC': "vpc-239f7b47", 'Tier': 'Smoke Test','AZ': "us-east-1a", 'Key': "avid-managementVPC"}



def main(argv):
   TargetInstanceName = ''
   SourceInstanceID = ''
   TargetSubnet = ''
   SecurityGroups = ''
   InstanceType = ''
   try:
      opts, args = getopt.getopt(argv,"h:",["SourceInstance=","Name=","SecurityGroups=","Subnet=","InstanceType="])
   except getopt.GetoptError:
      print 'Migrator.py --SourceInstance <Source Instance ID>  --Name <New Instance Name> --SecurityGroups <Comma Seperated Security Groups> --Subnet <subnet ID> --InstanceType <instancetype>'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
	 print 'Migrator.py --SourceInstance <Source Instance ID>  --Name <New Instance Name> --SecurityGroups <Comma Seperated Security Groups> --Subnet <subnet ID> --InstanceType <instancetype>'
         sys.exit()
      elif opt in ("--SourceInstance"):
         SourceInstanceID = arg
      elif opt in ("--Name"):
         TargetInstanceName = arg
      elif opt in ("--SecurityGroups"):
         SecurityGroups = arg.split(",")
      elif opt in ("--Subnet"):
         TargetSubnet = arg
      elif opt in ("--InstanceType"):
         InstanceType = arg

   ##connect to AWS EC2
   global conn
   conn = boto.ec2.connect_to_region("us-east-1")

##Add check for SG validity
   print '======================================'
   print '== Validating Security Groups ========'
   ValidateSecurityGroups (SecurityGroups, Subnet[TargetSubnet]['VPC'])
   print '======================================'
   print '== Validating Security Groups ========'
   print '======================================'
   print 'Source Instance', SourceInstanceID
   print 'Target AMI Name', TargetInstanceName
   print 'Target Instance Name', TargetInstanceName
   print 'Target Instance Type', InstanceType
   print 'SecurityGroups = ', SecurityGroups
   print 'TargetSubnet = ', TargetSubnet
   print 'KeyPair = %s' % (Subnet[TargetSubnet]['Key'])
   print 'Target VPC = %s' % (Subnet[TargetSubnet]['VPC'])
   print 'Target AZ = %s' % (Subnet[TargetSubnet]['AZ'])
   print 'Target Tier = %s' % (Subnet[TargetSubnet]['Tier'])
  print '======================================'


   answer = raw_input('Proceed? : [y/n] ')
   if not answer or answer[0].lower() != 'y':
    print('Exiting')
    quit()
   TestAMIExists (TargetInstanceName)
   WaitForInstance (SourceInstanceID, "stopped")
   AMI = CreateAMIFromSource (TargetInstanceName, TargetInstanceName, SourceInstanceID)
   NewInstance = LaunchNewInstance (AMI, Subnet[TargetSubnet]['Key'],  TargetInstanceName, SecurityGroups, InstanceType, TargetSubnet, Subnet[TargetSubnet]['AZ'])
 #WaitForInstanceStatusCheck (NewInstance)
   pprint (NewInstance)


def ValidateSecurityGroups (SecurityGroups, Subnet)
    SecurityGroups = conn.get_all_security_groups(group_ids=SecurityGroups)
    for SecurityGroup in SecurityGroups:
            if SecurityGroup.vpc_id != VPC:
              print 'Security Group %s (%s) not valid for VPC' % (SecurityGroup.name, SecurityGroup.id)
              quit()
            else:
              print 'Security Group %s (%s)  is OK' % (SecurityGroup.name, SecurityGroup.id)

    return


def WaitForInstance (InstanceID, DesiredState):
    reservations = conn.get_all_instances(instance_ids=[InstanceID])
    waitinstance = reservations[0].instances[0]
    print '...instance %s is %s' % (waitinstance.id, waitinstance.state)

    while waitinstance.state != DesiredState:
      print '...instance %s is %s, waiting until it is %s' % (waitinstance.id, waitinstance.state, DesiredState)
      time.sleep(10)
      waitinstance.update()
    return

# def WaitForInstanceStatusCheck (InstanceID):
#         reservations = conn.get_all_instance_status(instance_ids=[InstanceID])
#         waitinstance = reservations[0].instances[0]
#         while waitinstance.status != DesiredState:
#           print '...instance %s is %s' % (waitinstance.id, waitinstance.state)
#           time.sleep(10)
#           waitinstance.update()
#         return

def TestAMIExists (AMI_Name):
	filters = {'name': AMI_Name }
	test = conn.get_all_images(filters=filters)
	if test:
	 print 'AMI with name %s already exists' % (AMI_Name)
	 quit()
	if not test:
	 print 'AMI with name %s does not exist' % (AMI_Name)

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
        #once AMI created reutn the ID
        print '...AMI %s created sucessfully' % (image.id)
        return image.id

def LaunchNewInstance (AMI, KeyName,  InstanceName, SecurityGroups, InstanceType, Subnet, AZ):

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
    conn.create_tags([instance.id], {'Name': InstanceName})
    while instance.state != 'running':
      print '...instance is %s' % instance.state
      time.sleep(10)
      instance.update()


    pprint (instance.ip_address)
    pprint (instance.tags)
    pprint (instance)
    return instance


if __name__ == "__main__":
 main(sys.argv[1:])
