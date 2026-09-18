FROM node:20-alpine

WORKDIR /app

COPY services/backend/package*.json ./
RUN npm install --production

COPY services/backend .

RUN mkdir -p uploads

EXPOSE 5000

CMD ["node", "src/server.js"]