FROM node:20-alpine AS build

WORKDIR /app

# сначала только package*.json, чтобы кешировалось
COPY package*.json ./

# ставим ВСЕ зависимости, включая dev (vite)
RUN npm ci

# теперь весь код
COPY . .

# сборка клиента и сервера
RUN npm run build

# продовый рантайм
FROM node:20-alpine AS runtime

WORKDIR /app

ENV NODE_ENV=production

# только прод-зависимости
COPY package*.json ./
RUN npm ci --omit=dev

# копируем собранный server + статик
COPY --from=build /app/dist ./dist

EXPOSE 3010
CMD ["npm", "start"]
