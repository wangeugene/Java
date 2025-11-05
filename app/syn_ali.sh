## mapping local project folder /Users/euwang/Projects/Java/app to the AWS EC2 instance /app folder
# on EC2 instance, run first:
# sudo mkdir -p /app && sudo chown -R ec2-user:ec2-user /app
# mkdir -p certbot nginx fetcher www config nginx/conf.d

# aws defined in ~/.ssh/config on your machine
# this syncs your local project folder to ~/app on the aws EC2 instance, the home directory of ec2-user
rsync -avz --delete --exclude '.git' --exclude 'node_modules'  /Users/euwang/Projects/Java/app/ ali:/app


# docker compose to start nginx only
