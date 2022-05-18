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
# Create a super user
docker-compose run esup-pod python manage.py createsuperuser --username <username> --email <email>
# Create elastic index
docker-compose run esup-pod python manage.py create_pod_index
# Get the id of pod user within esup-pod container
docker-compose run esup-pod id
# adapt based on the outcome of previous entry
sudo chown <pod-user-id>:<pod-group-id> static media socket
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
## To do
Support https as we're using a proxy path in our case.
In case you add https support, think about updating settings_local.py.
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

## Credit
Another docker-compose that helped me on the way: https://plmlab.math.cnrs.fr/docker-images/esup-pod
The official installation guide for v2: https://www.esup-portail.org/wiki/display/ES/installation

