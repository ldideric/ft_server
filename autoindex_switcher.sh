
CONTAINER_ID=$(docker container ls | grep "ft_server" | tr " " \\n | head -1)

docker exec -it $CONTAINER_ID bash srcs/autoindex.sh $1