ssh -i "xx" xx.amazonaws.com
sudo amazon-linux-extras install docker

docker build . -t aqutaishat/simple-node-one-html-page
docker run -p 5000:80 --name test-node-one-page -d --rm aqutaishat/simple-node-one-html-page

docker push aqutaishat/simple-node-one-html-page
sudo systemctl start docker
sudo docker run aqutaishat/simple-node-one-html-page
