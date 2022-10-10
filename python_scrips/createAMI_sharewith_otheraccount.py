import sys
import time
import boto
import boto.ec2
import boto.ec2.instance
import boto.ec2.networkinterface
import webbrowser
stgconn = boto.ec2.connect_to_region(
	"us-east-1",
	 aws_access_key_id='****',
	 aws_secret_access_key='*******'
	 )


class Create_Image(object):
	def __init__(self, name, instanceid, shareaccid):
		self.name = name
		self.instanceid = instanceid
		self.shareaccid = shareaccid
		self.createami()
		#self.shareami()

# Create image of instance
	def createami(self):
			self.ami_id = stgconn.create_image(
			instance_id = self.instanceid,
			name = self.name,
			no_reboot = True
			)
			image = stgconn.get_all_images(image_ids=[self.ami_id])[0]
#			import pdb; pdb.set_trace()
			while image.state == 'pending':
				print ('current image status: ', image.state)
				time.sleep(10)
				image.update()
				if image.state == 'available':
					print ("ami is available and now going to share another account")
					stgconn.modify_image_attribute(
						image_id = self.ami_id,
						operation='add',
						attribute='launchPermission',
						user_ids= self.shareaccid
						)
				else:
					print ('current image status: ', image.state)
# Share ami from one account to another account
	def shareami(self):
		stgconn.modify_image_attribute(
			image_id = self.ami_id, 
			operation='add', 
			attribute='launchPermission', 
			user_ids= self.shareaccid
			)



Create_Image(name, instanceid, shareaccid)				
