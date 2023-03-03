FROM node:16-alpine

ENV NODE_ENV=production

WORKDIR /usr/src/app

# Copies package.json AND package-lock.json.
COPY package*.json ./

RUN npm install
RUN npm ci --only=production

COPY . .

EXPOSE 8080

CMD [ "node", "app.js" ]