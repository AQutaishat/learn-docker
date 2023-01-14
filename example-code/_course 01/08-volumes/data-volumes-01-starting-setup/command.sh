# when removing and starting container again, data will be removed
# we should presist data using volumes

docker build -t feedback-node:volumes .
docker run -p 3000:80 -d --name feedback-app --rm feedback-node:volumes


##open in browser
http://localhost:3000/
http://localhost:3000/feecback/[title]

docker build -t feedback-node .
docker run -p 3000:80 -d --name feedback-app --rm feedback-node


##open in browser
http://localhost:3000/
http://localhost:3000/feecback/[title]