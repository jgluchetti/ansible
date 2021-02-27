FROM golang:golang:1.15.7-buster AS compiler
RUN mkdir /app
ADD main.go /app
WORKDIR /app
RUN go build
