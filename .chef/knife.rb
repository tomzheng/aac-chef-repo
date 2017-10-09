# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "chefadmin"
client_key               "#{current_dir}/chefadmin.pem"
chef_server_url          "https://SGVLAPAACchefs.bcc.ap.abn/organizations/aac_develop"
cookbook_path            [".","#{current_dir}/../../chef-repo/cookbooks"]
