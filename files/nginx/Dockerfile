# Getting latest nginx image
FROM nginx:latest   
# Expose port 80   
EXPOSE 80
# Copy ssl self signed cert and key to container
COPY nginx-selfsigned.crt /etc/nginx/
COPY nginx-selfsigned.key /etc/nginx/
# Copy nginx.conf to override nginx configuration inside container
COPY nginx.conf /etc/nginx/nginx.conf
