#add servermanager cmdlets
import-module servermanager

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms")|Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing")|Out-Null

#############
#Global Vars for the configuration form - enabled/disabled colours
$global:errorcolor=[System.Drawing.Color]::FromArgb(255,255,255,0)
$global:validcolor=[System.Drawing.Color]::FromArgb(255,255,255,255)
$global:disabledtext = [System.Drawing.Color]::FromArgb(255,172,168,153)
$global:disabledfield = [System.Drawing.Color]::FromArgb(255,224,224,224)
$global:enabledtext = [System.Drawing.Color]::FromArgb(0,0,0,0)
$global:enabledfield = [System.Drawing.Color]::FromArgb(255,255,255,255)

[bool] $global:NIC2_Enabled=$False
$global:errorcount=0
$global:State="0"
$global:Rebooting=$False


#create the form
function GenerateForm {

#region Generated Form Objects
$form1 = New-Object System.Windows.Forms.Form
$servername_L = New-Object System.Windows.Forms.Label
$Domain_L = New-Object System.Windows.Forms.Label
$Env_L = New-Object System.Windows.Forms.Label
$Site_L = New-Object System.Windows.Forms.Label
$IP_G1_L = New-Object System.Windows.Forms.Label
$Subnet_G1_L = New-Object System.Windows.Forms.Label
$Gateway_G1_L = New-Object System.Windows.Forms.Label
$DNS1_G1_L = New-Object System.Windows.Forms.Label
$DNS2_G1_L = New-Object System.Windows.Forms.Label
$IP_G2_L = New-Object System.Windows.Forms.Label
$Subnet_G2_L = New-Object System.Windows.Forms.Label
$Gateway_G2_L = New-Object System.Windows.Forms.Label
$DNS1_G2_L = New-Object System.Windows.Forms.Label
$DNS2_G2_L = New-Object System.Windows.Forms.Label
$rack_L = New-Object System.Windows.Forms.Label
$swtichport_G1_L = New-Object System.Windows.Forms.Label
$swtichport_G2_L = New-Object System.Windows.Forms.Label
$ServerType_L = New-Object System.Windows.Forms.Label

$Domain_C = New-Object System.Windows.Forms.ComboBox
$Env_C = New-Object System.Windows.Forms.ComboBox
$Site_C = New-Object System.Windows.Forms.ComboBox
$ServerType_C = New-Object System.Windows.Forms.ComboBox

$Internal_G1_R = New-Object System.Windows.Forms.RadioButton
$External_G1_R = New-Object System.Windows.Forms.RadioButton
$Internal_G2_R = New-Object System.Windows.Forms.RadioButton
$External_G2_R = New-Object System.Windows.Forms.RadioButton

$groupBox1 = New-Object System.Windows.Forms.GroupBox
$groupBox2 = New-Object System.Windows.Forms.GroupBox

$servername_T = New-Object System.Windows.Forms.TextBox
$IP_G1_T = New-Object System.Windows.Forms.TextBox
$Subnet_G1_T = New-Object System.Windows.Forms.TextBox
$Gateway_G1_T = New-Object System.Windows.Forms.TextBox
$DNS1_G1_T = New-Object System.Windows.Forms.TextBox
$DNS2_G1_T = New-Object System.Windows.Forms.TextBox
$IP_G2_T = New-Object System.Windows.Forms.TextBox
$Subnet_G2_T = New-Object System.Windows.Forms.TextBox
$Gateway_G2_T = New-Object System.Windows.Forms.TextBox
$DNS1_G2_T = New-Object System.Windows.Forms.TextBox
$DNS2_G2_T = New-Object System.Windows.Forms.TextBox
$rack_T = New-Object System.Windows.Forms.TextBox
$switchport_G1_T = New-Object System.Windows.Forms.TextBox
$switchport_G2_T = New-Object System.Windows.Forms.TextBox

$checkBox1 = New-Object System.Windows.Forms.CheckBox

$button2 = New-Object System.Windows.Forms.Button
$button1 = New-Object System.Windows.Forms.Button

$fontDialog1 = New-Object System.Windows.Forms.FontDialog
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects

#----------------------------------------------
#Generated Event Script Blocks
#----------------------------------------------
#Provide Custom Code for events specified in PrimalForms.
$button1_OnClick= 
{

#OK button
validateform
#get all variables

$global:ServerName=$servername_T.Text
$global:IP_G1=$IP_G1_T.text
$global:Subnet_G1=$Subnet_G1_T.text
$global:Gateway_G1=$Gateway_G1_T.text
$global:DNS1_G1=$DNS1_G1_T.text
$global:DNS2_G1=$DNS2_G1_T.text
$global:IP_G2=$IP_G2_T.text
$global:Subnet_G2=$Subnet_G2_T.text
$global:Gateway_G2=$Gateway_G2_T.text
$global:DNS1_G2=$DNS1_G2_T.text
$global:DNS2_G2=$DNS2_G2_T.text
$global:rack=$rack_T.text
$global:switchport_G1=$switchport_G1_T.text
$global:switchport_G2=$switchport_G2_T.text
$global:Internal_G1=$Internal_G1_R.Checked
$global:External_G1=$External_G1_R.Checked
$global:Internal_G2=$Internal_G2_R.Checked
$global:External_G2=$External_G2_R.Checked
$global:Domain=$Domain_C.text
$global:Env=$Env_C.text
$global:Site=$Site_C.text
$global:ServerType=$ServerType_C.text

if ($global:errorcount -eq 0) {$form1.Close()}

}

$button2_OnClick= 
{
#Cancel
$global:State="999"
$form1.Close()
}

$handler_External_G1_R_CheckedChanged= 
{
#TODO: Place custom script here

}

$handler_servername_L_Click= 
{
#TODO: Place custom script here

}

$handler_Site_L_Click= 
{
#TODO: Place custom script here

}

$handler_checkBox1_CheckedChanged= 
{
$global:NIC2_Enabled=$checkBox1.Checked
enabledisablenic2
}


$handler_rack_T_TextChanged= 
{
#TODO: Place custom script here

}

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$form1.WindowState = $InitialFormWindowState
}






# ##################################################################################################
#Form
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 403
$System_Drawing_Size.Width = 720
$form1.ClientSize = $System_Drawing_Size
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$form1.Name = "form1"
$form1.Text = "System Information"


# ##################################################################################################
#Labe1 - Server Name

$servername_L.Location = New-Object System.Drawing.Size(25,9)
$servername_L.Name = "servername_L"
$servername_L.Size = New-Object System.Drawing.Size(100,23)
$servername_L.Text = "Server Name"
$servername_L.add_Click($handler_servername_L_Click)

$servername_T.Location = New-Object System.Drawing.Size(25,25)
$servername_T.Name = "servername_T"
$servername_T.Size = New-Object System.Drawing.Size(201,20)
$servername_T.TabIndex = 1

$form1.Controls.Add($servername_T)
$form1.Controls.Add($servername_L)

#############################################################################################################
#domain
$Domain_L.Location = New-Object System.Drawing.Size(25,58)
$Domain_L.Name = "Domain_L"
$Domain_L.Size = New-Object System.Drawing.Size(100,23)
$Domain_L.Text = "Domain"

$Domain_C.FormattingEnabled = $True
$Domain_C.Location = New-Object System.Drawing.Size(24,74)
$Domain_C.Name = "Domain_C"
$Domain_C.Size = New-Object System.Drawing.Size(202,21)
$Domain_C.TabIndex = 2
$Domain_C.Items.Add("BNWEB")|Out-Null
$Domain_C.Items.Add("DEV")|Out-Null
$Domain_C.Items.Add("BNWWW.prod.bn")|Out-Null


$form1.Controls.Add($Domain_C)
$form1.Controls.Add($Domain_L)

# ##################################################################################################
#Servertype

$ServerType_L.Location = New-Object System.Drawing.Size(28,107)
$ServerType_L.Name = "ServerType_L"
$ServerType_L.Size = New-Object System.Drawing.Size(100,23)
$ServerType_L.Text = "Server Type"


$ServerType_C.FormattingEnabled = $True
$ServerType_C.Items.Add("Base")|Out-Null
$ServerType_C.Items.Add("WWW")|Out-Null
$ServerType_C.Items.Add("Netcart")|Out-Null
$ServerType_C.Location = New-Object System.Drawing.Size(24,122)
$ServerType_C.Name = "ServerType_C"
$ServerType_C.Size = New-Object System.Drawing.Size(202,21)
$ServerType_C.TabIndex = 3

$form1.Controls.Add($ServerType_C)
$form1.Controls.Add($ServerType_L)

# ##################################################################################################
#Environment

$Env_L.Location = New-Object System.Drawing.Size(252,9)
$Env_L.Name = "Env_L"
$Env_L.Size = New-Object System.Drawing.Size(100,23)
$Env_L.Text = "Environment"

$Env_C.FormattingEnabled = $True
$Env_C.Items.Add("QA")|Out-Null
$Env_C.Items.Add("SI")|Out-Null
$Env_C.Items.Add("Prod")|Out-Null
$Env_C.Location = New-Object System.Drawing.Size(252,24)
$Env_C.Name = "Env_C"
$Env_C.Size = New-Object System.Drawing.Size(142,21)
$Env_C.TabIndex = 4

$form1.Controls.Add($Env_C)
$form1.Controls.Add($Env_L)

# ##################################################################################################
##Site
$Site_L.Location = New-Object System.Drawing.Size(252,58)
$Site_L.Name = "Site_L"
$Site_L.Size = New-Object System.Drawing.Size(100,23)
$Site_L.Text = "Site"
$Site_L.add_Click($handler_Site_L_Click)

$Site_C.FormattingEnabled = $True
$Site_C.Items.Add("Monroe")|Out-Null
$Site_C.Items.Add("New York")|Out-Null
$Site_C.Items.Add("Westbury")|Out-Null

$Site_C.Location = New-Object System.Drawing.Size(252,74)
$Site_C.Name = "Site_C"
$Site_C.Size = New-Object System.Drawing.Size(149,21)
$Site_C.TabIndex = 5


$form1.Controls.Add($Site_C)
$form1.Controls.Add($Site_L)

# ##################################################################################################
#Rack

$rack_L.Location = New-Object System.Drawing.Size(436,58)
$rack_L.Name = "rack_L"
$rack_L.Size = New-Object System.Drawing.Size(100,23)
$rack_L.Text = "Rack"

$rack_T.Location = New-Object System.Drawing.Size(436,75)
$rack_T.Name = "rack_T"
$rack_T.Size = New-Object System.Drawing.Size(207,20)
$rack_T.TabIndex = 6
$rack_T.add_TextChanged($handler_rack_T_TextChanged)

$form1.Controls.Add($rack_T)
$form1.Controls.Add($rack_L)
# ##################################################################################################
# ##################################################################################################
# ##################################################################################################
###########################################################
#network 1
###########################################################
$groupBox1.Location = New-Object System.Drawing.Size(28,149)
$groupBox1.Name = "groupBox1"
$groupBox1.Size = New-Object System.Drawing.Size(300,199)
$groupBox1.TabStop = $False
$groupBox1.Text = "Network Interface 1"
$form1.Controls.Add($groupBox1)

# ##################################################################################################
##Group 1 - Ip address

$IP_G1_L.Location = New-Object System.Drawing.Size(7,21)
$IP_G1_L.Name = "IP_G1_L"
$IP_G1_L.Size = New-Object System.Drawing.Size(100,23)
$IP_G1_L.Text = "IP Address"

$IP_G1_T.Location = New-Object System.Drawing.Size(7,37)
$IP_G1_T.Name = "IP_G1_T"
$IP_G1_T.Size = New-Object System.Drawing.Size(100,20)
$IP_G1_T.TabIndex = 7


$groupBox1.Controls.Add($IP_G1_T)
$groupBox1.Controls.Add($IP_G1_L)

# ##################################################################################################
#Group 1 - Subnet Mask

$Subnet_G1_L.Location = New-Object System.Drawing.Size(6,64)
$Subnet_G1_L.Name = "Subnet_G1_L"
$Subnet_G1_L.Size = New-Object System.Drawing.Size(100,23)
$Subnet_G1_L.Text = "Subnet Mask"

$Subnet_G1_T.Location = New-Object System.Drawing.Size(7,79)
$Subnet_G1_T.Name = "Subnet_G1_T"
$Subnet_G1_T.Size = New-Object System.Drawing.Size(100,20)
$Subnet_G1_T.TabIndex = 8


$groupBox1.Controls.Add($Subnet_G1_T)
$groupBox1.Controls.Add($Subnet_G1_L)
# ##################################################################################################
#Group1 - Gateway


$Gateway_G1_L.Location = New-Object System.Drawing.Size(7,106)
$Gateway_G1_L.Name = "Gateway_G1_L"
$Gateway_G1_L.Size = New-Object System.Drawing.Size(100,23)
$Gateway_G1_L.Text = "Gateway"

$Gateway_G1_T.Location = New-Object System.Drawing.Size(7,124)
$Gateway_G1_T.Name = "Gateway_G1_T"
$Gateway_G1_T.Size = New-Object System.Drawing.Size(100,20)
$Gateway_G1_T.TabIndex = 9


$groupBox1.Controls.Add($Gateway_G1_T)
$groupBox1.Controls.Add($Gateway_G1_L)

# ##################################################################################################
#Group 1 DNS 1


$DNS1_G1_L.Location = New-Object System.Drawing.Size(142,64)
$DNS1_G1_L.Name = "DNS1_G1_L"
$DNS1_G1_L.Size = New-Object System.Drawing.Size(100,23)
$DNS1_G1_L.Text = "DNS Server 1"

$DNS1_G1_T.Location = New-Object System.Drawing.Size(142,79)
$DNS1_G1_T.Name = "DNS1_G1_T"
$DNS1_G1_T.Size = New-Object System.Drawing.Size(123,20)
$DNS1_G1_T.TabIndex = 10


$groupBox1.Controls.Add($DNS1_G1_T)
$groupBox1.Controls.Add($DNS1_G1_L)

# ##################################################################################################
#Group 1 DNs 2

$DNS2_G1_L.Location = New-Object System.Drawing.Size(142,106)
$DNS2_G1_L.Name = "DNS2_G1_L"
$DNS2_G1_L.Size = New-Object System.Drawing.Size(100,23)
$DNS2_G1_L.Text = "DNS Server 2"

$DNS2_G1_T.Location = New-Object System.Drawing.Size(142,124)
$DNS2_G1_T.Name = "DNS2_G1_T"
$DNS2_G1_T.Size = New-Object System.Drawing.Size(123,20)
$DNS2_G1_T.TabIndex = 11

$groupBox1.Controls.Add($DNS2_G1_T)
$groupBox1.Controls.Add($DNS2_G1_L)

# ##################################################################################################
#Group 1 Switch Port


$swtichport_G1_L.Location = New-Object System.Drawing.Size(7,157)
$swtichport_G1_L.Name = "swtichport_G1_L"
$swtichport_G1_L.Size = New-Object System.Drawing.Size(100,23)
$swtichport_G1_L.Text = "Switch Port"

$switchport_G1_T.Location = New-Object System.Drawing.Size(7,173)
$switchport_G1_T.Name = "swtichport_G1_T"
$switchport_G1_T.Size = New-Object System.Drawing.Size(235,23)
$switchport_G1_T.TabIndex = 12

$groupBox1.Controls.Add($switchport_G1_T)
$groupBox1.Controls.Add($swtichport_G1_L)
# ##################################################################################################
## Group1 External internal


$External_G1_R.Location = New-Object System.Drawing.Size(213,15)
$External_G1_R.Name = "External_G1_R"
$External_G1_R.Size = New-Object System.Drawing.Size(65,24)
$External_G1_R.TabStop = $True
$External_G1_R.Text = "External"
$External_G1_R.UseVisualStyleBackColor = $True
$External_G1_R.add_CheckedChanged($handler_External_G1_R_CheckedChanged)

$groupBox1.Controls.Add($External_G1_R)


$Internal_G1_R.Location = New-Object System.Drawing.Size(142,15)
$Internal_G1_R.Name = "Internal_G1_R"
$Internal_G1_R.Size = New-Object System.Drawing.Size(65,24)
$Internal_G1_R.TabIndex = 13
$Internal_G1_R.TabStop = $True
$Internal_G1_R.Text = "Internal"
$Internal_G1_R.Checked = $True
$Internal_G1_R.UseVisualStyleBackColor = $True


$groupBox1.Controls.Add($Internal_G1_R)

###########################################################
#network 2
###########################################################

$groupBox2.Location = New-Object System.Drawing.Size(353,151)
$groupBox2.Name = "groupBox2"
$groupBox2.Size = New-Object System.Drawing.Size(323,197)
$groupBox2.TabStop = $False
$groupBox2.Text = "Network Interface 2"
$form1.Controls.Add($groupBox2)


###################################################################################################

$checkBox1.Location = New-Object System.Drawing.Size(436,121)
$checkBox1.Name = "checkBox1"
$checkBox1.Size = New-Object System.Drawing.Size(194,24)
$checkBox1.TabIndex = 23
$checkBox1.Text = "Enable Network Interface 2"
$checkBox1.UseVisualStyleBackColor = $True
$checkBox1.add_CheckedChanged($handler_checkBox1_CheckedChanged)
$checkBox1.checked=$NIC2_Enabled
$form1.Controls.Add($checkBox1)


###################################################################################################
#group 2 IP Address

$IP_G2_L.Location = New-Object System.Drawing.Size(7,20)
$IP_G2_L.Name = "IP_G2_L"
$IP_G2_L.Size = New-Object System.Drawing.Size(100,23)
$IP_G2_L.Text = "IP Address"



$IP_G2_T.Location = New-Object System.Drawing.Size(5,35)
$IP_G2_T.Name = "IP_G2_T"
$IP_G2_T.Size = New-Object System.Drawing.Size(100,20)
$IP_G2_T.TabIndex = 14


$groupBox2.Controls.Add($IP_G2_T)
$groupBox2.Controls.Add($IP_G2_L)
# ##################################################################################################
#Grouop 2 - subent
$Subnet_G2_L.Location = New-Object System.Drawing.Size(5,62)
$Subnet_G2_L.Name = "Subnet_G2_L"
$Subnet_G2_L.Size = New-Object System.Drawing.Size(100,23)
$Subnet_G2_L.Text = "Subnet Mask"


$Subnet_G2_T.Location = New-Object System.Drawing.Size(6,77)
$Subnet_G2_T.Name = "Subnet_G2_T"
$Subnet_G2_T.Size = New-Object System.Drawing.Size(100,20)
$Subnet_G2_T.TabIndex = 15


$groupBox2.Controls.Add($Subnet_G2_T)
$groupBox2.Controls.Add($Subnet_G2_L)
# ##################################################################################################
#Group 2 - Gateway

$Gateway_G2_L.Location = New-Object System.Drawing.Point(5,104)
$Gateway_G2_L.Name = "Gateway_G2_L"
$Gateway_G2_L.Size = New-Object System.Drawing.Size(100,23)
$Gateway_G2_L.Text = "Gateway"



$Gateway_G2_T.Location = New-Object System.Drawing.Size(7,122)
$Gateway_G2_T.Name = "Gateway_G2_T"
$Gateway_G2_T.Size = New-Object System.Drawing.Size(100,20)
$Gateway_G2_T.TabIndex = 16



$groupBox2.Controls.Add($Gateway_G2_T)
$groupBox2.Controls.Add($Gateway_G2_L)
# ##################################################################################################
## Group 2 - DNS 1

$DNS1_G2_L.Location = New-Object System.Drawing.Size(165,62)
$DNS1_G2_L.Name = "DNS1_G2_L"
$DNS1_G2_L.Size = New-Object System.Drawing.Size(100,23)
$DNS1_G2_L.Text = "DNS Server 1"

$DNS1_G2_T.Location = New-Object System.Drawing.Size(165,77)
$DNS1_G2_T.Name = "DNS1_G2_T"
$DNS1_G2_T.Size = New-Object System.Drawing.Size(100,20)
$DNS1_G2_T.TabIndex = 17


$groupBox2.Controls.Add($DNS1_G2_T)
$groupBox2.Controls.Add($DNS1_G2_L)
# ##################################################################################################
##Group 2 - DNs 2

$DNS2_G2_L.Location = New-Object System.Drawing.Size(165,104)
$DNS2_G2_L.Name = "DNS2_G2_L"
$DNS2_G2_L.Size = New-Object System.Drawing.Size(100,23)
$DNS2_G2_L.Text = "DNS Server 2"



$DNS2_G2_T.Location = New-Object System.Drawing.Size(165,122)
$DNS2_G2_T.Name = "DNS2_G2_T"
$DNS2_G2_T.Size = New-Object System.Drawing.Size(100,20)
$DNS2_G2_T.TabIndex = 18



$groupBox2.Controls.Add($DNS2_G2_T)
$groupBox2.Controls.Add($DNS2_G2_L)

# ##################################################################################################
##Group 2 Swtich port

$swtichport_G2_L.Location = New-Object System.Drawing.Size(7,155)
$swtichport_G2_L.Name = "swtichport_G2_L"
$swtichport_G2_L.Size = New-Object System.Drawing.Size(100,23)
$swtichport_G2_L.Text = "Switch Port"

$switchport_G2_T.Location = New-Object System.Drawing.Size(7,171)
$switchport_G2_T.Name = "switchport2_T"
$switchport_G2_T.Size = New-Object System.Drawing.Size(258,20)
$switchport_G2_T.TabIndex = 19

$groupBox2.Controls.Add($switchport_G2_T)
$groupBox2.Controls.Add($swtichport_G2_L)
# ##################################################################################################
#Group 2 - Internal External

$Internal_G2_R.Location = New-Object System.Drawing.Size(161,13)
$Internal_G2_R.Name = "Internal_G2_R"
$Internal_G2_R.Size = New-Object System.Drawing.Size(65,24)
$Internal_G2_R.TabIndex = 20
$Internal_G2_R.TabStop = $True
$Internal_G2_R.Text = "Internal"
$Internal_G2_R.UseVisualStyleBackColor = $True

$groupBox2.Controls.Add($Internal_G2_R)

$External_G2_R.Location = New-Object System.Drawing.Size(232,13)
$External_G2_R.Name = "External_G2_R"
$External_G2_R.Size = New-Object System.Drawing.Size(65,24)
$Internal_G2_R.TabIndex = 21
$External_G2_R.TabStop = $True
$External_G2_R.Text = "External"
$External_G2_R.Checked = $True
$External_G2_R.UseVisualStyleBackColor = $True

$groupBox2.Controls.Add($External_G2_R)

# ##################################################################################################
# ##################################################################################################
#Buttons


$button2.Location = New-Object System.Drawing.Size(358,368)
$button2.Name = "button2"
$button2.Size = New-Object System.Drawing.Size(75,23)
$button2.TabIndex = 22
$button2.Text = "Cancel"
$button2.UseVisualStyleBackColor = $True
$button2.add_Click($button2_OnClick)

$form1.Controls.Add($button2)


$button1.Location = New-Object System.Drawing.Size(218,368)
$button1.Name = "button1"
$button1.Size = New-Object System.Drawing.Size(75,23)
$button1.TabIndex = 23
$button1.Text = "OK"
$button1.UseVisualStyleBackColor = $True
$button1.add_Click($button1_OnClick)

$form1.Controls.Add($button1)

# ##################################################################################################
### Finalize form
$fontDialog1.ShowHelp = $True

#endregion Generated Form Code

enabledisablenic2

#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$form1.Add_Shown({$form1.Activate()})
[void] $form1.ShowDialog()
} #End GenerateForm Function

GenerateForm