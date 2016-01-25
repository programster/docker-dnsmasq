REGISTRY="programster"
PROJECT_NAME="dnsmasq"
docker build --pull --no-cache --tag $REGISTRY/$PROJECT_NAME .
docker push $REGISTRY/$PROJECT_NAME

