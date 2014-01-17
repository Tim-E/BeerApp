# Copyright 2012, Jason Grimes
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


# Get mysql root password
mysql_root_pass = node['beerapp']['db_pass']
databases = [
  {'ipaddress' => 'localhost', 'index' => 'beerapp' }
]

databases.each do |database|
  # Create application database
  ruby_block "create_#{database['index']}_db" do
    block do
      %x[mysql -uroot -p#{mysql_root_pass} -e "CREATE DATABASE #{node[database['index']]['db_name']};"] 
    end 
    not_if "mysql -uroot -p#{mysql_root_pass} -e \"SHOW DATABASES LIKE '#{node[database['index']]['db_name']}'\" | grep #{node[database['index']]['db_name']}";
    action :create
  end

  # Grant mysql privileges for each web server 

  ip = database['ipaddress']
  ruby_block "add_#{ip}_#{database['index']}_permissions" do
    block do
      %x[mysql -u root -p#{mysql_root_pass} -e "GRANT SELECT,INSERT,UPDATE,DELETE \
        ON #{node[database['index']]['db_name']}.* TO '#{node[database['index']][:db_user]}'@'#{ip}' IDENTIFIED BY '#{node[database['index']]['db_pass']}';"]
    end
    not_if "mysql -u root -p#{mysql_root_pass} -e \"SELECT user, host FROM mysql.user\" | \
      grep #{node[database['index']]['db_user']} | grep #{ip}"
    action :create
  end

  # populate databases with init data
  ruby_block "populate_#{database['index']}_db" do
    block do
      %x[mysql -uroot -p#{mysql_root_pass} #{node[database['index']]['db_name']} < #{node[database['index']]['schema_file']};]
    end 
  end

end

