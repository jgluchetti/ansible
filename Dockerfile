FROM golang:1.15.7-buster AS compiler
RUN mkdir /app
ADD main.go /app
WORKDIR /app
RUN go build -o goapp .

FROM nginx:latest
WORKDIR /app/
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=compiler /app .
EXPOSE 8080:80
ADD script.sh /app/
RUN chmod +x /app/script.sh
CMD /app/script.sh

