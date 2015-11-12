FROM node:0.12.7
ADD https://github.com/philipz/posland/archive/0.0.2.tar.gz /
RUN tar zxvf 0.0.2.tar.gz
RUN mv posland-0.0.2 app
WORKDIR /app
RUN npm install && npm install -g livescript
# Define default command.
CMD ["npm", "start"]
