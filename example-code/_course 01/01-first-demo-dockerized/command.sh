docker build -t typical-image .
docker run -p 3000:3000 --name typical-container typical-image
