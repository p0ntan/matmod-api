FROM node:18-slim

WORKDIR /express

COPY ./package*.json .

RUN npm install
