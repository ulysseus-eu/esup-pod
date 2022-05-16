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
# Go !
docker-compose run esup-pod python manage.py createsuperuser --username <username> --email <email>
docker-compose run esup-pod python manage.py create_pod_index
docker-compose run esup-pod id
# adapt based on the outcome of previous entry
sudo chown 1000:1000 static media
docker-compose run esup-pod python manage.py collectstatic
docker-compose up -d
```
