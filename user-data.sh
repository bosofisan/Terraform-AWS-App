#!/bin/bash
yum update -y

amazon-linux-extras install -y nginx1
systemctl enable nginx
systemctl start nginx

cat <<EOF > /usr/share/nginx/html/index.html
<html>
  <h1>Terraform Deployed This</h1>
  <p>Hi Lulu! Your project is live from AWS EC2.</p>
</html>
EOF
