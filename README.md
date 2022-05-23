# esup-pod
## Purpose
We created this composition because we needed a simple way to host esup-pod.  
We found an existing composition (see credits) that was separating the website and the encoding (need for MySQL database and more complex composition) and that was serving the front-end without using uwsgi and not serving the static files with Nginx.  
You can use this composition in production if you don't have critical needs in term of video encoding.
## Build docker images
```bash
docker build -t ulysseus/esup-pod .
docker build -t ulysseus/elasticsearch -f Dockerfile.elasticsearch .
docker build -t ulysseus/nginx -f Dockerfile.nginx .
```
## Launch
```bash
# prepare your machine to host Elastic Search
sysctl -w vm.max_map_count=262144
# Get the id of pod user within esup-pod container
docker-compose run esup-pod id
# adapt based on the outcome of previous entry
sudo chown <pod-user-id>:<pod-group-id> static media socket database
# Create the database
docker-compose run esup-pod sh create_data_base.sh
# Create a super user
docker-compose run esup-pod python manage.py createsuperuser --username <username> --email <email>
# Create elastic index
docker-compose run esup-pod python manage.py create_pod_index
# Collect all static files to be served by nginx
docker-compose run esup-pod python manage.py collectstatic
docker-compose up -d
```
## Go to production
Beware that this project has been used to host Ulysseus European University videos and you shall remove any Ulysseus specificity before deploying in production.
```bash
grep -i ulysseus *
```
Set DEBUG to False in settings_local.py 
```bash
sed -i 's/DEBUG = True/DEBUG = False/' settings_local.py
```

## Activate SSL
You need to have at your disposal a certificate and its private key.  
Update docker-compose.yaml to mount your certificates for nginx container to use them.  
Update nginx-pod.conf to listen to port 443, identify the location of your certificate & key and activate redirect from http to https.  
In case you're at the root of your domain, think about adding www redirect.  
Updating settings_local.py:  
SECURE_SSL_REDIRECT = True  
SESSION_COOKIE_SECURE = True  
CSRF_COOKIE_SECURE = True  

## Credit
Another docker-compose that helped me on the way: https://plmlab.math.cnrs.fr/docker-images/esup-pod  
The official installation guide for v2: https://www.esup-portail.org/wiki/display/ES/installation

