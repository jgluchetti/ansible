FROM golang:1.15.7-buster
RUN mkdir /app
ADD . /app
WORKDIR /app
RUN go build
EXPOSE 8080
CMD ["./app"]
