# docker_hls
Docker image that installs Ubuntu Trusty and a LEMP environment to run a HLS project.

Setup
-----

Clone the repository
```
git clone https://github.com/wlalele/docker_hls.git
```
Change Directory
```
cd docker_hls
```
Edit the Dockerfile (if you want/need)

Build image from Dockerfile
```
docker build -t="hls" .
```
Run image
```
docker run -d -it hls
```
You should see a container running when you type:
```
docker ps
```
To access the container ssh:
```
docker attach {container_id / container_name}
```
