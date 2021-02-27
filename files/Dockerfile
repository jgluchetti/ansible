# Build golang image
FROM golang:1.15.7-buster
# copy go file to container
RUN mkdir /app
ADD . /app
WORKDIR /app
# build go binary
RUN go build
# expose go app port 8080
EXPOSE 8080
# run go application
CMD ["./app"]
