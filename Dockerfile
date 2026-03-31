# Stage 1: Build the React application
FROM node:20-alpine AS build
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
# For Vite-based React apps, this usually creates a 'dist' folder
# For Create-React-App, this creates a 'build' folder
RUN npm run build

# Stage 2: Serve the application using Nginx
FROM nginx:stable-alpine

# Copy the build output to the Nginx html folder
# VERSION CHECK: 
# Use /app/dist if using Vite (Standard in 2026)
# Use /app/build if using Create-React-App (Legacy)
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]