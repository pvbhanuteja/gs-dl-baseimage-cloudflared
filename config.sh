# Possible config options:

# Config 1 BOTH REQUIRED
# Use this config if you want clodflare to give you a subdomain
USE_OWN_CLOUDFLARE="NO"
PUBLIC_SSH_KEY="YOUR_PUBLIC_SSH_KEY"
# Pulich ssh key is the public key you want to use to login to the server and this can be found in ~/.ssh/id_rsa.pub on your local machine 


# Config 2 ALL 3 REQUIRED
# Use this config if you want to use your own domain
# You need to have a cloudflare account and a domain

USE_OWN_CLOUDFLARE="YES"
CLOUDFLARED_TOKEN="PASTE_YOUR_TOKEN_HERE"
# CLOUDFLARED_TOKEN is the token you get from cloudflare tunnels page refer to readme.md for more info
PUBLIC_SSH_KEY="YOUR_PUBLIC_SSH_KEY"
# Pulich ssh key is the public key you want to use to login to the server and this can be found in ~/.ssh/id_rsa.pub on your local machine 




# Optional config for config 1
GITHUB_PERSONAL_ACCESS_TOKEN="YOUR_GITHUB_PERSONAL_ACCESS_TOKEN"
# Give only gist writes permission to this token for better security
# If no token is provided I will use my own token to comment on the gist for your url
