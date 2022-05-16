# esup-pod
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
# Coolect all static files to be served by nginx
docker-compose run esup-pod python manage.py collectstatic
docker-compose up -d
```
 ## To do
Support https  

