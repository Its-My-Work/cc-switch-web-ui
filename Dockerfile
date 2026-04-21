# Этап сборки (build)
FROM node:20-alpine AS build

# Рабочая директория
WORKDIR /app

# Копируем только package*.json для кеша npm ci
COPY package*.json ./

# Ставим ВСЕ зависимости, включая dev (vite, tsx, typescript и т.п.)
RUN npm ci

# Копируем остальной код
COPY . .

# Собираем клиент и сервер
RUN npm run build

# Этап рантайма (production)
FROM node:20-alpine AS runtime

WORKDIR /app

ENV NODE_ENV=production

# Ставим только прод-зависимости
COPY package*.json ./
RUN npm ci --omit=dev

# Копируем собранный сервер + фронт из build-стейджа
COPY --from=build /app/dist ./dist

# Порт из package.json / сервера
EXPOSE 3010

# Запускаем продовый сервер
CMD ["npm", "start"]
