FROM node:20-alpine AS runtime

WORKDIR /app
ENV NODE_ENV=production

COPY package*.json ./
RUN npm ci --omit=dev

COPY --from=build /app/dist ./dist

# Костыль: сделать index.html там, где его ищет сервер
RUN ln -s /app/dist/index.html /app/index.html

EXPOSE 3010
CMD ["npm", "start"]
