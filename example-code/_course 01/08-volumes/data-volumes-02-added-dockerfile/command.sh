# below approach will not work, because in dockefile the volume binding is
# annonmus, it will be removed when removing teh containers

docker build -t feedback-node:volumes .
docker run -p 3000:80 -d --name feedback-app --rm feedback-node:volumes


##open in browser
http://localhost:3000/
http://localhost:3000/feecback/[title]