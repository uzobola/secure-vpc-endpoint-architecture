```bash
#!/bin/bash

#switch to root user
sudo su

# Update the system and install Apache web server
yum update -y
# Install Apache web server
yum install httpd -y

# Start the Apache web server and enable it to start on boot
systemctl start httpd
systemctl enable httpd

# Create a simple HTML file to serve as the web page
echo "<html><h1> Welcome, You are now accessing my Server! </h1><html>" >> /var/www/html/index.html

# Restart the Apache web server to apply changes
systemctl restart httpd