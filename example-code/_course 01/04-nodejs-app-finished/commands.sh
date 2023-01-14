docker build -t feedback-node .
docker run -p 3000:80 -d --name feedback-app --rm feedback-node