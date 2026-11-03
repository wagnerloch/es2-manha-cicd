# Estágio 1: Build
FROM node:20-alpine AS builder

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia os arquivos package.json e package-lock.json para o contêiner
COPY package*.json ./

# Instala as dependências do projeto
RUN npm install

# Copia o restante dos arquivos do projeto para o contêiner
COPY . .

# Compila o projeto TypeScript
RUN npm run build

# Estágio 2: Produção
FROM node:20-alpine

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia apenas os arquivos necessários do estágio de build
COPY --from=builder /app/package*.json ./

# Instala apenas as dependências de produção
RUN npm install --only=production

# Copia os arquivos compilados do estágio de build
COPY --from=builder /app/dist ./dist

# Expõe a porta em que a aplicação irá rodar
EXPOSE 3000

# Define o comando para iniciar a aplicação
CMD ["node", "dist/index.js"]