# below example will work because it is using named volume, which will preserve the data

docker build -t feedback-node:volumes .
docker run -p 3000:80 -d --name feedback-app --rm -v feedback:/app/feedback feedback-node:volumes


##open in browser
http://localhost:3000/
http://localhost:3000/feecback/[title]