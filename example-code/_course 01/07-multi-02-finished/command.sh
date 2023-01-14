docker network create goals-network

docker run --name mongodb -v data:/data/db -rm -d -network goals-network -e MONGO_INITDB_ROOT_USERNAME=max -e MONGO_INITDB_ROOT_PASSWORD=secret mongo

docker build -t goals-node backend/.
docker run --name goals-backend -V d:/workspace/ex/backend:/app -v logs:/app/logs -v /app/node_modules -e MONGODB_USERNAME=max --rm -d -network goals-network goals-node


docker build -t goals-react frontend/.
docker run --name goals-frontend -v d:/workspace/ex/frontend:/app --rm -it -p 3000:3000 goals-react
