FROM node:20-bookworm

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Сборка production-бандла
RUN npm run build

ENV NODE_ENV=production
ENV PORT=3010
ENV HOST=0.0.0.0

EXPOSE 3010

CMD ["npm", "start"]
